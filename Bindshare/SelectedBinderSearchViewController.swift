//
//  SelectedBinderSearchViewController.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 6/28/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase
import OneSignal
// selected binder in search

class SelectedBinderSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    
    
    var theirKey: String?
    var keepFromSelectingRequestTwice: Bool?
    
    let usernameLabel = UILabel()
    let descriptionLabel = UILabel()
    @IBOutlet weak var binderTableView: UITableView!
    let barAdd = UIBarButtonItem()
    let publicorPrivateLabel = UILabel()
    
    var pages = [Page]()
    var desct: String?
    var settler: String?
    var creatorun: String?
    var key: String?
    var stringi: String?
    var sharers: [String]?
    var creatorUid: String? 
    var usernameString: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        keepFromSelectingRequestTwice = false
       checkIfAllowedToRequesr()
        self.navigationController?.navigationBar.tintColor = UIColor.white

        if let printKey = key {
            print(printKey)
        }
       pullname()
        pull()
        // title segue from search
        if let string = stringi {
            self.navigationItem.title = string 
        }
        // publicorprivate segue from search
        if let setter = settler {
            publicorPrivateLabel.text = setter
            if setter == "Private" {
        }
            if setter == "Public" {
                print("ok")
                if sharers?.count != 0 {
                    print("nepto")
                if sharers!.contains("Anyone") {
                    print("leejbf")
                self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.newPageFunc)), animated: true)
                    print("lol")
                }
                }
            }
        }
        descriptionLabel.backgroundColor = UIColor(white: 2, alpha: 3)
       
        usernameLabel.font = UIFont(name: "Times New Roman", size: 15)
        // segue from search - description
        if let discript = desct {
            descriptionLabel.text = discript
        }
        
        // creator username segue
        if let creatorune = creatorun {
            usernameLabel.text = creatorune
        }
        descriptionLabel.text = desct
        descriptionLabel.numberOfLines = 5
        descriptionLabel.font = UIFont(name: "Palatino", size: 12)
        publicorPrivateLabel.font = UIFont(name: "Didot", size: 12)
        usernameLabel.frame = CGRect(x: 4, y: 60, width: 154, height: 30)
        publicorPrivateLabel.frame = CGRect(x: self.view.frame.width - 50, y: 60, width: 40, height: 30)
        descriptionLabel.frame = CGRect(x: 4, y: 90, width: self.view.frame.width - 8, height: 80)
        binderTableView.frame = CGRect(x: 0, y: 170, width: self.view.frame.width, height: self.view.frame.height - 200)
        
        view.addSubview(usernameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(publicorPrivateLabel)
        binderTableView.delegate = self
        binderTableView.dataSource = self 
        // Do any additional setup after loading the view.
    }
    func pullname () {
        if Auth.auth().currentUser?.uid != nil {
            
            let ref = Database.database().reference()
            
            let uid = Auth.auth().currentUser?.uid
            ref.child("users").child(uid!).child("Username").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                self.usernameString = snapshot.value as? String
            })
        }
    }
    
    
    @objc func newPageFunc () {
        let alert = UIAlertController(title: "New Page", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter a title"
            textField.keyboardType = .asciiCapable
        }
        let createAction = UIAlertAction(title: "Create", style: .default, handler: { (action : UIAlertAction!) -> Void in
            
            if alert.textFields?[0].text != "" {
                if (alert.textFields?[0].text?.characters.count)! < 40 {
                    let ref = Database.database().reference()
                    let titler = alert.textFields?[0].text
                    
                    
                    if let bindKey = self.key {
                        let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                        print("ok")
                        let key = ref.child("Binders").child(bindKey).child("Page").childByAutoId().key
                        let page = ["title" : titler!, "poster" : Auth.auth().currentUser?.displayName as Any, "key" : key, "timeStamp" : timeStamp] as [String : Any]
                        
                        let setup = ["\(key)" : page]
                        ref.child("Binders").child(bindKey).child("Page").updateChildValues(setup)
                       
                        
                        
                    }
                    
                }
                if (alert.textFields?[0].text?.characters.count)! >= 40 {
                    let alert = UIAlertController(title: "Too many characters", message: "Your title has too many characters, please limit it to 49 characters or less", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            
            
        })
        alert.addAction(createAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {( alert : UIAlertAction) -> Void in
        })
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
        
    }

    var checkForDuples = [String]()
    var checkForDuplicates = [String]()
    var bolli: Bool?
    func pull () {
        if let setter = settler {
            if let kev = key {
   
                var reloadOrNo = false
                if let creatorId = creatorUid {
            if setter == "Public" {
                print("public")
                
                let ref = Database.database().reference()
                ref.child("Binders").child(kev).child("Page").queryOrderedByKey().observe(.value, with: { (snapshot) in
                    if let inBind = snapshot.value as? [String: AnyObject] {
                        for (_, one) in inBind {
                            let newp = Page()
                            if let titlie = one["title"] as? String, let poster = one["poster"] as? String, let itskey = one["key"] as? String {
                                newp.title = titlie
                                newp.creatorName = poster
                                newp.key = itskey
                                if self.checkForDuples.contains(newp.key) {
                                    print("already there")
                                } else {
                                self.pages.append(newp)
                                self.checkForDuples.append(newp.key)
                                reloadOrNo = true
                                }
                            }

                        }
                    }
                    if reloadOrNo == true {
                self.binderTableView.reloadData()
                    }
                })
                
            }
                if setter == "Private" {
                    let ref = Database.database().reference()

                    
                    ref.child("users").child(creatorId).child("userKey").observeSingleEvent(of: .value, with: { (snapshot) in
                        if snapshot.exists() {
                            self.theirKey = snapshot.value as? String
                        }
                    })
                    print("private")
                    if let myId = Auth.auth().currentUser?.uid {
                        print("\(creatorId) : \(myId)")
                        
                        
                        
                        if myId == creatorId {
                            self.bolli = true 
                            print("your the creator")
                            ref.child("Binders").child(kev).child("Page").queryOrderedByKey().observe(.value, with: { snap in
                                if let inBind = snap.value as? [String: AnyObject] {
                                    for (_, one) in inBind {
                                        let newp = Page()
                                        if let titlie = one["title"] as? String, let poster = one["poster"] as? String, let key = one["key"] as? String {
                                            newp.title = titlie
                                            newp.creatorName = poster
                                            newp.key = key
                                            if self.checkForDuplicates.contains(key) {
                                                print("search page already there/creator")
                                            }
                                            else {
                                            self.pages.append(newp)
                                                self.checkForDuplicates.append(key)
                                            }
                                        }
                                        
                                    }
                                }
                                self.binderTableView.reloadData()
                            })
                        }
                            ref.child("Binders").child(kev).child("sharers").observe(.value, with: { (snipy) in
                            
                                if let sharers = snipy.value as? [String] {
                                    for each in sharers {
                                        if each == myId {
                                            self.bolli = true
                                            ref.child("Binders").child(kev).child("Page").queryOrderedByKey().observe(.value, with: { snapit in
                                                if let inBind = snapit.value as? [String: AnyObject] {
                                                    for (_, one) in inBind {
                                                        let newp = Page()
                                                        if let titlie = one["title"] as? String, let poster = one["poster"] as? String, let key = one["key"] as? String {
                                                            newp.title = titlie
                                                            newp.creatorName = poster
                                                            newp.key = key
                                                            if self.checkForDuplicates.contains(key) {
                                                                print("search page already there/sharer")
                                                            }
                                                            else {
                                                                self.pages.append(newp)
                                                                self.checkForDuplicates.append(key)
                                                            }
                                                            
                                                        }
                                                        
                                                    }
                                                }
                                                self.binderTableView.reloadData()
                                            })
                                            

                                        }
                                       
                                    }
                                    // private, not creator and not a sharer
                                    
                                    if self.bolli != true, creatorId != Auth.auth().currentUser?.uid {
                                self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.actionFunc)), animated: true)
                                    }
                                }
                            })
                            
                            
                        }
                    
                    }
                    
                
            }
        }
        }
       
    }
    
    //** check if user is allowed to request to join binder
    var boll: Bool?
    func checkIfAllowedToRequesr() {
        boll = true
        let ref = Database.database().reference()
        if let myUid = Auth.auth().currentUser?.uid {
            if let theirUid = creatorUid {
                if let kev = key {
                    ref.child("users").child(theirUid).child("Notifications").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                        if let notificationz = snapshot.value as? [String : AnyObject] {
                            for (_, ech) in notificationz {
                                if let binderRequest = ech["RequestBinder"] as? String {
                                    print("\(binderRequest): error fix, does not mean sending request")
                                    if let binderKey = ech["binderKey"] as? String {
                                        if binderKey == kev {
                                            if let userRequesting = ech["senderId"] as? String {
                                                if userRequesting == myUid {
                                                    self.boll = false
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        
                    })
                }
            }
        }
    }
    
    
    @objc func actionFunc() {
        if keepFromSelectingRequestTwice == false {
            keepFromSelectingRequestTwice = true 
        let ref = Database.database().reference()
        let alert = UIAlertController(title: "Request to join Binder", message: "Click request to request to join this binder. The creator will recieve a notification", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        let sendNotification = UIAlertAction(title: "Request", style: .default, handler: {( alert : UIAlertAction) -> Void in
            if let uid = Auth.auth().currentUser?.uid {
                if let myUn = self.usernameString {
                    if let kev = self.key {
                    if let sendToId = self.creatorUid {
                        if let stringtitle = self.stringi {
                        
                        let requestBinder = "BinderRequest"
                        let keyt = ref.child("users").child(sendToId).child("Notifications").childByAutoId().key
                        let creatorName = Auth.auth().currentUser?.displayName
                        let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                        let binderName = stringtitle
                        if self.boll == true {
                            let notif = ["RequestBinder" : requestBinder, "senderId" : uid, "creatorName" : creatorName!, "creatorUsername" : myUn, "timeStamp" : timeStamp, "key" : keyt, "binderKey" : kev, "binderName" : binderName, "notSeen" : "notSeen"] as [String : Any]
                        
                        let feidPost = ["\(keyt)" : notif]
                        ref.child("users").child(sendToId).child("Notifications").updateChildValues(feidPost)
                        print("You Have Sent a request")
                            let messgae = "Binder request from \(creatorName!)"
                            let title = ""
                            if let thierKey = self.theirKey {
                                OneSignal.postNotification(["headings": ["en": title], "contents": ["en": messgae], "include_player_ids": [thierKey]])
                            }
                    }
                        else {
                            // if user has requested already
                            let alert2 = UIAlertController(title: "You have already requested to join this Binder", message: "The user must respond to your last request before you send another", preferredStyle: .alert)
                            let actionCanc = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                            alert2.addAction(actionCanc)
                            self.present(alert2, animated: true, completion: nil)
                            }
                        }
                        }
                        }
                    
                }
            }
            
        })
        alert.addAction(sendNotification)
        self.present(alert, animated: true, completion: nil)
        }
            }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = binderTableView.dequeueReusableCell(withIdentifier: "selectedSearchBinder", for: indexPath) as! SelectedSearchTableViewCell
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.cornerRadius = 6.0
        cell.layer.borderWidth = 1.0
        cell.clipsToBounds = true
        cell.labelMain.text = pages[indexPath.row].title
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        if let keyer = key {
            let refer = Database.database().reference().child("Binders").child(keyer).child("Page")
            let secondRef = Database.database().reference().child("Binders").child(keyer).child("sharers")
            secondRef.removeAllObservers()
            refer.removeAllObservers()
            print("memory warning")
        }
    }
    

    //seagueing to page viewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguePublicBinder" {
            let destVC = segue.destination as! PageViewController
            var indexPath = binderTableView.indexPathForSelectedRow!
            if sharers?.count != 0 {
                if sharers!.contains("Anyone") {
                         destVC.anyoneCanPost = "Anyone"
                }
            }
            destVC.string = pages[indexPath.row].title
            destVC.key = pages[indexPath.row].key
            destVC.isPublic = "itsPublic"
       
            if let keyp = key {
                destVC.binderKey = keyp
            }
        }
    }
    // remove observers
    override func viewWillDisappear(_ animated: Bool) {
        if let keyer = key {
        let refer = Database.database().reference().child("Binders").child(keyer).child("Page")
            let secondRef = Database.database().reference().child("Binders").child(keyer).child("sharers")
            secondRef.removeAllObservers()
            refer.removeAllObservers()
            print("selected search removed observers")
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        binderTableView.deselectRow(at: indexPath, animated: true)
    }

}
