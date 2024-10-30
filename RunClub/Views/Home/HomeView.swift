import SwiftUI
import Foundation

struct HomeView: View {
    @StateObject private var viewModel = HomeFeedViewModel()
    @ObservedObject var authViewModel: AuthViewModel
    let dateFormatter = DateFormatterService()
    
    private func getSortedItems() -> [HomeFeedItem] {
        viewModel.feedItems.sorted { $0.date > $1.date }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 40)
                } else {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome back")
                                .font(.title2)
                            Text("\(viewModel.currentUser?.username ?? "runner")")
                                .font(.title.bold())
                                .foregroundColor(Color("MossGreen"))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        
                        LazyVStack(spacing: 24) {
                            ForEach(getSortedItems()) { item in
                                FeedItemView(item: item)
                            }
                        }
                        
                        if viewModel.feedItems.isEmpty && !viewModel.isLoading {
                            EmptyFeedView()
                        }
                        
//                        if let error = viewModel.error {
//                            Text(Stringerror)
//                                .foregroundColor(.red)
//                                .padding()
//                        }
                    }
                    .padding(.vertical)
                }
            }
            .refreshable {
                await viewModel.loadContent()
            }
        }
        .onAppear {
            Task {
                await viewModel.loadContent()
            }
        }
    }
}
