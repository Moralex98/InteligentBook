//
//  BookViewModel.swift
//  Kindle
//
//  Created by Freddy Morales on 12/02/25.
//
import SwiftUI
import Combine

import SwiftUI
import Combine

class BookViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var searchQuery = "" {
        didSet {
            fetchBooks()
        }
    }

    func fetchBooks() {
        guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(searchQuery)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let json = try JSONDecoder().decode(GoogleBooksResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.books = json.items.map { item in
                            Book(
                                id: item.id,
                                title: item.volumeInfo.title,
                                authors: item.volumeInfo.authors?.joined(separator: ", ") ?? "Unknown",
                                description: item.volumeInfo.description ?? "No description",
                                imageURL: item.volumeInfo.imageLinks?.thumbnail ?? "",
                                previewLink: item.volumeInfo.previewLink ?? ""
                            )
                        }
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
}

// Modelos para decodificar la API de Project Gutenberg
struct GutenbergResponse: Codable {
    let results: [GutenbergBook]
}

struct GutenbergBook: Codable {
    let id: Int
    let title: String
    let authors: [Author]
    let formats: [String: String] // Contiene los links de descarga
}

struct Author: Codable {
    let name: String
}

struct BookViewModel_Previews: PreviewProvider {
    static var previews: some View {
        ContentView() // ✅ Se previsualiza la vista que usa el ViewModel
    }
}

