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
    
    @ObservedObject var searchViewModel: SearchViewModel
    @Binding var showSearch: Bool
    let logout: () -> Void
    
    init(showSearch: Binding<Bool>, logout: @escaping () -> Void) {
        self.logout = logout
        self.searchViewModel = SearchViewModel(logout: logout)
        self._showSearch = showSearch
    }
    
    var body: some View {
        
        NavigationView {
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
                                    .onChange(of: searchViewModel.searchedText) { _ in
                                        searchViewModel.onSearchTextChange()
                                    }
                                    .onSubmit {
                                        searchViewModel.onSearchTextChange()
                                    }
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
                                searchViewModel.searchResult = []
                            }
                            .padding(.trailing)
                        }
                    }
                    if (searchViewModel.error) {
                        Text("An error occured. Please try again")
                            .foregroundColor(Color("LightRed"))
                    } else {
                        List(searchViewModel.searchResult) { elem in
                            NavigationLink {
                                SubredditDetailsView(of: elem.data.displayNamePrefixed, logout: logout)
                            } label: {
                                HStack {
                                    if let imgUrl: String = elem.data.communityIcon {
                                        AsyncImage(url: URL(string: imgUrl)){ image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .cornerRadius(15)
                                                .frame(width: 30, height: 30, alignment: .bottomTrailing)
                                                .layoutPriority(1)
                                                .padding(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 5))
                                        } placeholder: {
                                            Color.gray.opacity(0.1)
                                                .scaledToFit()
                                                .cornerRadius(15)
                                                .frame(width: 30, height: 30, alignment: .bottomTrailing)
                                                .layoutPriority(1)
                                                .padding(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 5))
                                        }
                                    }
                                    Text(elem.data.displayNamePrefixed)
                                    Spacer()
                                    Text("\(elem.data.subscribers ?? 0) sub")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(showSearch: .constant(true)) {}
    }
}
