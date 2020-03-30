//
//  TermsOfServiceViewController.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 9/16/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit

class TermsOfServiceViewController: UIViewController, UIWebViewDelegate {

    var bool: Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
       bool = true
       let termsOfServiceUrl = URL(string: "https://www.berlark.com/terms-of-service")
        let termsOfServiceUrlRequest = URLRequest(url: termsOfServiceUrl!)
    
        webView.loadRequest(termsOfServiceUrlRequest)
        
        webView.frame = CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 60)
        backButton.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
    }
    @IBOutlet weak var webView: UIWebView!

    @IBOutlet weak var backButton: UIButton!
   
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if bool == true {
     return true
        } else {
            return false 
        }
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        bool = false
    }
    
    
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
