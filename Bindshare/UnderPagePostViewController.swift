//
//  UnderPagePostViewController.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 7/6/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

//posting image to a page

class UnderPagePostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UIWebViewDelegate {

    var urlString: String?
    var lael = UILabel()
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var imageViewShow: UIImageView!
    @IBOutlet weak var addImagelLabel: UILabel!
    @IBOutlet weak var addSubPage: UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var viewImage: UIView!

    @IBOutlet weak var decriptionLabel: UILabel!
    let activityIdncc = UIActivityIndicatorView()
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
   
    var currentUsernm: String?
    var binderkey: String?
    var key: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // binder key
        if let fbfb = binderkey {
            print("Binder key: \(fbfb)")
        }
     
    
        webView.isHidden = true
        cancelButton.frame = CGRect(x: 10, y: 10, width: 45, height: 45)
        addSubPage.frame = CGRect(x: self.view.frame.width / 2.7, y: 15, width: 120, height: 30)
        decriptionLabel.frame = CGRect(x: 15, y: 50, width: 80, height: 20)
        textViewDest.frame = CGRect(x: 15, y: 72, width: self.view.frame.width - 30, height: 105)
        addImagelLabel.frame = CGRect(x: 15, y: 182, width: 180, height: 25)
        imageViewShow.frame = CGRect(x: 20, y: 212, width: self.view.frame.width - 40, height: self.view.frame.height - 297)
        viewImage.frame = CGRect(x: 15, y: 207, width: self.view.frame.width - 30, height: self.view.frame.height - 287)
        buttonTakePhoto.frame = imageViewShow.frame
        postButton.frame = CGRect(x: 15, y: self.view.frame.height - 65, width: self.view.frame.width - 30, height: 55)
        webView.frame = imageViewShow.frame
     
        
        
        
        lael.text = "Posting Image"
        lael.textColor = .black
        lael.frame = CGRect(x: self.view.frame.width / 3, y:200, width: 150, height: 30)
        
        // page key
        if let kevv = key {
            print("Page key: \(kevv)")
        }
        self.navigationController?.navigationBar.tintColor = UIColor.white

