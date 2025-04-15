//
//  GutenbergSearchView.swift
//  Kindle
//
//  Created by Freddy Morales on 07/04/25.
//

import SwiftUI
/*
struct GutenbergSearchView: View {
    @StateObject private var viewModel = GutenbergViewModel()
    @State private var selectedBookURL: String? = nil
    @State private var selectedBookTitle: String = ""

    var body: some View {
        if let url = selectedBookURL {
            ReaderView(bookURL: url, title: selectedBookTitle) {
                selectedBookURL = nil
                selectedBookTitle = ""
            }
        } else {
            VStack {
                TextField("Buscar libro", text: $viewModel.searchQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                List(viewModel.books) { book in
                    if let url = book.formats.first(where: { $0.key.contains("text/plain") })?.value {
                        Button {
                            selectedBookURL = url
                            selectedBookTitle = book.title
                        } label: {
                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(.headline)
                                Text(book.authors.first?.name ?? "Autor desconocido")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    GutenbergSearchView()
}*/
