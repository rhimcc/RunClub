//
//  SearchView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var searchViewModel: SearchViewModel = SearchViewModel()
    var body: some View {
        SearchBar(searchViewModel: searchViewModel)
        
        if (searchViewModel.isActive) {
            SearchResultsView(searchViewModel: searchViewModel)
        } else {
            Text("Place holder !! CHANGE")
        }
    }
}

#Preview {
    SearchView()
}
