//
//  NotificationsViewController.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 6/30/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let uid = Auth.auth().currentUser?.uid
    var notifications = [Notification]()
    @IBOutlet weak var tableViewNotifications: UITableView!
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        if let uidmi = Auth.auth().currentUser?.uid {
        let refer = Database.database().reference().child("users").child(uidmi).child("Notifications")
        refer.removeAllObservers()
            print("remove messages observer")
        }
    }
        var username: String?
       @IBOutlet weak var cancelButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewNotifications.delegate = self
        tableViewNotifications.dataSource = self

        if Auth.auth().currentUser?.displayName != nil, Auth.auth().currentUser?.uid != nil {
        pullname()
        }
        self.navigationController?.navigationBar.tintColor = UIColor.white

        if Auth.auth().currentUser?.displayName != nil, Auth.auth().currentUser?.uid != nil {
            notifications.removeAll()
            checkIfDuplicated.removeAll()
            pull()
        }
        
        tableViewNotifications.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        // Do any additional setup after loading the view.
    }
    @IBAction func addFunction(_ sender: Any) {
        if let username = username {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newNotification") as! NewMessageViewController
        vc.username = username
        self.present(vc, animated: true, completion: nil)
        }
    }

    func pullname () {
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        if let uid = uid {
            ref.child("users").child(uid).child("Username").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                              self.username = snapshot.value as? String
               
            })
        }
    }
    
    
  
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let uidd = Auth.auth().currentUser?.uid
        if let uid = uidd {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
                           if let key = self.notifications[indexPath.row].key {
                    let ref = Database.database().reference()
                    ref.child("users").child(uid).child("Notifications").child(key).removeValue()
                }
              self.notifications.remove(at: indexPath.row)
                self.tableViewNotifications.reloadData()
            }
        }
    }

    
    var checkIfDuplicated = [String]()
    func pull () {
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        if let uuuid = uid {
            ref.child("users").child(uuuid).child("Notifications").queryOrderedByKey().observe(.value, with: { (snapshot) in
                if let notifics = snapshot.value as? [String : AnyObject] {
                    for (_, vel) in notifics {
                        if let url = vel["ImageUrl"] as? String {
                            let newNot = Notification()
                            if let senderName = vel["creatorName"] as? String, let senderUsername = vel["creatorUsername"] as? String, let senderUid = vel["senderId"] as? String, let timeStamp = vel["timeStamp"] as? Int, let key = vel["key"] as? String {
                                newNot.sender = senderName
                                newNot.senderUsername = senderUsername
                                newNot.senderUid = senderUid
                                newNot.time = timeStamp
                                newNot.key = key
                                newNot.imageUrl = url
                                if let notSeenYet = vel["notSeen"] as? String {
                                    newNot.unseenMessage = notSeenYet
                                }
                                if self.checkIfDuplicated.contains(key) {
                                    print("already")
                                }
                                else {
                                    self.notifications.append(newNot)
                                    self.checkIfDuplicated.append(key)
                                }
                            }
                        }
                        if let message = vel["messageText"] as? String {
                            let newm = Notification()
                            if let senderName = vel["creatorName"] as? String, let senderUsername = vel["creatorUsername"] as? String, let senderUid = vel["senderId"] as? String, let timeStamp = vel["timeStamp"] as? Int, let key = vel["key"] as? String{
                                
                                newm.sender = senderName
                                newm.senderUsername = senderUsername
                                newm.senderUid = senderUid
                                newm.time = timeStamp
                                newm.key = key
                                newm.message = message
                                if let notSeenYet = vel["notSeen"] as? String {
                                    newm.unseenMessage = notSeenYet
                                }
                                if self.checkIfDuplicated.contains(key) {
                                    print("already")
                                }
                                else {
                                    self.notifications.append(newm)
                                    self.checkIfDuplicated.append(key)
                                }
                            }
                        }
                        if let friendRequest = vel["friendRequest"] as? String {
                            let friendReq = Notification()
                            if let senderName = vel["creatorName"] as? String, let senderUsername = vel["creatorUsername"] as? String, let senderUid = vel["senderId"] as? String, let timeStamp = vel["timeStamp"] as? Int, let key = vel["key"] as? String {
                                friendReq.sender = senderName
                                friendReq.senderUsername = senderUsername
                                friendReq.senderUid = senderUid
                                friendReq.time = timeStamp
                                friendReq.key = key
                                friendReq.friendRequest = friendRequest
                                if let notSeenYet = vel["notSeen"] as? String {
                                    friendReq.unseenMessage = notSeenYet
                                }
                                
                                if self.checkIfDuplicated.contains(key) {
                                    print("already")
                                }
                                else {
                                    self.notifications.append(friendReq)
                                    self.checkIfDuplicated.append(key)
                                }
                                
                            }
                        }
                        if let binderRequest = vel["RequestBinder"] as? String {
                            let binderReq = Notification()
                            if let senderName = vel["creatorName"] as? String, let senderUsername = vel["creatorUsername"] as? String, let senderUid = vel["senderId"] as? String, let timeStamp = vel["timeStamp"] as? Int, let key = vel["key"] as? String, let bindkey = vel["binderKey"] as? String, let binderTitle = vel["binderName"] as? String {
                                binderReq.sender = senderName
                                binderReq.senderUsername = senderUsername
                                binderReq.senderUid = senderUid
                                binderReq.time = timeStamp
                                binderReq.key = key
                                binderReq.binderKey = bindkey
                                binderReq.binderRequest = binderRequest
                                binderReq.binderTitle = binderTitle
                                if let notSeenYet = vel["notSeen"] as? String {
                                    binderReq.unseenMessage = notSeenYet
                                }
                                
                                
                                if self.checkIfDuplicated.contains(key) {
                                    print("already")
                                }
                                else {
                                    self.notifications.append(binderReq)
                                    self.checkIfDuplicated.append(key)
                                }
                                
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableViewNotifications.reloadData()
                    }
                }

            }, withCancel: nil)
            
        }
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewNotifications.dequeueReusableCell(withIdentifier: "notifys", for: indexPath) as! NoticationsTableViewCell
        
        cell.notSeenView.frame = CGRect(x: 6, y: 28, width: 12, height: 12)
        cell.NameLabel.frame = CGRect(x: 20, y: 10, width: cell.frame.width / 2, height: 21)
        cell.usernameLabel.frame = CGRect(x: 20, y: cell.frame.height - 24, width: cell.frame.width / 2.5, height: 12)
        cell.timeLabel.frame = CGRect(x: cell.frame.width - 180, y: 28, width: 170, height: 12)
        
        
        
        if notifications.count != 0 {
            notifications.sort { $1.time < $0.time }
        }
        if notifications.count != 0 {
        if let seconds = notifications[indexPath.row].time {
         
            let time = Date(timeIntervalSince1970: TimeInterval(seconds))
            
            let dateComponentsFormater = DateComponentsFormatter()
            
            dateComponentsFormater.unitsStyle = .short
                       dateComponentsFormater.allowedUnits = [.day, .hour, .minute]
                 let stringg = dateComponentsFormater.string(from: time, to: Date())
                     let finalString = "\(stringg!)(s) ago"
         cell.timeLabel.text = finalString
        }
        }
        if let notSeenMessage = notifications[indexPath.row].unseenMessage {
           
            cell.notSeenView.backgroundColor = .blue
            cell.notSeenView.layer.cornerRadius = 12
//            cell.notSeenView.clipsToBounds = true
            print(notSeenMessage)
            
        } else {
            cell.notSeenView.backgroundColor = .clear
        }
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth = 1
        cell.clipsToBounds = true
        cell.NameLabel.text = notifications[indexPath.row].sender
        cell.usernameLabel.text = notifications[indexPath.row].senderUsername
        
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = .white
        navigationItem.backBarButtonItem = backButton
        if segue.identifier == "segueNotify" {
            let destvc = segue.destination as! SelectedMessageViewController
            let index = tableViewNotifications.indexPathForSelectedRow!
            destvc.username = notifications[index.row].senderUsername
            destvc.title = notifications[index.row].sender
                      if let imageurl = notifications[index.row].imageUrl {
                print("seguing")
                 destvc.imageUr = imageurl
            }
            if let mezzage = notifications[index.row].message {
                destvc.message = mezzage
              
            }
            if let keyp = notifications[index.row].key {
                destvc.reqNotKey = keyp
                
            }
            if let uidSender = notifications[index.row].senderUid {
                if let myUid = Auth.auth().currentUser?.uid {
                    if myUid != uidSender {
                destvc.messageCreatorUid = uidSender
                print(uidSender)
                    }
                }
            }
            if let notSeener = notifications[index.row].unseenMessage {
              
                
                destvc.notSeen = notSeener
                
                
            }
        }

    }
     var sharers = [String]()
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "segueNotify" {
            let index = tableViewNotifications.indexPathForSelectedRow!
            if let friendReques = notifications[index.row].friendRequest {
                
                // unseen message removal friend request
                if let netSeen = notifications[index.row].unseenMessage {
                    if let keyl = notifications[index.row].key {
                        let ref = Database.database().reference()
                            if let myuID = Auth.auth().currentUser?.uid {
                                print(netSeen)
                            ref.child("users").child(myuID).child("Notifications").child(keyl).child("notSeen").removeValue()
                        }
                    }
                }
                // friend request
                print(friendReques)
                let alert = UIAlertController(title: "Friend Request from \(notifications[index.row].sender!)", message: "\(notifications[index.row].senderUsername!)", preferredStyle: .alert)
                
                var followings = [String]()
               
                    let ref = Database.database().reference()
                    let uidi = Auth.auth().currentUser?.uid
                    if let uid = uidi {
                ref.child("users").child(uid).child("friends").queryOrderedByKey().observeSingleEvent(of: .value, with:  { snapshot in
                            if let following = snapshot.value as? [String : AnyObject] {
                                for (_, value) in following {
                                    
                                    followings.append(value as! String)
                                }
                               
                            }
                            
                        })
                        
                    }
                  
                
                
                // accept friend request
                let accept = UIAlertAction(title: "Accept", style: .default, handler: { (action : UIAlertAction!) -> Void in
                    if let creatorId = self.notifications[index.row].senderUid {
                        if followings.contains(creatorId) {
                            // if this is already a friend - error checker just in case
                            print("nope")
                            if let keyt = self.notifications[index.row].key {
                                if let uidd = self.uid {
                             ref.child("users").child(uidd).child("Notifications").child(keyt).removeValue()
                                }
                            }
                        }
                        else {
                        if let keyt = self.notifications[index.row].key {
                            
                            if let uidd = self.uid {
                            
                                let ref = Database.database().reference()
                                let keyz = ref.child("users").child(uidd).child("friends").childByAutoId().key
                            
                                let myfriend = [keyz : creatorId]
                                let theirFriend = [keyz : uidd]
                                ref.child("users").child(uidd).child("friends").updateChildValues(myfriend)
                                print("appendding friends")
                                ref.child("users").child(creatorId).child("friends").updateChildValues(theirFriend)
                                ref.child("users").child(uidd).child("Notifications").child(keyt).removeValue()
                                
                            }
                            
                        }
                    }
                    }
                  
                    self.notifications.remove(at: index.row)
                    self.tableViewNotifications.reloadData()

                })
                // decline friend request
                let decline = UIAlertAction(title: "Decline", style: .default, handler: { (action : UIAlertAction!) -> Void in
                    if let myuid = self.uid {
                        if let key = self.notifications[index.row].key {
                            let ref = Database.database().reference()
                            ref.child("users").child(myuid).child("Notifications").child(key).removeValue()
                            
                        }
                    }

                    self.notifications.remove(at: index.row)
                    self.tableViewNotifications.reloadData()
                })
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancel)
                alert.addAction(accept)
                alert.addAction(decline)
                self.present(alert, animated: true, completion: nil)
                return false
            }
            
           //binder request
            if let binderRequest = notifications[index.row].binderRequest {
                 // remove seen for binder request
                if let netSeen = notifications[index.row].unseenMessage {
                    if let keyl = notifications[index.row].key {
                        let ref = Database.database().reference()
                        if let myuID = Auth.auth().currentUser?.uid {
                            print(netSeen)
                            ref.child("users").child(myuID).child("Notifications").child(keyl).child("notSeen").removeValue()
                        }
                    }
                }

                // grab sharers in binder if there is a binder request
                if let binderkey = notifications[index.row].binderKey {
                        let ref = Database.database().reference()
                            print(binderRequest)
                    ref.child("Binders").child(binderkey).child("sharers").observeSingleEvent(of: .value, with: { (snapshot) in 
                                if let sheres = snapshot.value as? [String] {
                                    for each in sheres {
                                        self.sharers.append(each)
                                    }
                                }
                            })
                }
                
                if let binderName = notifications[index.row].binderTitle, let senderId = notifications[index.row].senderUid, let senderUn = notifications[index.row].senderUsername, let senderName = notifications[index.row].sender, let binderKeyp = notifications[index.row].binderKey {
                let alert = UIAlertController(title: "Binder request from: \(senderUn) ", message: "\(senderName) would like to join your binder named: \(binderName)", preferredStyle: .alert)
                    
                    
                    // accept binder request
                    let accept = UIAlertAction(title: "Accept", style: .default, handler: { (action : UIAlertAction!) -> Void in
                        if let myuid = self.uid {
                            if let key = self.notifications[index.row].key {
                        if self.sharers.count != 0 {
                            self.sharers.append(senderId)
                        let shareers = ["sharers" : self.sharers]
                            let ref = Database.database().reference()
                            ref.child("Binders").child(binderKeyp).child("sharers").removeValue()
                            ref.child("Binders").child(binderKeyp).updateChildValues(shareers)
                            ref.child("users").child(myuid).child("Notifications").child(key).removeValue()
                                }
                            }
                        }
                       self.notifications.remove(at: index.row)
                        self.tableViewNotifications.reloadData()

                        
                    })
                    // decline binder request
                    let decline = UIAlertAction(title: "Decline", style: .default, handler: { (action :
                        UIAlertAction!) -> Void in
                        
                        if let myuid = self.uid {
                            if let key = self.notifications[index.row].key {
                                let ref = Database.database().reference()
                                ref.child("users").child(myuid).child("Notifications").child(key).removeValue()
                                
                            }
                        }
                        self.notifications.remove(at: index.row)
                        self.tableViewNotifications.reloadData()

                    })
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alert.addAction(cancel)
                    alert.addAction(accept)
                    alert.addAction(decline)
                    self.present(alert, animated: true, completion: nil)
                
                }
                
                return false
                
            }
        }
         // if not friend request or binder request
        return true
    }
    
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         let lipto = tableViewNotifications.cellForRow(at: indexPath) as! NoticationsTableViewCell
        
        if let notSeener = notifications[indexPath.row].unseenMessage {
            lipto.backgroundColor = .clear
            notifications[indexPath.row].unseenMessage = nil
            tableViewNotifications.reloadRows(at: [indexPath], with: .automatic)
            print(notSeener)
        }
        
        
        
        tableViewNotifications.deselectRow(at: indexPath, animated: true)
    }
}
