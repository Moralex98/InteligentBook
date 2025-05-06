import SwiftUI
import WebKit

struct MyWebView: View {
    let url: String
    let onBack: () -> Void

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ZStack {
                    Image("madera")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 124)
                        .clipped()
                        .ignoresSafeArea(edges: .top)

                    HStack {
                        Button(action: {
                            onBack()
                        }) {
                            Text("← Volver")
                                .font(.title2) // tamaño más grande
                                .fontWeight(.semibold)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 20)
                                .background(Color.black.opacity(0.3))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }

                        Spacer()
                    }
                    .padding(.horizontal)
                }
                .frame(height: 80)
                .padding(.top, 20)

                WebViewContainer(url: url)
                    .edgesIgnoringSafeArea(.all)
            }

            FloatingChatButton()
        }
        .ignoresSafeArea(.keyboard)
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
        MyWebView(url: "https://www.gutenberg.org/files/1342/1342-h/1342-h.htm", onBack: {})
    }
}

