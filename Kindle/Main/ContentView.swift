//
//  ContentView.swift
//  Kindle
//
//  Created by Freddy Morales on 12/02/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var booksViewModel = BookViewModel()
    @State private var showDownloadedBooks = false // Estado para mostrar libros descargados

    var body: some View {
        NavigationView {
            ZStack{
                VStack {
                    SearchBar(text: $booksViewModel.searchQuery)
                    
                    List(booksViewModel.books) { book in
                        NavigationLink(destination: BookDetailView(book: book)) {
                            HStack {
                                if let url = URL(string: book.imageURL) {
                                    AsyncImage(url: url) { image in
                                        image.resizable().scaledToFit().frame(width: 60, height: 90)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(book.title)
                                        .font(.headline)
                                    Text(book.authors)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Libros")
                .navigationBarItems(
                    trailing: Button(action: {
                        showDownloadedBooks.toggle()
                    }) {
                        Image(systemName: "book.fill")
                            .foregroundColor(.blue)
                    }
                )
               
            }
            ScrollView {
                Rectangle()
                    .frame(width: 700, height: 300)
                    .cornerRadius(15)
                    .foregroundStyle(Color.gray.opacity(0.15))
                
                Rectangle()
                    .frame(width: 700, height: 300)
                    .cornerRadius(15)
                    .foregroundStyle(Color.gray.opacity(0.15))
                
                Rectangle()
                    .frame(width: 700, height: 300)
                    .cornerRadius(15)
                    .foregroundStyle(Color.gray.opacity(0.15))
                
                Rectangle()
                    .frame(width: 700, height: 300)
                    .cornerRadius(15)
                    .foregroundStyle(Color.gray.opacity(0.15))
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
                .padding(7)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
        }
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
