//
//  ResultRow.swift
//  RunClub
//
//  Created by Rhianna McCormack on 28/10/2024.
//

import SwiftUI

struct ResultRow: View {
    let firestore = FirestoreService()
    var run: Run
    var index: Int
    let dateFormatter = DateFormatterService()
    @State var runner: User?
    var body: some View {
        HStack {
            if let runner = runner, let firstName = runner.firstName, let lastName = runner.lastName {
                Text(firstName + " " + lastName)
            }
            Spacer()
            Text(dateFormatter.getTimeFromSeconds(seconds: Float(run.elapsedTime)))
        }.padding()
        .background {
            Rectangle()
                .fill(index % 2 == 0 ? Color.lighterGreen.opacity(0.3) : Color.lighterGreen)
                .frame(maxWidth: .infinity)
        }
        .onAppear {
            loadRunner()
        }
    }
    
    func loadRunner() {
        let runnerId = run.runnerId
        firestore.getUserByID(id: runnerId) { runner in
            DispatchQueue.main.async {
                self.runner = runner
            }
        }
    }
}

//#Preview {
//    ResultRow()
//}
