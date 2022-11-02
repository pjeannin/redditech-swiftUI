//
//  WebView.swift
//  Redditech
//
//  Created by Pierre Jeannin on 13/10/2022.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    var url: URL?
    var urlToMatch: String
    @Binding var showWebView: Bool
    var onUrlCatched: (String) -> Void
    
    func makeUIView(context: Context) -> WKWebView {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let wKWebVieww = WKWebView(frame: .zero, configuration: config)
        wKWebVieww.navigationDelegate = context.coordinator
        return wKWebVieww
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let finalUrl: URL = url else {
            return
        }
        let request = URLRequest(url: finalUrl)
        webView.load(request)
    }
    
    func makeCoordinator() -> WebViewCoordinator {
            WebViewCoordinator(self)
    }

    
    class WebViewCoordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }

        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
            if let redirectedUrl: String = webView.url?.absoluteString {
                if redirectedUrl.contains("pierre.sfsu/loggedin?state=buy_AirPods&code=") {
                    parent.showWebView = false
                    parent.onUrlCatched(redirectedUrl)
                    decisionHandler(.cancel)
                    return
                }
            }
            decisionHandler(.allow)
        }
        
    }
}
