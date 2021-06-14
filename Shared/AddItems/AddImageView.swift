//
//  AddImageView.swift
//  Geshtald
//
//  Created by Ivan Pryadchenko on 14.06.2021.
//

import SwiftUI

struct AddImageView: View {
    @Binding var image: UIImage
    @State var showImagePicker: Bool = false
    
    var body: some View {
        
        if image == defaultImage {
            GeometryReader { geometry in
                Button {
                    self.showImagePicker = true
                } label: {
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.secondary.opacity(0.3))
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.accentColor)
                    }
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePickerView(sourceType: .photoLibrary) { image in
                        self.image = image
                    }
                    .onDisappear(perform: { showImagePicker = false })
                }
            }
        } else {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(20)
        }
    }
}

struct AddImageView_Previews: PreviewProvider {
    static var previews: some View {
        AddImageView(image: .constant(UIImage(systemName: "heard")!))
    }
}
