//
//  ImageSubPageViewController.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 7/7/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase
// zoom image page 

class ImageSubPageViewController: UIViewController, UIScrollViewDelegate, UIWebViewDelegate {

    var binderKey: String?
    var pageKey: String? 
    var key: String?
    var privater: String?
    var bool: Bool?
    @IBOutlet weak var webView: UIWebView!
    var urlString: String? 
    let button = UIButton()
    @IBOutlet weak var zoomScroll: UIScrollView!
    @IBOutlet weak var imageViewLarge: UIImageView!
    var imageView = UIImageView()
    let loader = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let keyt = key {
            if let bindKey = binderKey {
                if let pageKer = pageKey {
                    let ref = Database.database().reference()
                    ref.child("Binders").child(bindKey).child("Page").child(pageKer).child("Posts").child(keyt).observeSingleEvent(of: .value, with: { (snapshot) in
                        if snapshot.exists() {
                            if let privr = self.privater {
                                self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.tapDelete)), animated: true)
                                print(privr)
                            }
                            print("goog")
                        } else {
                             let alert = UIAlertController(title: "Deleted", message: "This page was deleted", preferredStyle: .alert)
                            let action = UIAlertAction(title: "Okay", style: .cancel, handler: { (alert : UIAlertAction) -> Void in
                                 self.navigationController?.popViewController(animated: true)
                            })
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                        }
            })
        }
            }
        }
        loader.frame = CGRect(x: self.view.frame.width / 2.25, y: self.view.frame.height / 2, width: 30, height: 30)
        loader.color = UIColor.black
         imageViewLarge.isHidden = true
        if let image = image {
            imageViewLarge.image = image
            imageViewLarge.isHidden = false
           
        }
       webView.isHidden = true
       
     
        webView.frame = CGRect(x: 5, y: 70, width: self.view.frame.width - 10, height: self.view.frame.height - 130)
        if let urlString = urlString {
            zoomScroll.isHidden = true 
           // bool = true
            view.addSubview(loader)
            loader.startAnimating()
            let termsOfServiceUrl = URL(string: urlString)
            let termsOfServiceUrlRequest = URLRequest(url: termsOfServiceUrl!)
            webView.isHidden = false 
            webView.loadRequest(termsOfServiceUrlRequest)
        }
        self.zoomScroll.maximumZoomScale = 6.0
        self.zoomScroll.minimumZoomScale = 1.0
        
        if let privr = privater {
 
            print(privr)
        }
    
        self.navigationController?.navigationBar.tintColor = UIColor.white

        
        // Do any additional setup after loading the view.
    }
    var image: UIImage?
    
    
    
    @objc func tapDelete () {
        let alert = UIAlertController(title: "Delete Sub Page?", message: "Are you sure you want to delete this sub page?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Delete", style: .default, handler: { (alert : UIAlertAction) -> Void in
          
            if let binderK = self.binderKey {
                if let paheKey = self.pageKey {
                    if let keyPost = self.key {
                        let ref = Database.database().reference()
                        ref.child("Binders").child(binderK).child("Page").child(paheKey).child("Posts").child(keyPost).removeValue()
                    }
                }
            }
            self.navigationController?.popViewController(animated: true)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
   loader.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if (request.url?.absoluteString.contains("google.com"))! {
            return true
        }
        return false
    }
  
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageViewLarge
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
