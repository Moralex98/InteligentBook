import SwiftUI
import WebKit

struct MyWebView: View {
    let url: String
    let onBack: () -> Void

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    Button("← Volver") {
                        onBack()
                    }
                    .padding()
                    .foregroundColor(.blue)
                    
                    Spacer()
                }
                WebViewContainer(url: url)
                    .edgesIgnoringSafeArea(.all)
            }
            FloatingChatButton()
        }
    }
}

struct WebViewContainer: UIViewRepresentable {
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


struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        MyWebView(url: "https://www.gutenberg.org/files/1342/1342-h/1342-h.htm", onBack: {}
        )
    }
}
