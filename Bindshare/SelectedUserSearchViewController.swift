//
//  SelectedUserSearchViewController.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 9/27/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase
import OneSignal

class SelectedUserSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messageButton: UIButton!
    var binds = [Binder]()
    var friends = [usera]()
    var isThisAFriend: Bool?
    var areTheyBlocked: Bool?
    var alreadyRequested: Bool?
    
    var indexPather: IndexPath? 
    var username: String?
    var theirUsername: String?
    var theirName: String?
    var theirUid: String?
    var theirKet: String?
  
    let session = URLSession.shared
    @IBOutlet weak var unBlockButton: UIButton!
    // viewdidload *************************************
    override func viewDidLoad() {
        super.viewDidLoad()

        if let theirIdx = theirUid {
        let ref = Database.database().reference()
        ref.child("users").child(theirIdx).child("userKey").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                self.theirKet = snapshot.value as? String
            }
        })
        }
        messageButton.frame = CGRect(x: self.view.frame.width - 100, y: 70, width: 95, height: 30)
        selectedUserImageView.frame = CGRect(x: self.view.frame.width / 2.55, y: 80, width: self.view.frame.width / 4.5, height: 80)
        checkIfImBlocked()
        unBlockButton.frame = CGRect(x: 10, y: 70, width: 100, height: 30)
        labelName.frame = CGRect(x: 50, y: 165, width: self.view.frame.width - 100, height: 20)
        labelUsername.frame = CGRect(x: 50, y: 185, width: self.view.frame.width - 100, height: 20)
        tableViewBindersFriends.frame = CGRect(x: 15, y: self.view.frame.height / 2.25, width: self.view.frame.width - 30, height: self.view.frame.height / 2)
        segmentControl.frame = CGRect(x: 50, y: self.view.frame.height / 2.75, width: self.view.frame.width - 100, height: 30)
        
        isAFriendCircleView.frame = CGRect(x: self.view.frame.width / 1.6, y: 85, width: 14, height: 14)
        segmentControl.layer.cornerRadius = 12.0
        segmentControl.clipsToBounds = true
        segmentControl.layer.borderWidth = 1.0
        segmentControl.layer.borderColor = UIColor.black.cgColor
        messageButton.layer.cornerRadius = 12.0
        messageButton.clipsToBounds = true
        isAFriendCircleView.isHidden = true
        messageButton.layer.borderWidth = 1.0
        messageButton.layer.borderColor = UIColor.white.cgColor
        
        selectedUserImageView.layer.cornerRadius = 32.0
        selectedUserImageView.clipsToBounds = true
        grabProfilePhoto()
        self.unBlockButton.isHidden = true
        pullBinders()
        pullTheirFriends()
        tableViewBindersFriends.delegate = self
        tableViewBindersFriends.dataSource = self
        pullname()
        CheckIfThereIsAlreadyFriendReq()
        checkIfUserIsBlocked()
   
        if view.frame.height == 812 {
            messageButton.frame = CGRect(x: self.view.frame.width - 100, y: 100, width: 95, height: 30)
            selectedUserImageView.frame = CGRect(x: self.view.frame.width / 2.55, y: 110, width: self.view.frame.width / 4.5, height: 80)
             isAFriendCircleView.frame = CGRect(x: self.view.frame.width / 1.6, y: 105, width: 14, height: 14)
            unBlockButton.frame = CGRect(x: 10, y: 100, width: 100, height: 30)

        }
        
        if let usernameSender = theirUsername {
            labelUsername.text = usernameSender
            
        }
        if let namer = theirName {
            labelName.text = namer
        }
        checkIfUserIsFriend()
        isAFriendCircleView.layer.cornerRadius = 16.0
        isAFriendCircleView.clipsToBounds = true
    }
    
    func grabProfilePhoto () {
        if let theirId = theirUid {
            let ref = Database.database().reference()
            ref.child("users").child(theirId).child("profileImageUrl").observeSingleEvent(of: .value, with: { (snapshot) in
                if let imageUrl = snapshot.value as? String {
                    let url = URL(string: imageUrl)
                    self.session.dataTask(with: url!, completionHandler: { (data, response, error) in
                        if let errle = error {
                            print(errle.localizedDescription)
                        }
                        if data != nil {
                            DispatchQueue.main.async {
                                self.selectedUserImageView.image = UIImage(data: data!)
                                print("loaded")
                            }
                        }
                        
                    }).resume()
               
                }
                
            })
        }
        session.finishTasksAndInvalidate()
    }
    
    
    func pullname () {
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        if let uid = uid {
            ref.child("users").child(uid).child("Username").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                self.username = snapshot.value as? String
                
            })
            ref.removeAllObservers()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentControl.selectedSegmentIndex == 1 {
            return friends.count
        } else {
        return binds.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewBindersFriends.dequeueReusableCell(withIdentifier: "cellSelectedUser") as! SearchUserSelectedTableViewCell
        if segmentControl.selectedSegmentIndex == 1 {
            cell.labelMain.text = friends[indexPath.row].name
        } else {
        cell.labelMain.text = binds[indexPath.row].title
        }
        return cell
    }
    
    @IBAction func unblockAction(_ sender: Any) {
        unBlockButton.isHidden = true
        let ref = Database.database().reference()
        if let uidi = Auth.auth().currentUser?.uid {
            if let theirID = theirUid {
                ref.child("users").child(uidi).child("Blocked").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                    if let friendz = snapshot.value as? [String : String] {
                        for (era,ver) in friendz {
                            if ver  == theirID {
                                print("removing")
                                ref.child("users").child(uidi).child("Blocked/\(era)").removeValue()
                                
                                
                            }
                        }
                    }
                    
                })
                
            }
        }
    }
    
    
   
    func checkIfImBlocked () {
        let ref = Database.database().reference()
        if let sendToUserId = theirUid {
            if let myIDI = Auth.auth().currentUser?.uid {
                
                ref.child("users").child(sendToUserId).child("Blocked").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                    if let blockeders = snapshot.value as? [String : AnyObject] {
                        for (_, val) in blockeders {
                            if val as! String == myIDI {
                                self.messageButton.isHidden = true
                                print("your blocked")
                            }
                        }
                    }
                }, withCancel: nil)
            }
        }
    }
 
    
  
    
    func checkIfUserIsFriend() {
        let ref = Database.database().reference()
        if let theirId = theirUid {
        if let myUid = Auth.auth().currentUser?.uid {
        ref.child("users").child(myUid).child("friends").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            if let myFriends = snapshot.value as? [String: AnyObject] {
                for (_, veb) in myFriends {
                     self.Ifollows.append(veb as! String)
                    if veb as? String == theirId {
                       self.isAFriendCircleView.isHidden = false
                     self.isThisAFriend = true 
                    }
                }
            }
            if self.isThisAFriend != true {
                self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.requestToFriend)), animated: true)
            }
            
        }, withCancel: nil)
        }
        }
    }
    
    

    func checkIfUserIsBlocked() {
        if let theirId = theirUid {
        if let myId = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
                ref.child("users").child(myId).child("Blocked").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                    if let blockeders = snapshot.value as? [String : AnyObject] {
                        for (_, velt) in blockeders {
                            if velt as? String == theirId {
                                self.areTheyBlocked = true
                                self.unBlockButton.isHidden = false
                            }
                        }
                    }
                    
                    
                }, withCancel: nil)
        }
        }
    }
    var Ifollows = [String]()
    var checkForDuplicates = [String]()
    var followings = [String]()
    func pullTheirFriends () {
        let ref = Database.database().reference()
        if let theirId = theirUid {
            if let mYiD = Auth.auth().currentUser?.uid {
            ref.child("users").child(theirId).child("friends").queryOrderedByKey().observeSingleEvent(of: .value, with:  { snapshot in
                
                if let following = snapshot.value as? [String : AnyObject] {
                    for (_, value) in following {
                        print(value)
                        
                        self.followings.append(value as! String)
                        
                    }
                    
                    ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with:  { snap in
                        
                        if let userz = snap.value as? [String: AnyObject] {
                            
                            for (_,useri) in userz {
                                if let userID = useri["uid"] as? String {
                                    for each in self.followings {
                                        if each == userID {
                                            let newUser = usera()
                                            if let fullName = useri["Full Name"] as? String, let  userid = useri["uid"] as? String, let username = useri["Username"] as? String {
                                                newUser.name = fullName
                                                newUser.uid = userid
                                                newUser.username = username
                                                if self.checkForDuplicates.contains(userid) {
                                                    print("already in")
                                                }
                                                else {
                                                    if newUser.uid != mYiD {
                                                    self.friends.append(newUser)
                                                    self.checkForDuplicates.append(userid)
                                                    }
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                    })
                }
            })
            }
        }
    }
    
    func CheckIfThereIsAlreadyFriendReq () {
        if let myUid = Auth.auth().currentUser?.uid {
        if let uidToRequest = theirUid {
           let ref = Database.database().reference()
            ref.child("users").child(uidToRequest).child("Notifications").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let notificationsz = snapshot.value as? [String : AnyObject] {
                for (_, val) in notificationsz {
                    if let userRequest = val["friendRequest"] as? String {
                        // i dont like error meaages so I just print the userRequest, I know i could change it to _ , but im just weird
                        print("this is annoying \(userRequest)")
                        if let uidCurrentAsk = val["senderId"] as? String {
                            if uidCurrentAsk == myUid {
                                self.alreadyRequested = true
                                self.navigationItem.rightBarButtonItem?.isEnabled = false
                            }
                        }
                    }
                }
            }
        }, withCancel: nil)
        
        ref.child("users").child(myUid).child("Notifications").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapr) in
            if let notificationers = snapr.value as? [String : AnyObject] {
                for (_, val) in notificationers {
                    if let userRequest = val["friendRequest"] as? String {
                        // i dont like error meaages so I just print the userRequest, I know i could change it to _ , but im just weird
                        print("this is annoying \(userRequest)")
                        if let uidCurrentAsk = val["senderId"] as? String {
                            if uidCurrentAsk == uidToRequest {
                                self.alreadyRequested = true
                                     self.navigationItem.rightBarButtonItem?.isEnabled = false
                            }
                        }
                    }
                }
                
            }
            
        }, withCancel: nil)
            }
    }
    }
   
  
        var checkForDuplicateis = [String]()
        func pullBinders () {
            if let theirUid = theirUid {
            var reloadTableViewIfNewValue = false
            let ref = Database.database().reference()
            ref.child("Binders").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                if let binders = snapshot.value as? [String : AnyObject] {
                    
                    for (_, val) in binders {
                        if let useri = val["postUid"] as? String {
                            if useri == theirUid {
                                
                                let bindfl = Binder()
                                if let title = val["title"] as? String, let descript = val["description"] as? String,
                                    let sharers = val["sharers"] as? [String], let creatorUn = val["creatorUsername"] as? String, let setter = val["setter"] as? String, let creatorName = val["creatorName"] as? String, let kev = val["key"] as? String, let postUID = val["postUid"] as? String {
                                    bindfl.title = title
                                    bindfl.descriptions = descript
                                    bindfl.setter = setter
                                    bindfl.sharers = sharers
                                    bindfl.usernameOfBinder = creatorUn
                                    bindfl.creatorName = creatorName
                                    bindfl.key = kev
                                    bindfl.uidCreator = postUID
                                    
                                    if self.checkForDuplicateis.contains(bindfl.key) {
                                        print("binder already there")
                                    }
                                    else {
                                        self.binds.append(bindfl)
                                        self.checkForDuplicateis.append(bindfl.key)
                                        reloadTableViewIfNewValue = true
                                    }
                                }
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    if reloadTableViewIfNewValue == true {
                        self.tableViewBindersFriends.reloadData()
                        print("reloaded")
                    }
                }
                
            }, withCancel: nil)
        }
        }
    
    
    
    
    
    @objc func requestToFriend () {
        let friendRequest = "requesting to friend user"
        let ref = Database.database().reference()
        if let uib = Auth.auth().currentUser?.uid {
            
            
            if let userIdToRequest = theirUid {

                if let myUsername = username {
                
                    
                    let alert = UIAlertController(title: "Request to Friend", message: "Would you like to request to friend this user", preferredStyle: .alert)
                    let actionFriend = UIAlertAction(title: "Request", style: .default, handler: {( alert : UIAlertAction) -> Void in
            //check if it is ok to request
          
                if self.alreadyRequested != true {
                // now request friend
                let key = ref.child("users").child(userIdToRequest).child("Notifications").childByAutoId().key
                let creatorName = Auth.auth().currentUser?.displayName
                let timeStamp: Int = Int(NSDate().timeIntervalSince1970)

                let notif = ["friendRequest" : friendRequest, "senderId" : uib, "creatorName" : creatorName!, "creatorUsername" : myUsername, "timeStamp" : timeStamp, "key" : key, "notSeen" : "notSeen"] as [String : Any]

                let feidPost = ["\(key)" : notif]
                ref.child("users").child(userIdToRequest).child("Notifications").updateChildValues(feidPost)
                print("You Have Sent a request")
                    let messgae = "Friend request from \(creatorName!)"
                    let title = ""
                    
                    if let thierKey = self.theirKet {
                        OneSignal.postNotification(["headings": ["en": title], "contents": ["en": messgae], "include_player_ids": [thierKey]])
                    }

                 self.navigationItem.rightBarButtonItem?.isEnabled = false
                ref.removeAllObservers()
            }
            else {
                // if user has requested
                let alert2 = UIAlertController(title: "You have already requested to friend this user or they have sent you a friend request", message: "The user must respond to your last request before you send another, or accept their request", preferredStyle: .alert)
                let actionCanc = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                alert2.addAction(actionCanc)
                self.present(alert2, animated: true, completion: nil)

            }
        
                        })
                    alert.addAction(actionFriend)
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    

  
    
    
    
    
    
    
    @IBOutlet weak var selectedUserImageView: UIImageView!
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBAction func segmentAction(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 1 {
            
            tableViewBindersFriends.reloadData()
        } else {
            tableViewBindersFriends.reloadData()
        }
    }
    var should: Bool?
    
    // have you already sent a friend request that has not been answered?
    var canYouReq: Bool?
    var canUnblock: Bool?
    var blockers = [String]()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var thipKey: String?
        if segmentControl.selectedSegmentIndex == 1 {
           should = true
            // is this a friend - boolean
           
            
   
                    canYouReq = true
                    // is there a request - checking database and if so changing boolean canYouReq to false
                    let ref = Database.database().reference()
                    let uidToRequest = friends[indexPath.row].uid
                    if let uig = Auth.auth().currentUser?.uid {
                       
                       ref.child("users").child(uidToRequest!).child("userKey").observeSingleEvent(of: .value, with: { (checkshot) in
                        if checkshot.exists() {
                            thipKey = checkshot.value as? String
                        }
                       })
                        ref.child("users").child(uidToRequest!).child("Notifications").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
                            if let notificationsz = snapshot.value as? [String : AnyObject] {
                                for (_, val) in notificationsz {
                                    if let userRequest = val["friendRequest"] as? String {
                                        // i dont like error meaages so I just print the userRequest, I know i could change it to _ , but im just weird
                                        print("this is annoying \(userRequest)")
                                        if let uidCurrentAsk = val["senderId"] as? String {
                                            if uidCurrentAsk == uig {
                                                self.canYouReq = false
                                            }
                                        }
                                    }
                                }
                            }
                        }, withCancel: nil)
            
                        ref.child("users").child(uig).child("Notifications").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapr) in
                            if let notificationers = snapr.value as? [String : AnyObject] {
                                for (_, val) in notificationers {
                                    if let userRequest = val["friendRequest"] as? String {
                                        // i dont like error meaages so I just print the userRequest, I know i could change it to _ , but im just weird
                                        print("this is annoying \(userRequest)")
                                        if let uidCurrentAsk = val["senderId"] as? String {
                                            if uidCurrentAsk == uidToRequest {
                                                self.canYouReq = false
                                            }
                                        }
                                    }
                                }
            
                            }
            
                        }, withCancel: nil)
            
                    }
            
                            // alert when selecting user
                    var alert = UIAlertController()
                    alert = UIAlertController(title: friends[indexPath.row].username, message: friends[indexPath.row].name, preferredStyle: .alert)
                    // message the user
                    let message =  UIAlertAction(title: "Message", style: .default, handler: {( alert : UIAlertAction) -> Void in
                    let vcc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "messageToUserFromSearchUsers") as! SelectedUserMessageViewController
                        vcc.toUid = self.friends[indexPath.row].uid
                        vcc.toUsername = self.friends[indexPath.row].username
                        self.present(vcc, animated: true, completion: nil)
            
                    })
                    // cancel
                    let cancel = UIAlertAction(title: "Done", style: .cancel, handler: nil)
                    alert.addAction(message)
                    // friend the user
                    let friendThem = UIAlertAction(title: "Request to Friend", style: .default, handler: {( alert : UIAlertAction) -> Void in
            
            
                        if let usernme = self.username {
                        let friendRequest = "requesting to friend user"
                        if let uib = Auth.auth().currentUser?.uid {
                            if let userIdToRequest = self.friends[indexPath.row].uid {
            
            
                            //check if it is ok to request
                            if self.canYouReq == true {
                                // now request friend
                        let key = ref.child("users").child(userIdToRequest).child("Notifications").childByAutoId().key
                            let creatorName = Auth.auth().currentUser?.displayName
                            let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
            
                                let notif = ["friendRequest" : friendRequest, "senderId" : uib, "creatorName" : creatorName!, "creatorUsername" : usernme, "timeStamp" : timeStamp, "key" : key, "notSeen" : "notSeen"] as [String : Any]
            
                                       let feidPost = ["\(key)" : notif]
                        ref.child("users").child(userIdToRequest).child("Notifications").updateChildValues(feidPost)
                                self.Ifollows.append(userIdToRequest)
                                print("You Have Sent a request")
            
                                let messgae = "Friend request from \(creatorName!)"
                                let title = ""
                                
                                
                                if let thierKey = thipKey {
                                    OneSignal.postNotification(["headings": ["en": title], "contents": ["en": messgae], "include_player_ids": [thierKey]])
                                }
                                
                            }
                            else {
                                // if user has requested
                                let alert2 = UIAlertController(title: "You have already requested to friend this user or they have sent you a friend request", message: "The user must respond to your last request before you send another, or accept their request", preferredStyle: .alert)
                                let actionCanc = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                                alert2.addAction(actionCanc)
                                self.present(alert2, animated: true, completion: nil)
            
                            }
                        }
                            }
                        }
            
                    })
            
                    let unBlockUser = UIAlertAction(title: "Unblock User", style: .default, handler: {( alert : UIAlertAction) -> Void in
                        if let uidi = Auth.auth().currentUser?.uid {
                            if let theirID = self.friends[indexPath.row].uid {
                                ref.child("users").child(uidi).child("Blocked").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                            if let friendz = snapshot.value as? [String : String] {
                                for (era,ver) in friendz {
                                    if ver  == theirID {
                                        print("removing")
                                        ref.child("users").child(uidi).child("Blocked/\(era)").removeValue()
                                        self.blockers = self.blockers.filter{$0 != self.friends[indexPath.row].uid}
            
                                        self.canUnblock = false
                                    }
                                }
                            }
            
                        })
            
                        }
                        }
                    })
                    // if user selected is one of the currentUsers friends, dont add friend request function
                    if Ifollows.count != 0 {
                    for each in Ifollows {
                        if each == friends[indexPath.row].uid {
                            should = false
            
                        }
                        }
                    }
            
                    // already is a friend
                    if should == false {
                   print("nope")
                    }
                        // not a friend, so allow request
                    else {
                        alert.addAction(friendThem)
                    }
                    if blockers.count != 0 {
                        for each in blockers {
                            if each == friends[indexPath.row].uid {
                                canUnblock = true
                            }
                        }
                    }
            
            
                    if canUnblock == true {
            
                        alert.addAction(unBlockUser)
                    }
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
            
        } else {
            let indexPath = tableViewBindersFriends.indexPathForSelectedRow!
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectedSearchBinder") as! SelectedBinderSearchViewController
            vc.creatorUid = binds[indexPath.row].uidCreator
            vc.creatorun = binds[indexPath.row].usernameOfBinder
            vc.stringi = binds[indexPath.row].title
            vc.desct = binds[indexPath.row].descriptions
            vc.settler = binds[indexPath.row].setter
            vc.sharers = binds[indexPath.row].sharers
            vc.key = binds[indexPath.row].key
           
            
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
   
    
    @IBOutlet weak var isAFriendCircleView: UIView!
    
    @IBAction func messageButtonAction(_ sender: Any) {
         let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "messageToUserFromSearchUsers") as! SelectedUserMessageViewController
        if let theirUid = theirUid {
            if let theirUsernm = theirUsername {
            vc.toUid = theirUid
            vc.toUsername = theirUsernm
                self.present(vc, animated: true, completion: nil)
        }
        }
    }
    
    
    
  
    
    
    @IBOutlet weak var labelUsername: UILabel!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var tableViewBindersFriends: UITableView!
}
