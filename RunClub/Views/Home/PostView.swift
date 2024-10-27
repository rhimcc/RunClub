//
//  MessageView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import SwiftUI

struct MessageView: View {
    var message: Message
    let firestore = FirestoreService()
    @State var user: User? = nil
    var club: Club?
    var body: some View {
        VStack {
            HStack (alignment: .bottom) {
                ZStack {
                    Circle()
                        .fill(.gray)
                        .frame(width: 30, height: 30)
                    Text("pfp")
                }
                VStack {
                    Spacer()
                    HStack {
                        if let user = user, let firstName = user.firstName, let lastName = user.lastName {
                            Text(firstName)
                            Text(lastName)
                        }
                        Spacer()
                        VStack {
                            Text("\(message.getTimeString())")
                            Spacer()
                        }
                    }
                    if let club = club {
                        HStack {
                            Text(club.name)
                            Spacer()
                        }
                    }
                }
                
            }
            Text(message.messageContent)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background (
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.2), radius: 5)
                )

        }.padding(.horizontal)
           
        .onAppear {
            getPoster()
        }
    }
    
    func getPoster() {
        firestore.getUserByID(id: message.posterId) { fetchedUser in
            DispatchQueue.main.async {
                self.user = fetchedUser
            }
            
        }
    }
}
//
//#Preview {
//    PostView(post: Post(id: "123", messageContent: "fewhuij", posterId: "32rtgre", clubId: "t4grf"))
//}