        // actvity indc for when posting image
      activityIdncc.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        activityIdncc.color = .black
        activityIdncc.addSubview(lael)
        postButton.layer.cornerRadius = 24
        activityIdncc.backgroundColor = UIColor(white: 1, alpha: 0.8)
        postButton.clipsToBounds = true
        
    }
   
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }

        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        return numberOfChars < 200
    }
    

    @IBAction func actionPhoto(_ sender: Any) {
        
        
         let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let pageAlert = UIAlertController(title: "Add Image", message: "Chose a way to add an image or add a link", preferredStyle: UIAlertControllerStyle.actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { (action : UIAlertAction!) -> Void in
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(imagePicker, animated: true, completion: nil)

        })
        let library = UIAlertAction(title: "Library", style: .default, handler: { (action : UIAlertAction!) -> Void in
           
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)

        })
        let addLink = UIAlertAction(title: "Add link", style: .default, handler: { (action : UIAlertAction!) -> Void in
            let alert2 = UIAlertController(title: "Add a link", message: "Tap text box to paste a link. To add a google doc, got to the doc and click share -> copy to clipboard and paste that link in the text box. Remember to share the google doc with the emails of users in this binder, or publish the doc to the web", preferredStyle: .alert)
            alert2.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Paste or enter a link"
                textField.keyboardType = .asciiCapable
            }
            let post = UIAlertAction(title: "Add link", style: .default, handler: { (action : UIAlertAction) -> Void in
                if let text = alert2.textFields?[0].text {
                    if text != "", text.characters.count > 10 {
                        if text.contains(".") {
                            if text.contains(" ") {
                                
                            } else {
                                if text.contains("https://")  {
                                    if text.contains("docs.google.com")  {
                                self.urlString = text
                                self.imageViewShow.image = nil
                                let enterUrl = URL(string: "\(text)")
                                let enteredUrlRequest = URLRequest(url: enterUrl!)
                                
                                self.webView.loadRequest(enteredUrlRequest)
                             
                        
                                self.webView.isHidden = false
                                    }
                                    else {
                                        let alerto = UIAlertController(title: "Google docs only", message: "In order to avoid pop ups, google docs are only allowed", preferredStyle: .alert)
                                        let cencel = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                                        alerto.addAction(cencel)
                                        self.present(alerto, animated: true, completion: nil)
                                    }
                                    
                                } else {
                                    let alerto = UIAlertController(title: "Https missing", message: "Only secure links are allowed, meaning it must start with https://", preferredStyle: .alert)
                                    let cencel = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                                    alerto.addAction(cencel)
                                    self.present(alerto, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }
                
            })
            alert2.addAction(post)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert2.addAction(cancel)
            self.present(alert2, animated: true, completion: nil)
        })
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        pageAlert.addAction(camera)
        pageAlert.addAction(library)
        pageAlert.addAction(addLink)
        pageAlert.addAction(cancel)
        
        self.present(pageAlert, animated: true, completion: nil)
       
    }
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if (request.url?.absoluteString.contains("google.com"))! {
            return true
        }
        return false
    }
    
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageViewShow.image = selectedImage
        buttonTakePhoto.titleLabel?.text? = ""
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var buttonTakePhoto: UIButton!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    @IBOutlet weak var textViewDest: UITextView!
    
    @IBAction func postAction(_ sender: Any) {
        let imageImage = imageViewShow.image
        if let imager = imageImage {
        
            let storage = Storage.storage().reference(forURL: "gs://bindshare-a7805.appspot.com")
            let uid = Auth.auth().currentUser!.uid
            let ref = Database.database().reference()
            if textViewDest.text == "" {
                textViewDest.text = " "
            }
            
        if textViewDest.text != "" {
        if let bindkey = binderkey {
            if let kev = key {
                print("there is a key, both binder and page")
                if let curnetUn = currentUsernm {
                    view.addSubview(activityIdncc)
                    activityIdncc.startAnimating()
        let key = ref.child("Binders").child(bindkey).child("Page").child(kev).child("Posts").childByAutoId().key
        let imageRef = storage.child("SubPagePosts").child(uid).child("\(key).jpg)")
        let data = UIImageJPEGRepresentation(imager, 0.6)
        let descriptionn = textViewDest.text
          
        let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
            if error != nil {
                let alerto = UIAlertController(title: "Error", message: "Sorry, there was an error, either there is a connection issue or other error, we are working to fix it", preferredStyle: .alert)
                let cencel = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                alerto.addAction(cencel)
                
                print(error?.localizedDescription as Any)
                self.activityIdncc.stopAnimating()
                self.present(alerto, animated: true, completion: nil)
                return
            }
            else {
                imageRef.downloadURL(completion: { (url, error) in
                    
                    let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                    
                    if let url = url {
                        let feed = ["userID": uid,
                                    "url": url.absoluteString,
                                    "creatorName" : Auth.auth().currentUser!.displayName!,
                                    "key": key,
                                    "timeStamp" : timeStamp, "creatorUsername" : curnetUn,
                                    "description" : descriptionn!] as [String : Any]
                        
                       
                        
                        let postFeed = ["\(key)" : feed]
                        ref.child("Binders").child(bindkey).child("Page").child(kev).child("Posts").updateChildValues(postFeed)
                        
                        self.activityIdncc.stopAnimating()
                                           }
                    self.dismiss(animated: true, completion: nil)
                })
                
            }
                    }
        uploadTask.resume()
        }
        }
        }
        }
        
    }
        if let urlWebsite = urlString {
            let ref = Database.database().reference()
            if textViewDest.text == "" {
                textViewDest.text = " "
            }
            
            if textViewDest.text != "" {
                if let uid = Auth.auth().currentUser?.uid {
                if let bindkey = binderkey {
                    if let kev = key {
                        print("there is a key, both binder and page")
                        if let curnetUn = currentUsernm {
                            view.addSubview(activityIdncc)
                            activityIdncc.startAnimating()
                            let key = ref.child("Binders").child(bindkey).child("Page").child(kev).child("Posts").childByAutoId().key
                              let descriptionn = textViewDest.text
                               let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                            
                            let feed = ["userID": uid,
                                        "urlWebsite": urlWebsite,
                                        "creatorName" : Auth.auth().currentUser!.displayName!,
                                        "key": key,
                                        "timeStamp" : timeStamp, "creatorUsername" : curnetUn,
                                        "description" : descriptionn!] as [String : Any]
                            
                            
                            
                            let postFeed = ["\(key)" : feed]
                            ref.child("Binders").child(bindkey).child("Page").child(kev).child("Posts").updateChildValues(postFeed)
                            
                            self.activityIdncc.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                            
                        }
                    }
                }
            }
            }
            
            
            
        }
    }
   
    
   
}
