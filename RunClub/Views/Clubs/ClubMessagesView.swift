//
//  ClubMessagesView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 24/10/2024.
//

import SwiftUI

struct ClubMessagesView: View {
    let firestore = FirestoreService()
    var club: Club
    @State var message: String = ""
    @State var messages: [Post] = []
    var body: some View {
        ScrollView {
            HStack {
                TextField("Post Something...", text: $message)
                    .textFieldStyle(.roundedBorder)
                Button {
                     if let id = club.id {
                        let newPost = Post(messageContent: message, posterId: User.getCurrentUserId(), clubId: id)
                        firestore.storePost(post: newPost)
                        messages.append(newPost)
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundStyle(.white)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(RoundedRectangle(cornerRadius: 20).fill(.mossGreen))
                }
            }.padding(.horizontal)
            .padding(.bottom, 20)
            
            ForEach(messages) { message in
                PostView(post: message)
                    .padding(.bottom, 10)
                
            }
            
        }
        .onAppear {
            loadMessages()
        }
    }
    func loadMessages() {
        if let id = club.id {
            firestore.getAllPostsForClub(clubId: id) { fetchedPosts, error in
                DispatchQueue.main.async {
                    if let fetchedPosts = fetchedPosts {
                        self.messages = fetchedPosts
                    }
                }
                
            }
        }
    }
}

//#Preview {
//    ClubMessagesView()
//}
