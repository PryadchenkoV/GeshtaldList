//
//  AddItemView.swift
//  GeshtaldList
//
//  Created by Work on 27.01.2021.
//

import SwiftUI

let defaultImage = UIImage(systemName: "plus.circle")!

struct AddItemView: View {

    @Binding var isShown: Bool
    @State var name: String = ""
    @State var description: String = ""
    @State var selectedType: Int = 0
    @State var image: UIImage = defaultImage
    
    @ObservedObject var geshtaldModel: GeshtaldModel
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    Form {
                        Section(header: Label("add_item_header_main", systemImage: "note.text")) {
                            HStack {
                                Text("name_title")
                                TextField("name_placeholder", text: $name)
                                    .font(.body)
                            }
                            HStack(alignment: .center) {
                                Text("description_title")
                                ZStack(alignment: .leading) {
                                    if description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                        Text("description_placeholder")
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
                                Picker(selection: $selectedType, label: Text("type_title")) {
                                    ForEach(0 ..< GeshtaldItem.availableTypes.count) {
                                        Label(GeshtaldItem.availableTypes[$0].0, systemImage: GeshtaldItem.availableTypes[$0].1)
                                    }
                                }
                            }
                        }
                        
                        Section(header: Label("add_item_header_image", systemImage: "photo.on.rectangle")) {
                            if image == defaultImage {
                                AddImageView(image: $image)
                                    .frame(width: abs(min(geometry.size.width, geometry.size.height) - 80.0), height: abs(min(geometry.size.width, geometry.size.height) - 80.0))
                            } else {
                                AddImageView(image: $image)
                            }
                        }
                        Section {
                            Button("button_create_title") {
                                onAdd()
                                isShown.toggle()
                            }
                            .disabled(name.count == 0)
                            Button("button_cancel_title") {
                                isShown.toggle()
                            }
                            .foregroundColor(.red)
                        }
                    }
                    Spacer()
                }
            }
            .navigationBarTitle(Text("add_item_navigation_title"), displayMode: .inline)
            .navigationBarItems(leading: Button("add_item_navigation_back_button") {
                isShown.toggle()
            }, trailing:
                Button("add_item_navigation_create_button") {
                    onAdd()
                    isShown.toggle()
                }
                .disabled(name.count == 0)
            )
                
        }
    }
    
    private func onAdd() {
        withAnimation {
            geshtaldModel.addItem(withName: name,
                                  description: description,
                                  imageData: image == defaultImage ? nil : image.pngData(),
                                  type: Int64(selectedType))
        }
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView(isShown: .constant(true), image: UIImage(systemName: "plus.circle")!, geshtaldModel: GeshtaldModel(context: PersistenceController.preview.container.viewContext))
    }
}
