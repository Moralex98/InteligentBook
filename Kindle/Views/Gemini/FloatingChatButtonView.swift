//
//  FloatingChatButtonView.swift
//  Kindle
//
//  Created by Freddy Morales on 01/03/25.
//
import SwiftUI

struct FloatingChatButton: View {
    @State private var isChatOpen = false
    
    var body: some View {
        ZStack () {
            // Muestra el ChatView cuando isChatOpen es true
            if isChatOpen {
                ChatView(isChatOpen: $isChatOpen)
                    .frame(width: 500, height: 600)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 10)
                    .offset(x: 70, y: 240)
            }
            // Botón flotante para abrir/cerrar el chat
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        isChatOpen.toggle()
                    }) {
                        Image(systemName: "message.fill")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding()
                }
            }
            .ignoresSafeArea(.keyboard)
        }
        //.ignoresSafeArea(.keyboard)
    }
}

struct FloatingChatButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingChatButton()
    }
}

