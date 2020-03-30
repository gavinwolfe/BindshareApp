//
//  SelectedUserMessageViewController.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 8/20/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase
import OneSignal
// send message to certain selected user (text only)

class SelectedUserMessageViewController: UIViewController, UITextViewDelegate {
    var toUsername: String?
    var toUid: String?
    var uid = Auth.auth().currentUser?.uid
    var myUsername: String?
    override func viewWillAppear(_ animated: Bool) {
        textviewMessage.becomeFirstResponder()
    }
    var theirKey: String?
    @IBOutlet weak var buttonDismiss: UIButton!
    @IBOutlet weak var messageSelectedUser: UILabel!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var enterAmessage: UILabel!
    @IBOutlet weak var sendButton: UIButton!

    @IBOutlet weak var textviewMessage: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let uder = toUid {
            let ref = Database.database().reference()
            ref.child("users").child(uder).child("userKey").observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    self.theirKey = snapshot.value as? String
                }
            })
        }
        
        buttonDismiss.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        messageSelectedUser.frame = CGRect(x: 50, y: 20, width: self.view.frame.width - 100, height: 30)
        dividerView.frame = CGRect(x: 5, y: 70, width: self.view.frame.width - 10, height: 3)
        toLabel.frame = CGRect(x: 15, y: 80, width: 50, height: 25)
        usernameLabel.frame = CGRect(x: 80, y: 80, width: self.view.frame.width - 85, height: 25)
        enterAmessage.frame = CGRect(x: 15, y: 120, width: self.view.frame.width - 30, height: 20)
        textviewMessage.frame = CGRect(x: 15, y: 150, width: self.view.frame.width - 30, height: self.view.frame.height / 3)
        sendButton.frame = CGRect(x: 15, y: self.view.frame.height - 70, width: self.view.frame.width - 30, height: 50)
        
        checkIfImBlocked()
        checkIfTheirBlocked()
        sendButton.layer.cornerRadius = 24
        sendButton.clipsToBounds = true 
        self.navigationController?.navigationBar.tintColor = UIColor.white

        if let sendToUn = toUsername {
            usernameLabel.text = sendToUn
        }
        
         self.navigationController?.navigationBar.tintColor = UIColor.white
        if Auth.auth().currentUser?.uid != nil, Auth.auth().currentUser?.displayName != nil {
            pullname()
        }
        // Do any additional setup after loading the view.
    }

    var imBlocked: Bool?
    
    func checkIfImBlocked () {
        let ref = Database.database().reference()
        if let sendToUserId = toUid {
            if let myIDI = Auth.auth().currentUser?.uid {
                
                ref.child("users").child(sendToUserId).child("Blocked").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                    if let blockeders = snapshot.value as? [String : AnyObject] {
                        for (_, val) in blockeders {
                            if val as! String == myIDI {
                              
                                print("your blocked")
                                self.imBlocked = true
                            }
                        }
                    }
                }, withCancel: nil)
            }
        }
    }
    
    
    // check if selected user is blocked
    var boolgle: Bool?
    func checkIfTheirBlocked () {
        let ref = Database.database().reference()
        if let sendToUserId = toUid {
            if let myId = Auth.auth().currentUser?.uid {
                
                ref.child("users").child(myId).child("Blocked").queryOrderedByKey().observe(.value, with: { snapshot in
                    if let blockeders = snapshot.value as? [String : AnyObject] {
                        for (_, velt) in blockeders {
                            if velt as! String == sendToUserId {
                                self.boolgle = false
                                
                            }
                        }
                    }
                    
                })
                ref.removeAllObservers()
                
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var myNameFull: String?
    @IBAction func sendButtonAction(_ sender: Any) {
        sendButton.isHidden = true
        let ref = Database.database().reference()
        if textviewMessage.text == "" {
            
            let aleerrt = UIAlertController(title: "Enter a message", message: "There is no message entered, please enter a message", preferredStyle: .alert)
            let acttionn = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            aleerrt.addAction(acttionn)
            self.present(aleerrt, animated: true, completion: nil)
            sendButton.isHidden = false
        }
        if textviewMessage.text != "" {
            
            if let uip = uid {
                if  Auth.auth().currentUser?.displayName != nil {
                    myNameFull = Auth.auth().currentUser?.displayName
                }
                
                if imBlocked != true {
                if boolgle != false {
                let timeStamp: Int = Int(NSDate().timeIntervalSince1970)

                if let toId = toUid {
               
                    if let miUsername = myUsername {
                        let key =
                            ref.child("users").child(toId).child("Notifications").childByAutoId().key
                        
                        let notif = ["messageText" : textviewMessage.text, "senderId" : uip, "creatorName" : myNameFull!, "creatorUsername" : miUsername, "timeStamp" : timeStamp, "key" : key, "notSeen" : "notSeen"] as [String : Any]
                        let feidPost = ["\(key)" : notif]
                        ref.child("users").child(toId).child("Notifications").updateChildValues(feidPost)
                        let messgae = "New message from \(myNameFull!)"
                        let title = ""
                        
                        if let thierKey = theirKey {
                            OneSignal.postNotification(["headings": ["en": title], "contents": ["en": messgae], "include_player_ids": [thierKey]])
                        }
                    }
                self.dismiss(animated: true, completion: nil)
            }
                }
                else if boolgle == false {
                    let anotherAlert = UIAlertController(title: "This user is blocked", message: "This user is already in your blocked users list, you can remove them by going to friends/search users, then find their name and click unblock", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Okay", style: .cancel, handler: {( alert : UIAlertAction) -> Void in
                        self.dismiss(animated: true, completion: nil)
                    })
                    anotherAlert.addAction(action)
                    self.present(anotherAlert, animated: true, completion: nil)
                }
            }
                else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    func pullname () {
        let ref = Database.database().reference()
              if let uid = uid {
            ref.child("users").child(uid).child("Username").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                self.myUsername = snapshot.value as? String
                
            })
        }
    }

    
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        if textviewMessage.isFirstResponder == true {
        textviewMessage.resignFirstResponder()
        }
    }
  
}
