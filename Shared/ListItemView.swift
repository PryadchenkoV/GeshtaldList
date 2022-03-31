//
//  ListItemView.swift
//  GeshtaldList
//
//  Created by Work on 21.01.2021.
//

import SwiftUI

struct ListItemView: View {
    
    var item: GeshtaldItem
    @ObservedObject var geshtaldModel: GeshtaldModel
    
    var body: some View {
        HStack(alignment: .center) {
            if item.imageData == nil {
                Image(systemName: "questionmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            } else {
                Image(uiImage: UIImage(data: item.imageData!)!)
                    .resizable()
                    .cornerRadius(5)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.title)
                Text(item.convertIntTypeToString)
                    .font(.footnote)
                    
            }
            Spacer()
            Button {
                geshtaldModel.changeFavoriteState(item)
            } label: {
                Group {
                    if item.isFavorite {
                        Image(systemName: "star.fill")
                    } else {
                        Image(systemName: "star")
                    }
                }
                .foregroundColor(.yellow)
            }
            
        }
    }
}

struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemView(item: GeshtaldItem(), geshtaldModel: GeshtaldModel(context: PersistenceController.preview.container.viewContext))
    }
}
