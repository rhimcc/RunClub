//
//  Line.swift
//  RunClub
//
//  Created by Rhianna McCormack on 15/10/2024.
//

import SwiftUI

struct Line: View {
    var body: some View {
        Rectangle()
            .fill(.black)
            .frame(width: UIScreen.main.bounds.width, height: 2)
    }
}

#Preview {
    Line()
}
