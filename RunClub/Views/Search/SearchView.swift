//
//  SearchView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var searchViewModel: SearchViewModel = SearchViewModel()
    var searching: String
    
    var body: some View {
        SearchBar(searchViewModel: searchViewModel)
        
        if (searchViewModel.isActive) {
            if (searching == "users") {
                UserSearchResultsView(searchViewModel: searchViewModel)
            } else if (searching == "clubs") {
                SearchResultsView(searchViewModel: searchViewModel)
            }
        } else {
            if (searching == "users") {
                UserList()
            } else if (searching == "clubs") {
                SuggestedClubs()
            }
        }
    }
}

#Preview {
    SearchView(searching: "clubs")
}
