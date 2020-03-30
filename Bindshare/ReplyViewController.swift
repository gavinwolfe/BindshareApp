//
//  ReplyViewController.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 7/17/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase
import OneSignal

class ReplyViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidAppear(_ animated: Bool) {
        if imageViewReply.isHidden == true {
              textViewMainMessage.becomeFirstResponder()
        }
    }
    let lael = UILabel()
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var imageViewReply: UIImageView!
    @IBOutlet weak var textViewMainMessage: UITextView!
    @IBOutlet weak var segmentMessage: UISegmentedControl!
    @IBOutlet weak var enterMessageLbl: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var enlabel: UILabel!
    
    let activIndc = UIActivityIndicatorView()
    var string: String?
    var creatorId: String?
    var theirKey: String?
    var myUsername: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        let ref = Database.database().reference()
        if let uder = creatorId {
           ref.child("users").child(uder).child("userKey").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                self.theirKey = snapshot.value as? String
            }
           })
        }
        checkIfImBlocked()
        if let creatorIdent = creatorId {
            print(creatorIdent)
        }
        pullname()
        if let string = string {
            nameLabel.text = string
        }
        lael.text = "Sending Image"
        lael.textColor = .black
        lael.frame = CGRect(x: self.view.frame.width / 3, y: 200, width: 150, height: 30)
        activIndc.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        activIndc.color = .black
        activIndc.addSubview(lael)
        activIndc.backgroundColor = UIColor(white: 1, alpha: 0.8)
        
        
        downButton.frame = CGRect(x: 10, y: 10, width: 45, height: 45)
        replyLabel.frame = CGRect(x: self.view.frame.width / 3, y: 15, width: 120, height: 30)
        nameLabel.frame = CGRect(x: 80, y: 60, width: self.view.frame.width - 160, height: 20)
        segmentMessage.frame = CGRect(x: 60, y: 90, width: self.view.frame.width - 120, height: 30)
        enterMessageLbl.frame = CGRect(x: 15, y: self.view.frame.height / 4.2, width: 150, height: 20)
        textViewMainMessage.frame = CGRect(x: 15, y: self.view.frame.height / 3.7, width: self.view.frame.width - 30, height: self.view.frame.height / 3.5)
        imageViewReply.frame = textViewMainMessage.frame
        tapButton.frame = textViewMainMessage.frame
        sendButton.frame = CGRect(x: 15, y: self.view.frame.height - 70, width: self.view.frame.width - 30, height: 50)
        
        if view.frame.height == 812 {
              replyLabel.frame = CGRect(x: self.view.frame.width / 3, y: 15 + 15, width: 120, height: 30)
            downButton.frame = CGRect(x: 10, y: 10 + 20, width: 45, height: 45)
        }
        tapButton.isHidden = true
       sendButton.layer.cornerRadius = 24
        sendButton.clipsToBounds = true 
        imageViewReply.isHidden = true
        let myColor = UIColor.gray
        self.textViewMainMessage.layer.borderColor = myColor.cgColor
        self.textViewMainMessage.layer.borderWidth = 1.0

        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var boolgle: Bool?
    func checkIfImBlocked () {
        let ref = Database.database().reference()
        if let sendToUserId = creatorId {
            if let myIDI = Auth.auth().currentUser?.uid {
                
                ref.child("users").child(sendToUserId).child("Blocked").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                    if let blockeders = snapshot.value as? [String : AnyObject] {
                        for (_, val) in blockeders {
                            if val as! String == myIDI {
                                self.boolgle = false
                                print("your blocked")
                            }
                        }
                    }
                }, withCancel: nil)
            }
        }
    }
    

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        return numberOfChars < 622
    }

    
    
    @IBAction func tapButtonAction(_ sender: Any) {
        textViewMainMessage.text = ""
        var pageAlert = UIAlertController()
        pageAlert = UIAlertController(title: "Add Image", message: "Chose a way to add an image", preferredStyle: UIAlertControllerStyle.actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { (action : UIAlertAction!) -> Void in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
            
        })
        let library = UIAlertAction(title: "Library", style: .default, handler: { (action : UIAlertAction!) -> Void in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
            
        })
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        pageAlert.addAction(camera)
        pageAlert.addAction(library)
        pageAlert.addAction(cancel)
        self.present(pageAlert, animated: true, completion: nil)

    }
    @IBAction func downAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func pullname () {
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        if let uid = uid {
            ref.child("users").child(uid).child("Username").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                self.myUsername = snapshot.value as? String
                
            })
        }
    }

    @IBAction func segmentAction(_ sender: Any) {
        if segmentMessage.selectedSegmentIndex == 1 {
            tapButton.isHidden = false
                      imageViewReply.isHidden = false
            textViewMainMessage.isHidden = true
           enlabel.isHidden = true 
        }
        else {
            tapButton.isHidden = true
           
            imageViewReply.isHidden = true
            textViewMainMessage.isHidden = false
            enlabel.isHidden = false
            
        }
    }
    var selectedImage: UIImage?
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       textViewMainMessage.text = ""
        selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageViewReply.image = selectedImage
        selectedImage?.accessibilityIdentifier = "selectedImage"
        
        self.dismiss(animated: true, completion: nil)
        tapButton.titleLabel?.isHidden = true
        
    }
   
    func textViewDidBeginEditing(_ textView: UITextView) {
        imageViewReply.image = nil
    }
    let uid = Auth.auth().currentUser?.uid
    @IBAction func sendButtonAction(_ sender: Any) {
       
        let ref = Database.database().reference()

        if let myId = uid {
        if let sendToId = creatorId {
            
            if boolgle != false {
               
        if imageViewReply.image != nil, textViewMainMessage.text == "" {
              sendButton.isHidden = true
            let storage = Storage.storage().reference(forURL: "gs://bindshare-a7805.appspot.com")

            let imageImage = imageViewReply.image
            let myName = Auth.auth().currentUser?.displayName
            if let creatorName = myName {
             if let myUn = self.myUsername {
            if let imager = imageImage {
            let timeStamp: Int = Int(NSDate().timeIntervalSince1970)

            view.addSubview(activIndc)
                activIndc.startAnimating()
            let key = ref.child("users").child(sendToId).child("Notifications").childByAutoId().key
            let imageRef = storage.child("Messages").child(sendToId).child("\(key).jpg)")
            let data = UIImageJPEGRepresentation(imager, 0.6)
            let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
                if let errler = error {
                    let alert = UIAlertController(title: "There was a problem", message: "We have our best chimps working to solve your problem", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Alright", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    self.activIndc.stopAnimating()
                    print(errler)
                }
                else {
                    imageRef.downloadURL(completion: { (url, errir) in
                        if let erlli = errir {
                            print(erlli.localizedDescription)
                        }
                        if let url = url {
                            let notif = ["ImageUrl" : url.absoluteString, "senderId" : myId, "creatorName" : creatorName, "creatorUsername" : myUn, "timeStamp" : timeStamp, "key" : key, "notSeen" : "notSeen"] as [String : Any]
                            let feedPost = ["\(key)" : notif]
                            ref.child("users").child(sendToId).child("Notifications").updateChildValues(feedPost)
                            self.activIndc.stopAnimating()
                            let messgae = "New message from \(creatorName)"
                            let title = ""
                            
                            if let thierKey = self.theirKey {
                                OneSignal.postNotification(["headings": ["en": title], "contents": ["en": messgae], "include_player_ids": [thierKey]])
                            }

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
        if textViewMainMessage.text != "", imageViewReply.image == nil {
            if let myUn = myUsername {
                if let myname = Auth.auth().currentUser?.displayName {
                    let key = ref.child("users").child(sendToId).child("Notifications").childByAutoId().key
                    let timeStamp: Int = Int(NSDate().timeIntervalSince1970)

                    let notif = ["messageText" : textViewMainMessage.text, "senderId" : myId, "creatorName" : myname, "creatorUsername" : myUn, "timeStamp" : timeStamp, "key" : key, "notSeen" : "notSeen"] as [String : Any]
                    let feidPost = ["\(key)" : notif]
                    ref.child("users").child(sendToId).child("Notifications").updateChildValues(feidPost)
                
                    let messgae = "New message from \(myname)"
                    let title = ""
                    
                    if let thierKey = self.theirKey {
                        OneSignal.postNotification(["headings": ["en": title], "contents": ["en": messgae], "include_player_ids": [thierKey]])
                    }
                }
                self.dismiss(animated: true, completion: nil)
            }
            
            }
        }
            else {
                let alertir = UIAlertController(title: "You cannot send a message to this user", message: "Sorry, You cannot message this user", preferredStyle: .alert)
                let action = UIAlertAction(title: "Okay", style: .cancel, handler: {( alert : UIAlertAction) -> Void in
                    self.dismiss(animated: true, completion: nil)
                })
            
                alertir.addAction(action)
                self.present(alertir, animated: true, completion: nil)
            }
    }
    }
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
