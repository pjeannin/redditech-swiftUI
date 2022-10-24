//
//  SearchViewModel.swift
//  Redditech
//
//  Created by Pierre Jeannin on 15/10/2022.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchedText: String = ""
}
