//
//  ContentView.swift
//  Shared
//
//  Created by Work on 11.03.2021.
//

import SwiftUI
import CoreData

struct ListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \GeshtaldItem.priority, ascending: true)],
        animation: .default)
    private var items: FetchedResults<GeshtaldItem>
    @State var isCreateSheetPresented = false
    @State var isFiltered = false
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if items.count == 0 {
                    EmptyView(isCreateSheetPresented: $isCreateSheetPresented)
                } else {
                    ZStack(alignment: .bottom) {
                        List {
                            if isFiltered {
                                ForEach(GeshtaldItem.availableTypes, id: \.0, content: { item in
                                    
                                    let filteredItems = items.filter({ $0.convertIntTypeToString == item.0 })
                                    
                                    if filteredItems.count != 0 {
                                        Section(header:
                                                    Label(item.0, systemImage: item.1))
                                        {
                                            ForEach(filteredItems) {
                                                ListItemView(item: $0)
                                            }
                                            .onDelete(perform: onDelete(offsets:))
                                            .onMove(perform: onMove(source:destination:))
                                        }
                                    }
                                })
                            } else {
                                ForEach(items) {
                                    ListItemView(item: $0)
                                }
                                .onDelete(perform: onDelete(offsets:))
                                .onMove(perform: onMove(source:destination:))
                            }
                        }
                        .animation(.default)
                        FilterView(isFiltered: $isFiltered)
                    }
                    Divider()
                    ToolbarView(isCreateSheetPresented: $isCreateSheetPresented)
                }
            }
            .sheet(isPresented: $isCreateSheetPresented, onDismiss: {
                self.isCreateSheetPresented = false
            }, content: {
                AddItemView(isShown: $isCreateSheetPresented, priority: items.count)
            })
            .listStyle(PlainListStyle())
            .navigationBarTitle("Geshtald Item", displayMode: .large)
            .edgesIgnoringSafeArea(.top)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = GeshtaldItem(context: viewContext)
            newItem.name = "Date()"

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func onDelete(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func onMove(source: IndexSet, destination: Int) {
        withAnimation {
            var revisedItems = items.map{ $0 }
            revisedItems.move(fromOffsets: source, toOffset: destination )
            for reverseIndex in stride(from: revisedItems.count - 1, through: 0, by: -1 )
            {
                revisedItems[reverseIndex].priority =
                    Int64(reverseIndex)
            }
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
