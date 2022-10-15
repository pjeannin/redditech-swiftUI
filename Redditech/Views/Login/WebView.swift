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
        
    
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            if let urlStr: String = webView.url?.absoluteString {
                print("--------The current URL is \(urlStr)--------")
                print("I am herererererere")
                if urlStr.contains("pierre.sfsu/loggedin?state=buy_AirPods&code=") {
                    print("I entered hererererere")
                    parent.showWebView = false
                }
            }
        }

        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
            if let redirectedUrl: String = webView.url?.absoluteString {
                print("--------The current URL in the navigation function is \(redirectedUrl)--------")
                if redirectedUrl.contains("pierre.sfsu/loggedin?state=buy_AirPods&code=") {
                    print("I entered hererererere")
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
