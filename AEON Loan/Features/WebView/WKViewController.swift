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
    
    var path: String {
        return "https://aeon.com.kh/"
    }
    var endpoint: String {
        switch self {
        case .contactUs:
            return "contact-us/"
        case .location:
            return "branches/"
        case .promotion:
            return "promotions/"
        case .product:
            return "promotions"
        }
    }
    
    var url: URL {
        return URL(string: path + endpoint)!
    }
}
