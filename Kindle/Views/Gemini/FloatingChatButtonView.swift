//
//  FloatingChatButtonView.swift
//  Kindle
//
//  Created by Freddy Morales on 01/03/25.
//
import SwiftUI

struct FloatingChatButton: View {
    @State private var isChatOpen = false
    @State private var position: CGPoint = .zero
    @GestureState private var dragOffset: CGSize = .zero

    let tabWidth: CGFloat = 30
    let tabHeight: CGFloat = 80

    var body: some View {
        GeometryReader { geo in
            ZStack {
                if isChatOpen {
                    let adjustedX = position.x < geo.size.width / 2 ? 300 : geo.size.width - 300
                    let halfHeight: CGFloat = 300 // altura del chat / 2
                    let minY = halfHeight + 20
                    let maxY = geo.size.height - halfHeight - 20
                    let adjustedY = min(max(position.y, minY), maxY)

                    ChatView(isChatOpen: $isChatOpen)
                        .frame(width: 500, height: 600)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 10)
                        .position(x: adjustedX, y: adjustedY)
                        .animation(.easeOut, value: position)
                }

                // La pestañita flotante
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue.opacity(0.85))
                    .frame(width: tabWidth, height: tabHeight)
                    .overlay(
                        Image(systemName: "chevron.left")
                            .rotationEffect(.degrees(position.x < geo.size.width / 2 ? 0 : 180))
                            .foregroundColor(.white)
                    )
                    .position(x: position.x + dragOffset.width, y: position.y + dragOffset.height)
                    .gesture(
                        DragGesture()
                            .updating($dragOffset) { value, state, _ in
                                state = value.translation
                            }
                            .onEnded { value in
                                let finalX = position.x + value.translation.width
                                let finalY = position.y + value.translation.height

                                let snappedX: CGFloat = finalX > geo.size.width / 2
                                    ? geo.size.width - tabWidth / 2
                                    : tabWidth / 2

                                let clampedY = min(max(finalY, 100), geo.size.height - 100)

                                withAnimation(.easeOut) {
                                    position = CGPoint(x: snappedX, y: clampedY)
                                }
                            }
                    )
                    .onTapGesture {
                        withAnimation {
                            isChatOpen.toggle()
                        }
                    }
                    .onAppear {
                        // 👉 Posición inicial: lado derecho, 40% de la altura
                        let initialY = geo.size.height * 0.9
                        let initialX = geo.size.width - tabWidth / 2
                        position = CGPoint(x: initialX, y: initialY)
                    }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}


struct FloatingChatButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingChatButton()
    }
}

