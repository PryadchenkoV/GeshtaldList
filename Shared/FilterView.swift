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
    static let kMaxHeight: CGFloat = 170.0
    static let kMinHeight: CGFloat = 20.0
    
    @Binding var isFiltered: Bool
    @Binding var isSorted: Bool
    @Binding var sortOrderAscending: Bool
    @State var currentHeight: CGFloat = kMinHeight
    @State var lastDragPosition: DragGesture.Value?
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0.0) {
                HStack {
                    Spacer()
                    Group {
                        if currentHeight != Self.kMinHeight && currentHeight != Self.kMaxHeight  {
                            Capsule()
                                .frame(height: 5)
                        } else if currentHeight == Self.kMinHeight {
                            Image(systemName: "chevron.compact.up")
                                .resizable()
                                .renderingMode(.template)
                        } else {
                            Image(systemName: "chevron.compact.down")
                                .resizable()
                                .renderingMode(.template)
                        }
                    }
//                    .animation(.default, value: currentHeight == Self.kMinHeight || currentHeight == Self.kMaxHeight)
                    .frame(width: 50, height: 10, alignment: .center)
                    .foregroundColor(.secondary)
                    .padding(.all, 5.0)
                    Spacer()
                }
                if currentHeight != FilterView.kMinHeight {
                    Toggle("filter_toggle_title", isOn: $isFiltered.animation())
                        .padding([.top, .horizontal])
                    Toggle("sort_toggle_title", isOn: $isSorted.animation())
                        .padding([.top, .horizontal])
                    if isSorted {
                        HStack {
                            Text("sort_order_title")
                            Spacer()
                            Button {
                                withAnimation {
                                    sortOrderAscending.toggle()
                                }
                            } label: {
                                Image(systemName: "a.square")
                                    .resizable()
                                    .frame(width: 20.0, height: 20.0)
                                Image(systemName: "arrow.right")
                                    .rotationEffect(Angle.degrees(sortOrderAscending ? 0 : 180))
                                    .animation(.easeInOut, value: sortOrderAscending)
                                Image(systemName: "z.square")
                                    .resizable()
                                    .frame(width: 20.0, height: 20.0)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .frame(height: currentHeight)
        .background(.thinMaterial)
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
        FilterView(isFiltered: .constant(true), isSorted: .constant(false), sortOrderAscending: .constant(true))
    }
}
