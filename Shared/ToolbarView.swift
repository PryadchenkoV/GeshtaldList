//
//  ToolbarView.swift
//  Geshtald
//
//  Created by Work on 12.03.2021.
//

import SwiftUI

struct ToolbarView: View {
    
    @Binding var isCreateSheetPresented: Bool
    
    var body: some View {
        HStack {
            Button(action: { isCreateSheetPresented = true }, label: {
                Text("Add")
            })
            Spacer()
            EditButton()
        }
        .padding(.all, 8.0)
    }
}


struct ToolbarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarView(isCreateSheetPresented: .constant(true))
    }
}
