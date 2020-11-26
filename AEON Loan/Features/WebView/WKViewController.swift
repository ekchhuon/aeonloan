//
//  ContactUsViewController.swift
//  AEON Loan
//
//  Created by aeon on 11/19/20.
//

import UIKit
import WebKit

extension WKViewController {
    static func instantiate(request: WKRequest) -> WKViewController {
        let controller = WKViewController()
        controller.request = request
        return controller
    }
}

class WKViewController: BaseViewController, WKUIDelegate, WKNavigationDelegate {
    var webView: WKWebView!
    var request: WKRequest!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup(title: request.rawValue)
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(back(sender:)))
        self.navigationItem.leftBarButtonItem = backButton
        webView.navigationDelegate = self
        let request = URLRequest(url: self.request.url)
        webView.load(request)
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        view = webView
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        var script = ""
        let headerElementID = "header"
        let headerClassName = "header-title"//"vc_row"
        
        let classNames = ["header-title", "vc_row", "back-promotion"]
        
        let element1 = "var header = document.getElementById('\(headerElementID)'); header.parentElement.removeChild(header);"
        
        var element2 = ""

        for (_,item) in classNames.enumerated() {
            let element = "var elements = document.getElementsByClassName('\(item)'); while(elements.length > 0){ elements[0].parentNode.removeChild(elements[0]);}"
            element2 += element
        }
        
        if request == .promotion || request == .location {
            script = element1 + element2 //+ element3
        } else {
            script = element1
        }
        
        webView.evaluateJavaScript(script) { (result, error) in
            if error != nil {
                print(result)
            }
        }
    }
    
    @objc
    func back(sender: UIBarButtonItem) {
        if(webView.canGoBack) {
            webView.goBack()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

enum WKRequest: String{
    case contactUs = "Contact Us"
    case location = "Location"
    case promotion = "Promotion"
    case product = "Products"
    case aboutUs = "About Us"
    var lang: String {
        return Preference.language == .en ? "" : "/kh"
    }
    var path: String {
        return "https://aeon.com.kh"
    }
    var endpoint: String {
        switch self {
        case .aboutUs:
            return "/about-us"
        case .contactUs:
            return "/contact-us"
        case .location:
            return "/branches"
        case .promotion:
            return "/promotions"
        case .product:
            return "/promotions"
        }
    }
    var url: URL {
        return URL(string: path + lang + endpoint)!
    }
}
