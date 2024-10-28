import SwiftUI

struct PostView: View {
    let dateFormatter = DateFormatterService()
    var message: Message
    let firestore = FirestoreService()
    @State var user: User? = nil
    var club: Club?
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Circle()
                .fill(Color("lightGreen"))
                .frame(width: 36, height: 36)
                .overlay(
                    Group {
                        if let user = user {
                            Text(user.username.prefix(1).uppercased())
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color("MossGreen"))
                        } else {
                            Text("?")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color("MossGreen"))
                        }
                    }
                )
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    if let user = user {
                        Text(user.username)
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    Text(dateFormatter.getTimeString(date: message.timePosted))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(message.messageContent)
                    .font(.body)
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("lightGreen").opacity(0.1))
        )
        .padding(.horizontal)
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
