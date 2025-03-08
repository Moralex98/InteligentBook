//
//  FloatingButtonTwoView.swift
//  Kindle
//
//  Created by Freddy Morales on 27/02/25.
//

import SwiftUI

struct FloatingButtonTwoView: View {
    @Binding var prompText: String
    var onSend: (String) -> Void // Agregamos un callback

    var body: some View {
        ZStack (alignment: .center) {
            HStack {
                HStack{
                    TextField("Pregunta algo", text: $prompText)
                        .padding(.leading)
                        .onSubmit {
                            sendMessage()
                        }
                }
                .padding(.trailing, 4)
                .frame(width: 700)
                .frame(height: 40)
                .overlay(
                    Capsule().stroke(.gray.opacity(0.2))
                )
                .background(Color.black.opacity(0.1))
                .cornerRadius(12)
                
                Button {
                    sendMessage()
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.cyan)
                            .frame(width: 50, height: 50)
                        Image(systemName: "paperplane.fill")
                            .foregroundStyle(.black)
                    }
                }
            }
        }
       // .ignoresSafeArea(.keyboard)
    }

    private func sendMessage() {
        if !prompText.isEmpty {
            onSend(prompText) // Envía el mensaje a HomeView
            prompText = "" // Limpia el campo
        }
    }
}

struct FloatingButtonTwoView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingButtonTwoView(prompText: .constant("Hola mundo"), onSend: { _ in })
    }
}
