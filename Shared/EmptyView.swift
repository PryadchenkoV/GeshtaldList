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
        Text("Your list is empty :(")
            .font(.largeTitle)
            .fontWeight(.thin)
            .multilineTextAlignment(.center)
        Button(action: { isCreateSheetPresented = true }, label: {
            Text("Add")
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
