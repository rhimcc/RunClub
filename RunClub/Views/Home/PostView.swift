//
//  PostView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import SwiftUI

struct PostView: View {
    var post: Post
    let firestore = FirestoreService()
    @State var user: User? = nil
    var club: Club?
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Circle()
                        .fill(.gray)
                        .frame(width: 40, height: 40)
                    Text("pfp")
                }
                VStack {
                    HStack {
                        if let user = user, let firstName = user.firstName, let lastName = user.lastName {
                            Text(firstName)
                            Text(lastName)
                        }
                        Spacer()
                        Text("time")
                    }
                    if let club = club {
                        HStack {
                            Text(club.name)
                            Spacer()
                        }
                    }
                }
                
            }.padding(10)
            
            Text(post.messageContent)
                .padding()
        }.onAppear {
            getPoster()
        }
    
        .background(RoundedRectangle(cornerRadius: 20).stroke(.gray, lineWidth: 3))
    }
    
    func getPoster() {
        firestore.getUserByID(id: post.posterId) { fetchedUser in
            DispatchQueue.main.async {
                self.user = fetchedUser
            }
            
        }
    }
}

#Preview {
    PostView(post: Post(id: "123", messageContent: "fewhuij", posterId: "32rtgre", clubId: "t4grf"))
}
