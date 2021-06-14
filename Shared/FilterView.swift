//
//  FilterView.swift
//  GeshtaldList
//
//  Created by Work on 06.03.2021.
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct FilterView: View {
    
    @Binding var isFiltered: Bool
    static let kMaxHeight: CGFloat = 150.0
    static let kMinHeight: CGFloat = 20.0
    @State var currentHeight: CGFloat = kMinHeight
    @State var lastDragPosition: DragGesture.Value?
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0.0) {
                Capsule()
                    .frame(width: 50, height: 10, alignment: .center)
                    .foregroundColor(.secondary)
                    .padding(.all, 5.0)
                Toggle("Filter", isOn: $isFiltered)
                    .padding()
            }
        }
        .frame(height:currentHeight)
        .background(Color(red: 220/255, green: 220/255, blue: 220/255))
        .cornerRadius(15.0, corners: [.topLeft, .topRight])
        .gesture(DragGesture()
                    .onChanged { value in
                        lastDragPosition = value
                        let newHeight = self.currentHeight - (value.location.y - value.startLocation.y)
                        if newHeight > FilterView.kMinHeight && newHeight < FilterView.kMaxHeight {
                            self.currentHeight = newHeight
                        } else if newHeight > FilterView.kMaxHeight {
                            self.currentHeight = FilterView.kMaxHeight
                        } else {
                            self.currentHeight = FilterView.kMinHeight
                        }
                    }
                    .onEnded { value in
                        if self.currentHeight >= FilterView.kMaxHeight / 2.0 {
                            withAnimation(.default, { self.currentHeight = FilterView.kMaxHeight })
                        } else {
                            withAnimation(.default, { self.currentHeight = FilterView.kMinHeight })
                        }
                    }
        )
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(isFiltered: .constant(false))
    }
}
