//
//  SearchView.swift
//  Redditech
//
//  Created by Pierre Jeannin on 15/10/2022.
//

import SwiftUI

struct Element: Identifiable {
    let id = UUID()
    let name: String
}

struct SearchView: View {
    
    @ObservedObject var searchViewModel: SearchViewModel = SearchViewModel()
    @Binding var showSearch: Bool
    let fakeList: [Element] = [
        Element(name: "r/apple"),
        Element(name: "r/apple"),
        Element(name: "r/apple"),
        Element(name: "r/apple"),
        Element(name: "r/apple"),
        Element(name: "r/apple"),
        Element(name: "r/apple"),
        Element(name: "r/apple"),
        Element(name: "r/apple"),
        Element(name: "r/apple"),
        Element(name: "r/apple"),
        Element(name: "r/apple"),
        Element(name: "r/apple"),
        Element(name: "r/apple"),
        Element(name: "r/apple"),
        Element(name: "r/apple"),
        Element(name: "r/apple"),
        Element(name: "r/apple"),
        Element(name: "r/apple"),
        Element(name: "r/apple"),
        Element(name: "r/apple"),
        Element(name: "r/apple"),
        Element(name: "r/apple"),
        Element(name: "r/apple"),
        Element(name: "r/apple"),
        Element(name: "r/apple"),
    ]
    
    var body: some View {
        ZStack {
            Color("SecondaryColor")
                .ignoresSafeArea()
            VStack {
                HStack {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color.gray.opacity(0.2))
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("Search ...", text: $searchViewModel.searchedText)
                        }
                        .padding(.leading, 13)
                    }
                    .frame(height: 40)
                    .cornerRadius(13)
                    .padding()
                    if (searchViewModel.searchedText == "") {
                        Button("Cancel") {
                            showSearch = false
                        }
                        .padding(.trailing)
                    } else {
                        Button("Clear") {
                            searchViewModel.searchedText = ""
                        }
                        .padding(.trailing)
                    }
                }
                List(fakeList) { elem in
                    HStack {
                        Image(systemName: "apple.logo")
                        Text(elem.name)
                        Spacer()
                        Text("1M sub")
                    }
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(showSearch: .constant(true))
    }
}
