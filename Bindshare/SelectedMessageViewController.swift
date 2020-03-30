//
//  SelectedMessageViewController.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 7/10/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class SelectedMessageViewController: UIViewController {
    
    @IBOutlet weak var blockButton: UIButton!
    var messageCreatorUid: String?
    var name: String?
    var username: String?
    var message: String?
    var imageUr: String?
    let loader = UIActivityIndicatorView()
    var friendReq: String?
    var reqNotKey: String?
    let uid = Auth.auth().currentUser?.uid
    var uidOfCreator: String?
    var notSeen: String? 
    
     let session = URLSession.shared
    @IBOutlet weak var imageViewMessage: UIImageView!
      
    @IBOutlet weak var messageLabel: UILabel!

    @IBOutlet weak var zoomPhoto: UIButton!
    
    @IBOutlet weak var labelUsername: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        labelUsername.frame = CGRect(x: 15, y: 80, width: 200, height: 20)
        blockButton.frame = labelUsername.frame
        zoomPhoto.frame = CGRect(x: 5, y: 110, width: self.view.frame.width - 10, height: self.view.frame.height - 110)
        imageViewMessage.frame = zoomPhoto.frame
        messageLabel.frame = CGRect(x: 10, y: 110, width: self.view.frame.width - 20, height: self.view.frame.height / 3)
        
        
        if view.frame.height == 812 {
   labelUsername.frame = CGRect(x: 15, y: 80 + 30, width: 200, height: 20)        }
        if let messagerId = messageCreatorUid {
            print(messagerId)
        }
       
        checkIfTheirBlocked()
      
        self.navigationController?.navigationBar.tintColor = UIColor.white

        loader.frame = CGRect(x: self.view.frame.width / 2.25, y: self.view.frame.height / 2, width: 30, height: 30)
        loader.color = UIColor.black
        
        if let mezage = message {
       print("there is a message")
            zoomPhoto.isEnabled = false
            print(mezage)
            if let myId = Auth.auth().currentUser?.uid {
                if let keyy = reqNotKey {
                    if let notSeenYet = notSeen {
                        print(notSeenYet)
                        let ref = Database.database().reference()
            
            ref.child("users").child(myId).child("Notifications").child(keyy).child("notSeen").removeValue()
                    }
            }
            }
            self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(funcly)), animated: true)

            
        }
        else {
            loader.startAnimating()
            view.addSubview(loader)
        }
        
        if let photoUrl = imageUr {
            if let myUid = uid {
            if let keyy = reqNotKey {
                if let notSeenYet = notSeen {
                    print(notSeenYet)
                    let ref = Database.database().reference()
                    
                    ref.child("users").child(myUid).child("Notifications").child(keyy).child("notSeen").removeValue()
                }
            }
            }

                        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(funcly)), animated: true)

                      let url = URL(string: photoUrl)
             session.dataTask(with: url!, completionHandler: { (data, response, error) in
                if let errle = error {
                    print(errle.localizedDescription)
                }
                if data != nil {
                DispatchQueue.main.async {
                    self.imageViewMessage.image = UIImage(data: data!)
                    self.loader.stopAnimating()
                    print("loaded")
                }
                }
                
            }).resume()
             session.finishTasksAndInvalidate()
        }
       
        
        if let freindre = friendReq {
            zoomPhoto.isEnabled = false
            loader.stopAnimating()
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            print(freindre)
        }
        if let username = username {
            labelUsername.text = username
        }
        if let message = message {
            messageLabel.text = message 
        }
        
   
        // Do any additional setup after loading the view.
    }

    var boolgle: Bool?
    func checkIfTheirBlocked () {
        let ref = Database.database().reference()
        if let sendToUserId = messageCreatorUid {
            if let myId = Auth.auth().currentUser?.uid {
                
                ref.child("users").child(myId).child("Blocked").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                    if let blockeders = snapshot.value as? [String : AnyObject] {
                        for (_, velt) in blockeders {
                            if velt as! String == sendToUserId {
                                self.boolgle = false
                                
                            }
                        }
                    }
                }, withCancel: nil)
                
            }
        }
    }

    
    
       @objc func funcly () {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "replyMessage") as! ReplyViewController
        if let creatorUid = messageCreatorUid {
        if let username = username {
            if boolgle != false {
        vc.string = username
        vc.creatorId = creatorUid
                self.present(vc, animated: true , completion: nil)

            }
            if boolgle == false {
                    let anotherAlert = UIAlertController(title: "This user is blocked", message: "This user is already in your blocked users list, you can remove them by going to friends/search users, then find their name and click unblock", preferredStyle: .alert)
                    let cancl = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                    anotherAlert.addAction(cancl)
                    self.present(anotherAlert, animated: true, completion: nil)
            }
            }
               }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "zoomSegue" {
            let destVC = segue.destination as! ZoomNotificationImageViewController
            destVC.image = imageViewMessage.image
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

    var followings = [String]()
    var booliit: Bool?
    var isAFriend: Bool?
    @IBAction func blockAction(_ sender: Any) {
        isAFriend = false 
        let ref = Database.database().reference()
        if let myId = self.uid {
            if let messagerId = self.messageCreatorUid {
                
                
                ref.child("users").child(myId).child("Blocked").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                    if let blockeders = snapshot.value as? [String : AnyObject] {
                        for (_, velt) in blockeders {
                            if velt as! String == messagerId {
                                self.booliit = false
                            }
                        }
                    }
                }, withCancel: nil)

                if let miId = Auth.auth().currentUser?.uid {
                    ref.child("users").child(miId).child("friends").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snappy) in
                        if let friendz = snappy.value as? [String : String] {
                            for (_, lip) in friendz {
                                if lip == messagerId {
                                    self.isAFriend = true
                                }
                            }
                            
                        }
                    }, withCancel: nil)
                }
                
        let alert = UIAlertController(title: "Select what you want to do", message: "Would you like to block this user?", preferredStyle: .alert)
        let blockEm = UIAlertAction(title: "Block", style: .default, handler: {( alert : UIAlertAction) -> Void in
            if self.booliit != false {
                    let key = ref.child("users").child(myId).child("Blocked").childByAutoId().key
                    let myBlockers = [key: messagerId]
                    ref.child("users").child(myId).child("Blocked").updateChildValues(myBlockers)
            }
            else {
               let anotherAlert = UIAlertController(title: "You have already blocked this user", message: "This user is already in your blocked users list, you can remove them by going to friends/search users, then find their name and click unblock", preferredStyle: .alert)
                let cancl = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                anotherAlert.addAction(cancl)
                self.present(anotherAlert, animated: true, completion: nil)
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//                if followings.count != 0 {
//                for each in followings {
//                    if each == messagerId {
//                        print("isAFRIEND")
//                        isAFriend = true
//                    }
//                    }
//                }
                if isAFriend == false {
                    alert.addAction(blockEm)

                                    }
                else {
                 

                }
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
            
            }
        }
    }
}
