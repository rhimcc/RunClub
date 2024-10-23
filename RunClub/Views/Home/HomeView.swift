//
//  HomeView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 15/10/2024.
//

import SwiftUI

struct HomeView: View {
    @State var clubs: [Club] = []
    @ObservedObject var authViewModel: AuthViewModel
    @State var posts: [Post] = []
    let firestore = FirestoreService()
    @State var isLoading: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Run Club")
                        .font(.title)
                    Spacer()
                
                    NavigationLink {
                        SearchView(searching: "")
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.lightGreen)
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.white)
                                .bold()
                            
                        }
                    }
                    NavigationLink {
                        //ChatView()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.lightGreen)
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "message")
                                .foregroundStyle(.white)
                                .bold()
                        }
                    }
                }.padding()
                
//                if (isLoading) {
//                    Spacer()
//                    ProgressView()
//                        .progressViewStyle(.circular)
//                    Spacer()
//                } else {
//                    ScrollView {
//                        ForEach(posts) { post in
//                            PostView(post: post)
//                        }
//                    }
//                }
            }
        }.onAppear {
            fetchPosts()
        }.padding()
    }
    
    func fetchPosts() {
        self.isLoading = true
        self.posts = [] // Clear existing posts

        firestore.getClubs { fetchedClubs in
            DispatchQueue.main.async {
                self.clubs = fetchedClubs
                let group = DispatchGroup()
                for club in self.clubs {
                    for postId in club.postIds {
                        group.enter()
                        self.firestore.getPostByID(id: postId) { post in
                            if let post = post {
                                DispatchQueue.main.async {
                                    if !self.posts.contains(where: { $0.id == post.id }) {
                                        self.posts.append(post)
                                    }
                                }
                            }
                            group.leave()
                        }
                    }
                }
                group.notify(queue: .main) {
                    self.isLoading = false
                }
            }
        }
    }
}

#Preview {
    HomeView(authViewModel: AuthViewModel())
}
