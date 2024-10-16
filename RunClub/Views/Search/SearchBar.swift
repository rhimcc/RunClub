//
//  SearchBar.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import SwiftUI

struct SearchBar: View {
    @ObservedObject var searchViewModel: SearchViewModel
    var body: some View {
        EmptyView()
            .searchable(text: $searchViewModel.searchQuery, isPresented: $searchViewModel.isActive)
    }
}

#Preview {
    SearchBar(searchViewModel: SearchViewModel())
}
