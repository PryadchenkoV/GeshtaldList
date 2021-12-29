//
//  EmptyView.swift
//  Geshtald
//
//  Created by Work on 12.03.2021.
//

import SwiftUI

struct EmptyView: View {
    
    @Binding var isCreateSheetPresented: Bool
    
    var body: some View {
        Spacer()
        Text("empty_list_title")
            .font(.largeTitle)
            .fontWeight(.thin)
            .multilineTextAlignment(.center)
        Button(action: { isCreateSheetPresented = true }, label: {
            Text("empty_list_add_button")
                .padding(.horizontal, 25.0)
                .background(Color.blue)
                .cornerRadius(5.0)
                .foregroundColor(.white)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            
        })
        .padding()
        Spacer()
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView(isCreateSheetPresented: .constant(true))
    }
}
