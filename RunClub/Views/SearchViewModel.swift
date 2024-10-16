//
//  SearchViewModel.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var isActive: Bool = false
    @Published var searchQuery: String = ""
}
