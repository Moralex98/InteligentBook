//
//  ReaderView.swift
//  Kindle
//
//  Created by Freddy Morales on 07/04/25.
//

import SwiftUI

struct ReaderView: View {
    let bookURL: String
    let title: String
    let onBack: () -> Void

    @State private var fullText: String = ""
    @State private var pages: [String] = []
    @State private var currentPage = 0
    @State private var searchQuery = ""
    @State private var isTranslating = false

    let pageLength = 1000

    var body: some View {
        VStack(spacing: 0) {
            // 🔸 Parte superior con fondo madera
            VStack(spacing: 12) {
                // Botón volver
                HStack {
                    Button(action: onBack) {
                        Label {
                            Text("Volver")
                                .foregroundColor(.white)
                        } icon: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                        }
                        .font(.body)
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }
                    .padding()
                    Spacer()
                }
                .padding(.top, 13) // ⬅️ AQUÍ le agregamos separación hacia abajo


                // Buscador
                HStack {
                    TextField("Buscar palabra", text: $searchQuery, onCommit: searchWord)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button("Buscar", action: searchWord)
                        .foregroundColor(.gray)
                        .padding(.trailing)
                }

                Button(action: translateCurrentPage) {
                    HStack(spacing: 10) { // Espaciado entre el spinner y el texto
                        Text("Traducir página")
                            .fontWeight(.semibold)

                        if isTranslating {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(1.2) // agranda el spinner
                        }
                    }
                    .frame(height: 40)
                    .padding(.horizontal, 20)
                    .background(Color.white.opacity(0.1))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(isTranslating)
                .animation(.easeInOut, value: isTranslating)

            }
            .background(
                Image("madera")
                    .resizable()
                    .scaledToFill()
            )

            // 🔸 Parte de lectura con fondo blanco
            VStack(spacing: 0) {
                ScrollView {
                    Text(pages.isEmpty ? "Cargando..." : pages[currentPage])
                        .padding()
                        .foregroundColor(.black) // texto gutenberg
                }

                Divider()

                HStack {
                    Button("⟨") { if currentPage > 0 { currentPage -= 1 } }
                    Spacer()
                    Text("Página \(currentPage + 1)/\(pages.count)")
                    Spacer()
                    Button("⟩") { if currentPage < pages.count - 1 { currentPage += 1 } }
                   
                }
                .padding()
//Image("madera")
                .background(.ultraThinMaterial)
                .foregroundColor(.primary)
           
            }
         
            .background(Color.white)
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 20) // ⬅️ Agrega espacio visual seguro abajo
            }
        }
        .ignoresSafeArea(.keyboard) // opcional: evita que el teclado empuje la vista
        .onAppear(perform: loadBook)
    }


    func loadBook() {
        guard let url = URL(string: bookURL) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, var text = String(data: data, encoding: .utf8) {
                if let startRange = text.range(of: "*** START OF THE PROJECT GUTENBERG EBOOK") {
                    text = String(text[startRange.upperBound...])
                }

                DispatchQueue.main.async {
                    self.fullText = text
                    self.pages = paginate(text: text)
                }
            }
        }.resume()
    }

    func paginate(text: String) -> [String] {
        var result: [String] = []
        var index = text.startIndex

        while index < text.endIndex {
            let end = text.index(index, offsetBy: pageLength, limitedBy: text.endIndex) ?? text.endIndex
            result.append(String(text[index..<end]))
            index = end
        }

        return result
    }

    func searchWord() {
        let lowerText = fullText.lowercased()
        let query = searchQuery.lowercased()

        if let range = lowerText.range(of: query) {
            let offset = lowerText.distance(from: lowerText.startIndex, to: range.lowerBound)
            currentPage = offset / pageLength
        }
    }

    func translateCurrentPage() {
        guard !pages.isEmpty else { return }

        let textToTranslate = pages[currentPage]
        guard let url = URL(string: "https://libretranslate.de/translate") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "q": textToTranslate,
            "source": "en",
            "target": "es",
            "format": "text"
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        isTranslating = true

        URLSession.shared.dataTask(with: request) { data, _, _ in
            DispatchQueue.main.async {
                self.isTranslating = false
            }

            guard let data = data else { return }

            if let result = try? JSONDecoder().decode(TranslateResponse.self, from: data) {
                DispatchQueue.main.async {
                    pages[currentPage] = result.translatedText
                }
            }
        }.resume()
    }
}

struct TranslateResponse: Codable {
    let translatedText: String
}

#Preview {
    ReaderView(
        bookURL: "https://www.gutenberg.org/files/1342/1342-0.txt",
        title: "Orgullo y prejuicio",
        onBack: {}
    )
}
