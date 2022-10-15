//
//  SearchView.swift
//  Redditech
//
//  Created by Pierre Jeannin on 15/10/2022.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var searchViewModel: SeaarchViewModel = SeaarchViewModel()
    
    var body: some View {
        Text("Search")
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
