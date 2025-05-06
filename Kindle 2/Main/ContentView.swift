//
//  ContentView.swift
//  Kindle
//
//  Created by Freddy Morales on 12/02/25.
//


import SwiftUI

struct ContentView: View {
    @ObservedObject var booksViewModel = BookViewModel()
    @StateObject private var gutenbergVM = GutenbergViewModel()

    @State private var usingGutenberg = false
    @State private var showReader = false
    @State private var selectedBookURL = ""
    @State private var selectedBookTitle = ""
    @State private var isGoogleReader = false

    var body: some View {
        ZStack {
            Color(.systemGray6) // fondo más cálido y menos blanco
                  .ignoresSafeArea()

              Rectangle()
                  .fill(.thinMaterial)
                  .ignoresSafeArea()

            if showReader {
                if isGoogleReader {
                    MyWebView(url: selectedBookURL) {
                        showReader = false
                        isGoogleReader = false
                    }
                } else {
                    ReaderView(
                        bookURL: selectedBookURL,
                        title: selectedBookTitle,
                        onBack: {
                            showReader = false
                        }
                    )
                }
            } else {
                VStack(spacing: 0) {
                    SearchBar(text: usingGutenberg ? $gutenbergVM.searchQuery : $booksViewModel.searchQuery)
                        .padding(.top, 30)

                    HStack {
                        Spacer()
                        Button(action: {
                            usingGutenberg.toggle()
                        }) {
                            Text(usingGutenberg ? "Usar Google Books" : "Usar Gutenberg")
                                .fontWeight(.semibold)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 20)
                                .background(Color.orange.opacity(0.2))
                                .foregroundColor(.brown)
                                .cornerRadius(12)
                        }
                        .padding(.top, 13) // separación respecto al buscador
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 14) // separación respecto a las cards



                    ScrollView {
                        VStack(spacing: 20) {
                            if usingGutenberg {
                                if gutenbergVM.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    showRectangles()
                                } else if gutenbergVM.books.isEmpty {
                                    Text("No se encontraron libros.")
                                        .foregroundColor(.gray)
                                        .padding()
                                } else {
                                    ForEach(gutenbergVM.books) { book in
                                        if let url = book.formats.first(where: { $0.key.contains("text/plain") })?.value {
                                            BookCard(title: book.title, author: book.authors.first?.name ?? "Autor desconocido") {
                                                selectedBookURL = url
                                                selectedBookTitle = book.title
                                                showReader = true
                                            }
                                        }
                                    }
                                }
                            } else {
                                if booksViewModel.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    showRectangles()
                                } else if booksViewModel.books.isEmpty {
                                    Text("No se encontraron libros.")
                                        .foregroundColor(.gray)
                                        .padding()
                                } else {
                                    ForEach(booksViewModel.books) { book in
                                        Button {
                                            selectedBookURL = book.previewLink.trimmingCharacters(in: .whitespacesAndNewlines)
                                            selectedBookTitle = book.title
                                            isGoogleReader = true
                                            showReader = true
                                        } label: {
                                            HStack(alignment: .top) {
                                                if let url = URL(string: book.imageURL) {
                                                    AsyncImage(url: url) { image in
                                                        image.resizable()
                                                            .scaledToFit()
                                                            .frame(width: 60, height: 90)
                                                            .cornerRadius(8)
                                                    } placeholder: {
                                                        ProgressView()
                                                            .frame(width: 60, height: 90)
                                                    }
                                                }

                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(book.title)
                                                        .font(.headline)
                                                    Text(book.authors)
                                                        .font(.subheadline)
                                                        .foregroundColor(.gray)
                                                }
                                                Spacer()
                                            }
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(15)
                                            .shadow(color: .gray.opacity(0.2), radius: 5)
                                            .padding(.horizontal)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 20)
                    }
                    .scrollIndicators(.hidden)
                }
            }
        }
    }

   
    
    @ViewBuilder
    func showRectangles() -> some View {
        let previews: [(title: String, image: String, url: String, background: Color)] = [
            (
                "National Geographic",
                "https://www.ngenespanol.com/wp-content/uploads/2023/11/national-geographic-logo.jpg",
                "https://www.ngenespanol.com",
                Color(red: 245/255, green: 236/255, blue: 210/255)
            ),
            (
                "Muy Interesante",
                "https://www.muyinteresante.es/assets/images/logo-mi.png",
                "https://www.muyinteresante.com/",
                Color(red: 180/255, green: 200/255, blue: 170/255)
            ),
            (
                "CogniFit",
                "https://static.cognifit.com/images/logos/cognifit_logo_header_es.png",
                "https://www.cognifit.com/es/juegos-mentales",
                Color(red: 255/255, green: 200/255, blue: 160/255)
            )
        ]

        ForEach(previews, id: \.title) { item in
            Button {
                selectedBookURL = item.url
                selectedBookTitle = item.title
                isGoogleReader = true
                showReader = true
            } label: {
                VStack(spacing: 14) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .tint(.gray)
                        .frame(height: 220)

                    Text(item.title)
                        .font(.system(size: 20, weight: .semibold, design: .serif))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity, minHeight: 180)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(item.background)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.black.opacity(0.08), lineWidth: 1)
                        )
                )
                .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 4)
                .scaleEffect(1.0)
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: UUID())
                .padding(.horizontal, 20)
            }
        }
    }


}



// Card reutilizable para libros de Gutenberg
struct BookCard: View {
    let title: String
    let author: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title).font(.headline)
                Text(author).font(.subheadline).foregroundColor(.gray)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(15)
            .shadow(color: .gray.opacity(0.2), radius: 5)
            .padding(.horizontal)
        }
    }
}





struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Buscar libros", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
        .padding(.horizontal)
        .frame(height: 50)
        .frame(maxWidth: 750) // <- Ajuste clave
        .background(Color.white)
        .cornerRadius(40)
        .shadow(radius: 5)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
