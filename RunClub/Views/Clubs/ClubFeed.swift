//
//  ClubFeed.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import SwiftUI

struct ClubFeed: View {
    var club: Club
    let firestore = FirestoreService()
    @State var posts: [Post] = []
    @State var isLoading: Bool = false
    @State var text: String = ""
    var body: some View {
        ScrollView {
            HStack {
                TextField("Message", text: $text)
                Button ("Post"){
                    if let clubId = club.id {
                        let post = Post(messageContent: text, posterId: User.getCurrentUserId(), clubId: clubId)
                        firestore.storePost(post: post)
//                        posts.append(post)
                    }
                    
                }
            }
            VStack {
                ForEach(posts) { post in
                    PostView(post: post)
                }
            }.padding()
        }.refreshable {
            print("fetching posts")
            fetchPosts()
            print(posts.count)
        }
        .onAppear {
            fetchPosts()
        }
    
    }
    
    private func fetchPosts() {
        // Assuming the club has postIds that you want to use to fetch posts
        let postIDs = club.postIds
        
        let group = DispatchGroup() // To manage multiple fetch requests
//        var fetchedPosts: [Post] = []
        
        if let clubId = club.id {
//            group.enter() // Enter the group for each fetch
            firestore.getAllPostsForClub(clubId: clubId) { fetchedPosts, error in
                if let posts = fetchedPosts {
                    self.posts = posts
                }
//                group.leave() // Leave the group after the fetch completes
            }
//            group.notify(queue: .main) { // Notify when all fetch requests are done
//                self.posts = fetchedPosts
//                self.isLoading = false
//            }
        }

    }
    
    
}

//#Preview {
//    ClubFeed()
//}
