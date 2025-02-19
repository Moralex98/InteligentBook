//
//  BookReaderView.swift
//  Kindle
//
//  Created by Freddy Morales on 12/02/25.
//

import SwiftUI
import WebKit

struct BookReaderView: UIViewRepresentable {
    let bookURL: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        if let url = URL(string: bookURL), !bookURL.isEmpty {
            print("✅ Cargando URL en WebView: \(bookURL)")  // ✅ Debugging
            webView.load(URLRequest(url: url))
        } else {
            print("❌ Error: URL no válida: \(bookURL)")
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

// Vista para cargar contenido HTML
struct BookWebView: View {
    let bookURL: String
    
    var body: some View {
        WebView(url: bookURL)
            .navigationTitle("Reading Book")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct WebView: UIViewRepresentable {
    let url: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let url = URL(string: url) {
            webView.load(URLRequest(url: url))
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
struct BookReaderScreen: View {
    let bookURL: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            // Botón para cerrar la ventana
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Close")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            // 📌 Debugging: Verificar la URL
            Text("📖 Preview Link: \(bookURL)")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding()

            if bookURL.isEmpty {
                Text("No preview available")
                    .foregroundColor(.red)
                    .font(.title)
                    .padding()
            } else {
                BookReaderView(bookURL: bookURL)
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationBarBackButtonHidden(true) // ✅ Oculta el botón Back
    }
}

struct BookReaderScreen_Previews: PreviewProvider {
    static var previews: some View {
        // Cambia la URL aquí a un enlace que sea PDF o HTML
        BookReaderScreen(bookURL: "https://www.gutenberg.org/files/1342/1342-h/1342-h.pdf")
    }
}
