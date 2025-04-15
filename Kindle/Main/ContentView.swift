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
                        .padding()
                        .background(Color.white)

                    HStack {
                        Spacer()
                        Button(usingGutenberg ? "Usar Google Books" : "Usar Gutenberg") {
                            usingGutenberg.toggle()
                        }
                        .padding(.horizontal)
                    }

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
                                            Button {
                                                selectedBookURL = url
                                                selectedBookTitle = book.title
                                                showReader = true
                                            } label: {
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(book.title).font(.headline)
                                                    Text(book.authors.first?.name ?? "Autor desconocido")
                                                        .font(.subheadline)
                                                        .foregroundColor(.gray)
                                                }
                                                .padding()
                                                .background(Color.white)
                                                .cornerRadius(10)
                                                .shadow(radius: 2)
                                                .padding(.horizontal)
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
                                                    } placeholder: {
                                                        ProgressView()
                                                    }
                                                }

                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(book.title).font(.headline)
                                                    Text(book.authors)
                                                        .font(.subheadline)
                                                        .foregroundColor(.gray)
                                                }
                                                Spacer()
                                            }
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .shadow(radius: 2)
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
                .background(Color(.systemGroupedBackground))
            }
        }
    }

    @ViewBuilder
    func showRectangles() -> some View {
        let previews: [(title: String, image: String, url: String)] = [
            ("National Geographic", "https://www.ngenespanol.com/wp-content/uploads/2023/11/national-geographic-logo.jpg", "https://www.ngenespanol.com"),
            ("Muy Interesante", "https://www.muyinteresante.es/assets/images/logo-mi.png", "https://www.muyinteresante.com/"),
            ("CogniFit", "https://static.cognifit.com/images/logos/cognifit_logo_header_es.png", "https://www.cognifit.com/es/juegos-mentales")
        ]

        ForEach(previews, id: \.title) { item in
            Button {
                selectedBookURL = item.url
                selectedBookTitle = item.title
                isGoogleReader = true
                showReader = true
            } label: {
                VStack {
                    AsyncImage(url: URL(string: item.image)) { image in
                        image.resizable()
                             .scaledToFill()
                             .frame(height: 180)
                             .clipped()
                             .cornerRadius(15)
                    } placeholder: {
                        ProgressView()
                            .frame(height: 180)
                    }

                    Text(item.title)
                        .font(.headline)
                        .padding(.top, 8)
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 4)
                .padding(.horizontal)
            }
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
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
