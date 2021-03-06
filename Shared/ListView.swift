//
//  ContentView.swift
//  Shared
//
//  Created by Work on 11.03.2021.
//

import SwiftUI
import CoreData

@available(iOS 15.0, *)
struct ListView: View {

    @State var isCreateSheetPresented = false
    @State var isFiltered = false
    @State var isSorted = false
    @State var sortOrderAscending = true
    @ObservedObject var geshtaldModel: GeshtaldModel
    
    private var requiredArrayOfItems: [GeshtaldItem] {
        return geshtaldModel.searchString.isEmpty ? geshtaldModel.allItems : geshtaldModel.searchItems
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if geshtaldModel.allItems.count == 0 {
                    EmptyView(isCreateSheetPresented: $isCreateSheetPresented)
                } else {
                    ZStack(alignment: .bottom) {
                        List {
                            if isFiltered {
                                ForEach(GeshtaldItem.availableTypes, id: \.0, content: { item in
                                    
                                    let filteredItems = requiredArrayOfItems.filter({ $0.convertIntTypeToString == item.0 })
                                    
                                    if filteredItems.count != 0 {
                                        Section(header:
                                                    Label(item.0, systemImage: item.1))
                                        {
                                            ForEach(filteredItems) { item in
                                                ListItemView(item: item, geshtaldModel: geshtaldModel)
                                                    .moveDisabled(geshtaldModel.isSorted)
                                                    .swipeActions {
                                                        Button { [item] in
                                                            geshtaldModel.changeFavoriteState(item)
                                                        } label: {
                                                            Image(systemName: "star.fill")
                                                        }
                                                        .tint(.yellow)
//
                                                        Button(role: .destructive) {
                                                            geshtaldModel.delete(items: filteredItems.map({ $0 }))
                                                        } label: {
                                                            Image(systemName: "trash.fill")
                                                        }
                                                    }
                                            }
                                            .onDelete {_ in
                                                geshtaldModel.delete(items: filteredItems.map({ $0 }))
                                            }
                                            .onMove {
                                                geshtaldModel.move(items: filteredItems.map({ $0 }),
                                                                                source: $0,
                                                                                destination: $1)
                                            }
                                        }
                                    }
                                })
                            } else {
                                ForEach(requiredArrayOfItems) { item in
                                    ListItemView(item: item, geshtaldModel: geshtaldModel)
                                        .moveDisabled(geshtaldModel.isSorted)
                                        .swipeActions {
                                            Button { [item] in
                                                geshtaldModel.changeFavoriteState(item)
                                            } label: {
                                                Image(systemName: "star.fill")
                                            }
                                            .tint(.yellow)
//
                                            Button(role: .destructive) {
                                                geshtaldModel.delete(items: requiredArrayOfItems.map({ $0 }))
                                            } label: {
                                                Image(systemName: "trash.fill")
                                            }
                                        }
                                }
                                .onDelete {_ in
                                    geshtaldModel.delete(items: requiredArrayOfItems.map({ $0 }))
                                }
                                .onMove {
                                    geshtaldModel.move(items: requiredArrayOfItems.map({ $0 }),
                                                          source: $0,
                                                          destination: $1)
                                }
                            }
                        }
                        .searchable(text: $geshtaldModel.searchString) {
                            SearchSuggestionsView(allItems: geshtaldModel.allItems,
                                                  searchString: geshtaldModel.searchString)
                        }
                        .onSubmit(of: .search) {
                            geshtaldModel.fetchSearchItems()
                        }
                        FilterView(isFiltered: $isFiltered, isSorted: $geshtaldModel.isSorted, sortOrderAscending: $geshtaldModel.sortOrderAscending)
                    }
                    Divider()
                    ToolbarView(isCreateSheetPresented: $isCreateSheetPresented)
                }
            }
            .sheet(isPresented: $isCreateSheetPresented, onDismiss: {
                self.isCreateSheetPresented = false
            }, content: {
                AddItemView(isShown: $isCreateSheetPresented, geshtaldModel: geshtaldModel)
            })
            .listStyle(PlainListStyle())
            .navigationBarTitle("list_view_navigation_title", displayMode: .large)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct SearchSuggestionsView: View {
    
    @State var allItems: [GeshtaldItem]
    @State var searchString: String
    
    var body: some View {
        ForEach(allItems) { item in
            if item.name.localizedStandardContains(searchString) {
                Text(item.name).searchCompletion(item.name)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            ListView(geshtaldModel: GeshtaldModel(context: PersistenceController.preview.container.viewContext)).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        } else {
            // Fallback on earlier versions
        }
    }
}
