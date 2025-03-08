//
//  DetailView.swift
//  Kindle
//
//  Created by Freddy Morales on 27/02/25.
//
//
//  ContentView.swift
//  Kindle
//
//  Created by Freddy Morales on 12/02/25.
//

import SwiftUI
import MarkdownUI //for decoding content


struct ChatView: View {
    @Binding var isChatOpen: Bool
    @State private var prompText: String = ""
    @State private var isLoading: Bool = false
    @State private var extractedText: String = ""
    @State private var displayedText: String = ""
    @State private var typingIndex: Int = 0
    @State private var hasSentMessage: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        if !hasSentMessage {
                            Text("Welcome")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundStyle(
                                    LinearGradient(gradient: Gradient(colors: [Color.primaryColor1, Color.primaryColor2, Color.primaryColor3]), startPoint: .leading, endPoint: .trailing)
                                )
                                .frame(maxHeight: .infinity)
                                .padding()
                        }
                        
                        if !prompText.isEmpty {
                            Text(prompText)
                                .font(.headline)
                                .fontWeight(.regular)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 20)
                                .background(Color.cyan)
                                .clipShape(Capsule())
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        
                        if isLoading {
                            LoadingView()
                        } else {
                            Markdown(displayedText)
                                .markdownTextStyle(\.code) {
                                    FontFamilyVariant(.monospaced)
                                    FontSize(.em(1))
                                    ForegroundColor(.purple)
                                    BackgroundColor(.purple.opacity(0.25))
                                }
                                .font(.subheadline)
                                .foregroundStyle(.black)
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 140)
                
                HStack {
                    TextField("Pregunta algo", text: $prompText)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .textFieldStyle(PlainTextFieldStyle())
                        .onSubmit {
                            sendMessage()
                        }
                    
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
                .padding()
            }
            .ignoresSafeArea(.keyboard)
            .navigationTitle("Conect")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "person.wave.2.fill")
                        .foregroundStyle(.blue)
                        .font(.title)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "bubble.fill")
                        .foregroundStyle(.gray.opacity(0.5))
                        .font(.title)
                }
            }
        }
    }
    
    private func sendMessage() {
        if !prompText.isEmpty {
            hasSentMessage = true
            let userMessage = prompText
            prompText = "" // Borra el campo de texto
            isLoading = true
            
            AIService.fetchAIContent(prompt: userMessage) { result in
                DispatchQueue.main.async {
                    isLoading = false
                    switch result {
                    case .success(let responseText):
                        self.extractedText = responseText
                        typingAnimation()
                    case .failure(let error):
                        self.extractedText = "Error: \(error)"
                    }
                }
            }
        }
    }
    
    private func typingAnimation() {
        typingIndex = 0
        displayedText = ""
        
        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
            if typingIndex < extractedText.count {
                displayedText.append(extractedText[extractedText.index(extractedText.startIndex, offsetBy: typingIndex)])
                typingIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    @State static var isChatOpen = true

    static var previews: some View {
        ChatView(isChatOpen: $isChatOpen)
    }
}

struct LoadingView: View {
    var body: some View{
        VStack (spacing: 20) {
            HStack{
                Image("gemini")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 48, height: 48)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            VStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.cyan)
                    .frame(maxWidth: .infinity)
                    .frame(height: 8)
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.cyan)
                    .frame(width: 200, alignment: .trailing)
                    .frame(height: 8)
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.cyan)
                    .frame(width: 370)
                    .frame(height: 8)
            }
        }
    }
}
