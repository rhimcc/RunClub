//
//  SearchResultsView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import SwiftUI

struct SearchResultsView: View {
    @ObservedObject var searchViewModel: SearchViewModel
    var body: some View {
        Text("you are searching for: \(searchViewModel.searchQuery) in")
    }
}

#Preview {
    SearchResultsView(searchViewModel: SearchViewModel())
}
