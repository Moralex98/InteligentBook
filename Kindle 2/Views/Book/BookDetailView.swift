//
//  BookDetailView.swift
//  Kindle
//
//  Created by Freddy Morales on 12/02/25.
//
//
//  BookDetailView.swift
//  Kindle
//
//  Created by Freddy Morales on 12/02/25.
//

import SwiftUI

struct BookDetailView: View {
    let book: Book
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let url = URL(string: book.imageURL), !book.imageURL.isEmpty {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFit().frame(height: 200)
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                Text(book.title)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                
                Text("By \(book.authors)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(book.description)
                    .font(.body)
                    .padding()
                
                // 📌 Botón para leer el libro en el navegador
                let trimmedPreviewLink = book.previewLink.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmedPreviewLink.isEmpty, let bookURL = URL(string: trimmedPreviewLink) {
                    NavigationLink(destination: BookReaderScreen(bookURL: trimmedPreviewLink)) {
                        Text("Read Book")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                } else {
                    Text("No preview available")
                        .foregroundColor(.red)
                }
            }
            .padding()
            
        }
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(book: Book(
            id: "1",
            title: "Sample Book",
            authors: "John Doe",
            description: "This is a sample book description.",
            imageURL: "https://via.placeholder.com/150",
            previewLink: "https://www.example.com"
        ))
    }
}

