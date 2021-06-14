//
//  AddItemView.swift
//  GeshtaldList
//
//  Created by Work on 27.01.2021.
//

import SwiftUI

let defaultImage = UIImage(systemName: "plus.circle")!

struct AddItemView: View {

    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var isShown: Bool
    @State var priority: Int
    @State var name: String = ""
    @State var description: String = ""
    @State var selectedType: Int = 0
    @State var image: UIImage = defaultImage
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    Form {
                        Section(header: Label("Enter Geshtald Item Information", systemImage: "note.text")) {
                            HStack {
                                Text("Name")
                                TextField("Enter Name", text: $name)
                                    .font(.body)
                            }
                            HStack(alignment: .center) {
                                Text("Description")
                                ZStack(alignment: .leading) {
                                    if description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                        Text("Long Text Field")
#if os(iOS)
                                            .foregroundColor(Color(UIColor.placeholderText))
#elseif os(macOS)
                                            .foregroundColor(Color(NSColor.placeholderTextColor.cgColor))
#endif
//                                            .padding(.top, 8)
                                    }
                                    TextEditor(text: $description)
                                        .padding(.leading, -3)
                                }
                            }
                            HStack {
                                Picker(selection: $selectedType, label: Text("Type")) {
                                    ForEach(0 ..< GeshtaldItem.availableTypes.count) {
                                        Label(GeshtaldItem.availableTypes[$0].0, systemImage: GeshtaldItem.availableTypes[$0].1)
                                    }
                                }
                            }
                        }
                        
                        Section(header: Label("Image", systemImage: "photo.on.rectangle")) {
                            if image == defaultImage {
                                AddImageView(image: $image)
                                    .frame(width: min(geometry.size.width, geometry.size.height) - 80.0, height: min(geometry.size.width, geometry.size.height) - 80.0)
                            } else {
                                AddImageView(image: $image)
                            }
                        }
                    }
                    Spacer()
                }
            }
            .navigationBarTitle(Text("Creation"), displayMode: .inline)
            .navigationBarItems(leading: Button("Back") {
                isShown.toggle()
            }, trailing:
                Button("Create") {
                    onAdd()
                    isShown.toggle()
                })
        }
    }
    
    private func onAdd() {
        withAnimation {
            let newItem = GeshtaldItem(context: viewContext)
            newItem.id = UUID()
            newItem.name = name
            newItem.info = description
            newItem.imageData = image.pngData()
            newItem.type = Int64(selectedType)
            newItem.priority = Int64(priority)
            
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

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView(isShown: .constant(true), priority: 0, image: UIImage(systemName: "plus.circle")!)
    }
}
