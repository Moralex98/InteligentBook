//
//  DetailView.swift
//  Kindle
//
//  Created by Freddy Morales on 27/02/25.
//

import SwiftUI
import MarkdownUI //for decode the content with symbol to readable text

struct DetailView: View {
    // state and param from home view
    var text: String
    @State private var prompText: String = ""
    
    init(text: String) {
        self.text = text
        _prompText = State(initialValue: text)
    }
    //bback buttton trigger
    @Environment(\.dismiss) var dismiss
    
    //loading
    @State private var isLoading: Bool = false
    // animation and text
    @State private var extractedText: String = ""
    @State private var displayedText: String = ""
    @State private var typingIndex: Int = 0
    
    var body: some View {
        NavigationStack {
            ZStack (alignment: .bottom) {
                //Scrollable content
                ScrollView (showsIndicators: false) {
                    VStack(spacing: 14) {
                        // text prompt badge
                        Text(prompText)
                            .font(.headline)
                            .fontWeight(.regular)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 20)
                            .background(Color.cyan)
                            .clipShape(Capsule())
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        
                        // loading view
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
                    //content response from api seervice using gemini
                }
                .padding(.top)
                .padding(.horizontal)
                .padding(.bottom, 140)
                // floating button
                FloatingButtonTwoView(prompText: $prompText)
            }
            //tittle
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                //leading
                ToolbarItem(placement: .principal) {
                    Text(prompText)
                        .font(.headline)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    }label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.black)
                    }
                }
                //trailing
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    }label: {
                        ZStack {
                            Circle()
                                .fill(.blue)
                                .frame(width: 34, height: 34)
                            Text("A")
                                .font(.title3)
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
        }
        .onAppear {
            fetchAIContent(with: prompText)
        }
    }
       
    
    // func to get from api service
    func fetchAIContent(with prompt: String){
        isLoading = true
        AIService.fetchAIContent(prompt: prompt) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let text):
                    self.extractedText = text
                    typingAnimation()
                    //
                case .failure(let error):
                    self.extractedText = "Error: \(error)"
                }
            }
        }
    }
    // func for animation typing smooth
    func typingAnimation(){
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

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(text: "HELLO")
    }
}

struct LoadingView: View {
    var body: some View{
        VStack (spacing: 20) {
            Image("gemini")
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 48)
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.cyan)
                    .frame(maxWidth: .infinity)
                    .frame(height: 10)
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.cyan)
                    .frame(width: 500)
                    .frame(height: 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
        }
    }
}
