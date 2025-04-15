//
//  GutenbergViewModel.swift
//  Kindle
//
//  Created by Freddy Morales on 07/04/25.
//

import Foundation

class GutenbergViewModel: ObservableObject {
    @Published var books: [GutenbergBook] = []
    @Published var searchQuery = "" {
        didSet {
            searchBooks()
        }
    }

    func searchBooks() {
        let trimmed = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            self.books = []
            return
        }

        guard let url = URL(string: "https://gutendex.com/books?search=\(trimmed)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(GutenberxResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.books = response.results
                    }
                } catch {
                    print("Error decoding: \(error)")
                }
            }
        }.resume()
    }
}

