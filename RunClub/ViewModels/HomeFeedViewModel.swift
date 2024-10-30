import Foundation


class HomeFeedViewModel: ObservableObject {
    @Published var feedItems: [HomeFeedItem] = []
    @Published var friends: [User] = []
    @Published var clubs: [Club] = []
    @Published var isLoading: Bool = false
    @Published var currentUser: User?
    @Published var error: String?
    
    let firestore = FirestoreService()
    
    private let recentRunsCutoff = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
    
    func loadContent() async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.error = nil
        }
        
        do {
            AuthViewModel().checkSignIn()
            await loadCurrentUser()
            await loadFriends()
            await loadUserClubs()
            await loadFeedContent()
        } catch {
            DispatchQueue.main.async {
                self.error = "Failed to load content: \(error.localizedDescription)"
            }
        }
        
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
    
    private func loadCurrentUser() async {
        return await withCheckedContinuation { continuation in
            firestore.getUserByID(id: User.getCurrentUserId()) { user in
                DispatchQueue.main.async {
                    self.currentUser = user
                }
                continuation.resume()
            }
        }
    }
    
    private func loadFriends() async {
        return await withCheckedContinuation { continuation in
            firestore.getFriendsOfUser(userId: User.getCurrentUserId()) { friends, error in
                DispatchQueue.main.async {
                    if let friends = friends {
                        self.friends = friends
                    }
                }
                continuation.resume()
            }
        }
    }
    
    private func loadUserClubs() async {
        return await withCheckedContinuation { continuation in
            firestore.getClubsForUser(userId: User.getCurrentUserId()) { clubs, error in
                DispatchQueue.main.async {
                    if let clubs = clubs {
                        self.clubs = clubs
                    }
                }
                continuation.resume()
            }
        }
    }
    
    private func loadFeedContent() async {
        guard let currentUser = currentUser else { return }
        
        var newItems: [HomeFeedItem] = []
        let dispatchGroup = DispatchGroup()
        
        // Load friends' recent runs first
        for friend in friends {
            if let friendId = friend.id {
                dispatchGroup.enter()
                firestore.getRunsOfUser(userId: friendId) { runs, error in
                    defer { dispatchGroup.leave() }
                    if let runs = runs {
                        let recentRuns = runs.filter { run in
                            run.startTime >= self.recentRunsCutoff
                        }.sorted(by: { $0.startTime > $1.startTime })
                        
                        // Add each recent run as a separate feed item
                        DispatchQueue.main.async {
                            newItems.append(contentsOf: recentRuns.map { .run($0, friend) })
                        }
                        
                        // Create weekly stats if there are runs this week
                        let thisWeekRuns = runs.filter { 
                            Calendar.current.isDate($0.startTime, equalTo: Date(), toGranularity: .weekOfYear)
                        }
                        if !thisWeekRuns.isEmpty {
                            DispatchQueue.main.async {
                                newItems.append(.weeklyStats(friend, thisWeekRuns))
                            }
                        }
                    }
                }
            }
        }
        
        // Load club events
        for club in clubs {
            if let clubId = club.id {
                dispatchGroup.enter()
                firestore.getAllEventsForClub(clubId: clubId) { events, error in
                    defer { dispatchGroup.leave() }
                    if let events = events {
                        // Only show upcoming events and recent past events
                        let relevantEvents = events.filter { event in
                            // Show all upcoming events
                            if event.date > Date() {
                                return true
                            }
                            // Show recent past events (within last 24 hours)
                            return Calendar.current.isDate(event.date, inSameDayAs: Date()) ||
                                   Calendar.current.isDateInYesterday(event.date)
                        }
                        
                        DispatchQueue.main.async {
                            newItems.append(contentsOf: relevantEvents.map { .event($0) })
                        }
                    }
                }
            }
        }
        
        // Add head-to-head comparisons
        dispatchGroup.notify(queue: .main) {
            self.firestore.getRunsOfUser(userId: User.getCurrentUserId()) { currentUserRuns, error in
                if let currentUserRuns = currentUserRuns {
                    for friend in self.friends {
                        if let friendId = friend.id {
                            self.firestore.getRunsOfUser(userId: friendId) { friendRuns, error in
                                if let friendRuns = friendRuns {
                                    // Only create comparison if both users have recent activity
                                    let hasRecentActivity = (currentUserRuns + friendRuns).contains { run in
                                        run.startTime >= self.recentRunsCutoff
                                    }
                                    
                                    if hasRecentActivity {
                                        DispatchQueue.main.async {
                                            newItems.append(.comparison(currentUser, friend, currentUserRuns, friendRuns))
                                            // Sort items with priority for recent runs
                                            self.feedItems = self.sortFeedItems(newItems)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func sortFeedItems(_ items: [HomeFeedItem]) -> [HomeFeedItem] {
        items.sorted { item1, item2 in
            // Prioritize recent runs
            switch (item1, item2) {
            case (.run(let run1, _), .run(let run2, _)):
                return run1.startTime > run2.startTime
                
            case (.run(let run, _), _):
                // If run is from last 24 hours, prioritize it
                if Calendar.current.isDate(run.startTime, inSameDayAs: Date()) ||
                   Calendar.current.isDateInYesterday(run.startTime) {
                    return true
                }
                return item1.date > item2.date
                
            case (_, .run(let run, _)):
                // If run is from last 24 hours, other item should come after
                if Calendar.current.isDate(run.startTime, inSameDayAs: Date()) ||
                   Calendar.current.isDateInYesterday(run.startTime) {
                    return false
                }
                return item1.date > item2.date
                
            default:
                return item1.date > item2.date
            }
        }
    }
}
