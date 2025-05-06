//
//  FloatingButtonTwoView.swift
//  Kindle
//
//  Created by Freddy Morales on 27/02/25.
//

import SwiftUI

struct FloatingButtonTwoView: View {
    @Binding var prompText: String
    var onSend: (String) -> Void

    var body: some View {
        HStack(spacing: 8) {
            TextField("Pregunta algo", text: $prompText)
                .padding(12)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(12)
                .onSubmit {
                    sendMessage()
                }

            Button(action: sendMessage) {
                ZStack {
                    Circle()
                        .fill(Color.cyan)
                        .frame(width: 44, height: 44)
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.black)
                }
            }
        }
        .padding(.horizontal)
    }

    private func sendMessage() {
        guard !prompText.isEmpty else { return }
        onSend(prompText)
        prompText = ""
    }
}

struct FloatingButtonTwoView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingButtonTwoView(prompText: .constant("Hola mundo"), onSend: { _ in })
            .ignoresSafeArea(.keyboard) // agregado aquí para vista previa
    }
}
