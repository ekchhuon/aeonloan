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
        self.setup(title: request.title)
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
    
    //remove elements from webview
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        switch request {
        case .promotion:
            webView.remove(element: "header-title", by: .className)
            webView.remove(element: "vc_row", by: .className)
            webView.remove(element: "back-promotion", by: .className)
            webView.remove(element: "header", by: .elementID)
        case .contactUs, .aboutUs, .product:
            webView.remove(element: "header", by: .elementID)
        default: break
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

enum WKRequest {
    case contactUs
    case location
    case promotion
    case product(AeonProduct)
    case aboutUs
    var lang: String {
        return Preference.language == .en ? "" : "/kh"
    }
    
    var title: String {
        switch self {
        case .contactUs: return "Contact Us".localized
        case .location: return "Location".localized
        case .promotion: return "Promotion".localized
        case let .product(pro): return pro.title
        case .aboutUs: return "About Us".localized
        }
    }
    
    var path: String {
        return "https://aeon.com.kh"
    }
    var endpoint: String {
        switch self {
        case .aboutUs: return "/about-us"
        case .contactUs: return "/contact-us"
        case .location: return "/branches"
        case .promotion: return "/promotions"
        case let .product(pro): return "/product" + pro.endpoint
        }
    }
    var url: URL {
        return URL(string: path + lang + endpoint)!
    }
}

extension WKWebView {
    enum ScriptType {
        case elementID, className
    }
    func remove(element: String, by type: ScriptType) {
        var script = ""
        switch type {
        case .elementID:
            script = "var header = document.getElementById('\(element)'); header.parentElement.removeChild(header);"
        case .className:
            script = "var elements = document.getElementsByClassName('\(element)'); while(elements.length > 0){ elements[0].parentNode.removeChild(elements[0]);}"
        }
        
        self.evaluateJavaScript(script) { (result, error) in
            if error != nil {
                print(result)
            }
        }
    }
}


enum AeonProduct{
    case card, loan, installment, digital
    var title: String {
        switch self {
        case .card: return "AEON Cards".localized
        case .loan: return "Loans".localized
        case .installment: return "Installments".localized
        case .digital: return "Digital Products".localized
        }
    }
    
    var endpoint: String {
        switch self {
        case .card: return "/aeon-cards"
        case .loan: return "/loans"
        case .installment: return "/installments"
        case .digital: return "/digital-products"
        }
    }
}
