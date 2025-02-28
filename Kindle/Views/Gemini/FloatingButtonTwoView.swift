//
//  FloatingButtonTwoView.swift
//  Kindle
//
//  Created by Freddy Morales on 27/02/25.
//

import SwiftUI

struct FloatingButtonTwoView:View {
    @Binding var prompText: String
    var body: some View {
        HStack {
            // textfield
            HStack {
                TextField("Pregunta algo", text: $prompText)
                    .padding(.leading)
                //icons
                HStack (spacing: 24) {
                    Button {
                        
                    } label: {
                        Image(systemName: "mic")
                    }
                    Button {
                        
                    } label: {
                        Image(systemName: "camera")
                    }
                }
                .foregroundStyle(.black)
                .frame(width: 110, height: 48)
                .background(Color.cyan)
                .clipShape(Capsule())
            }
            .padding(.trailing, 4)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .overlay(
                Capsule().stroke(.gray.opacity(0.2))
            )
            //icon voice
            Button {
                
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.cyan)
                        .frame(width: 50, height: 50)
                    Image(systemName: "waveform")
                        .foregroundStyle(.black)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 90)
        .background(Color.white)
        .shadow(color: .gray.opacity(0.15), radius: 10)
    }
}

struct FloatingButtonTwoView_Previews: PreviewProvider{
    static var previews: some View {
        FloatingButtonTwoView(prompText: .constant("Hola mundo"))
    }
}
