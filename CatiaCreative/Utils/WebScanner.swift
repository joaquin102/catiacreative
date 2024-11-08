//
//  WebScanner.swift
//  CatiaCreative
//
//  Created by Joaquin Pereira on 10/10/24.
//
import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {
    let url: URL
    
    class Coordinator: NSObject, WKScriptMessageHandler {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        // Handle when the webpage has loaded successfully
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("WebView finished loading.")
        }

        
        // This method handles messages from the JavaScript running in the WKWebView
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "sessionHandler", let sessionData = message.body as? [String: Any] {
                
                if let hash = sessionData["fullHash"] as? String {
                    Task {
                        await ServerApi.getSongId(hash: hash);
                    }
                    
                }
                
                print("Session data received: \(sessionData)")
                // You can handle the session data here (e.g., save it or pass it to other parts of your SwiftUI app)
            }
        }
    }
    
    // Create the WKWebView
    func makeUIView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "sessionHandler") // Connect JS message handler
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        let webView = WKWebView(frame: .zero, configuration: config)
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }
    
    // Required for UIViewRepresentable
    func updateUIView(_ webView: WKWebView, context: Context) {
        // Nothing to update here, we are only loading the URL once
    }
    
    // Create the coordinator that handles JavaScript messages
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
