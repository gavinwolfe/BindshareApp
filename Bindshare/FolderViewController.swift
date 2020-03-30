//
//  FolderViewController.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 6/26/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase
import OneSignal

// this class controls folder view 

class FolderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var friendsLabel: UILabel!
    @IBOutlet weak var labelBinderCount: UILabel!
   
    @IBOutlet weak var bindersLabel: UILabel!
    @IBOutlet weak var addProfilePhotoButoon: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var labelFriendCount: UILabel!
    
    @IBOutlet weak var numberOfFriendsButton: UIButton!
    var essentialsArray = ["Messages", "Friends", "Manage Binders", "Password", "Terms of Service" , "Privacy", "Sign Out"]

    let session = URLSession.shared
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func buttonSeeFriends(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "friends")
        self.present(vc, animated: true, completion: nil)
    }
    @IBOutlet weak var numberOfBinders: UIButton!
    var firAuthUser: String?
    override func viewWillAppear(_ animated: Bool) {
       
        if let firUser = firAuthUser {
            if Auth.auth().currentUser?.uid != firUser {
                if Auth.auth().currentUser?.uid != nil {
                    if Auth.auth().currentUser?.displayName != nil {
                        binderCount.removeAll()
                        pullname()
                        grabProfilePhoto()
                        pullBinderCount()
                        followings.removeAll()
                        pull()
                        firAuthUser = Auth.auth().currentUser?.uid
                    }
                }

            }
        }
    }
    
    func grabProfilePhoto () {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("profileImageUrl").observeSingleEvent(of: .value, with: { (snapshot) in
                if let imageUrl = snapshot.value as? String {
                    let url = URL(string: imageUrl)
                    self.session.dataTask(with: url!, completionHandler: { (data, response, error) in
                        if let errle = error {
                            print(errle.localizedDescription)
                        }
                        if data != nil {
                            DispatchQueue.main.async {
                                self.profileImageView.image = UIImage(data: data!)
                                print("loaded")
                            }
                        }
                        
                    }).resume()
                }
                
            })
        }
        session.finishTasksAndInvalidate()
    }
  
    @IBAction func choseProfilePhotoAction(_ sender: Any) {
        if let myUid = Auth.auth().currentUser?.uid {
            print(myUid)
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let pageAlert = UIAlertController(title: "Add Image", message: "Chose a way to add an image", preferredStyle: UIAlertControllerStyle.actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { (action : UIAlertAction!) -> Void in
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
            
        })
        let library = UIAlertAction(title: "Library", style: .default, handler: { (action : UIAlertAction!) -> Void in
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
            
        })
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        pageAlert.addAction(camera)
        pageAlert.addAction(library)
        pageAlert.addAction(cancel)
        self.present(pageAlert, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImageView.image = selectedImage
        if let imager = profileImageView.image {
        let ref = Database.database().reference()
            
        if let uid = Auth.auth().currentUser?.uid {
            ref.child("users").child(uid).child("profileImageUrl").observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    ref.child("users").child(uid).child("profileImageUrl").removeValue()
                }
                
            })
            let key = ref.child("users").child(uid).child("profileImageUrl").key
             let storage = Storage.storage().reference(forURL: "gs://bindshare-a7805.appspot.com")
           let imageRef = storage.child("ProfileImageUrl").child(uid).child("\(key).jpg)")
             let data = UIImageJPEGRepresentation(imager, 0.6)
            
         let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
            if error != nil {
                print("error")
            }
            if let metadata = metadata {
                print(metadata)
                 imageRef.downloadURL(completion: { (url, error) in
                if let url = url {
                    let feed = ["profileImageUrl" : url.absoluteString] as [String : Any]
                    
                    
                    ref.child("users").child(uid).updateChildValues(feed)
                }
            })
           
            }
            
            }
             uploadTask.resume()
        
        self.dismiss(animated: true, completion: nil)
        }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    var theirIdz: String?
    var aboolio: Bool?
    var canYouReq: Bool?
    @IBAction func quickAddButtonAction(_ sender: Any) {
        self.aboolio = false
        if let usernameI = usernme {
        let secondAlert = UIAlertController(title: "Quick Add", message: "Enter a username you would like to send a friend request to", preferredStyle: .alert)
        secondAlert.addTextField { (textField : UITextField!) -> Void in
            
            let send = UIAlertAction(title: "Send", style: .default, handler: { (alert : UIAlertAction) -> Void in
                if secondAlert.textFields?[0].text != "" {
                    if let uid = Auth.auth().currentUser?.uid {
                        let ref = Database.database().reference()
                        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                            if let useris = snapshot.value as? [String: AnyObject] {
                                let usernam1 = secondAlert.textFields?[0].text?.lowercased()
                                for (_,value) in useris {
                                    if let usernamees = value["Username"] as? String {
                                        if usernamees.lowercased() == usernam1! {
                                            self.aboolio = true
                                            if let uidd = value["uid"] as? String {
                                                self.theirIdz = uidd
                                                print("woad")
                                            }
                                        }
                                    }
                                }
                            }
                        
                        if self.aboolio == true {
                            print("woaderrr")
                            if let theirId = self.theirIdz {
                           
                            ref.child("users").child(theirId).child("Notifications").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                                
                                if let notificationsz = snapshot.value as? [String : AnyObject] {
                                    for (_, val) in notificationsz {
                                        if let userRequest = val["friendRequest"] as? String {
                                            
                                            print("this is annoying \(userRequest)")
                                            if let uidCurrentAsk = val["senderId"] as? String {
                                                if uidCurrentAsk == uid {
                                                    self.canYouReq = false
                                                }
                                            }
                                        }
                                    }
                                }
                                ref.child("users").child(uid).child("Notifications").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapr) in
                                    if let notificationers = snapr.value as? [String : AnyObject] {
                                        for (_, val) in notificationers {
                                            if let userRequesti = val["friendRequest"] as? String {
                                                
                                                print("this is annoying \(userRequesti)")
                                                if let uidCurrentAsker = val["senderId"] as? String {
                                                    if uidCurrentAsker == theirId {
                                                        self.canYouReq = false
                                                    }
                                                }
                                            }
                                        }
                                        
                                    }
                                    if self.canYouReq != false {
                                        if theirId == uid {
                                            print("your id")
                                        } else {
                                            if self.followings.contains(theirId) {
                                                print("loser")
                                            } else {
                                                
                                                let key = ref.child("users").child(theirId).child("Notifications").childByAutoId().key
                                                let creatorName = Auth.auth().currentUser?.displayName
                                                let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                                                let friendRequest = "friendRequest"
                                                
                                                let notif = ["friendRequest" : friendRequest, "senderId" : uid, "creatorName" : creatorName!, "creatorUsername" : usernameI, "timeStamp" : timeStamp, "key" : key, "notSeen" : "notSeen"] as [String : Any]
                                                
                                                let feidPost = ["\(key)" : notif]
                                                ref.child("users").child(theirId).child("Notifications").updateChildValues(feidPost)
                                                print("You Have Sent a request")
                                                ref.child("users").child(theirId).child("userKey").observeSingleEvent(of: .value, with: { (snilly) in
                                                    if snilly.exists() {
                                                
                                                        print("user has key")
                                                        let myName = Auth.auth().currentUser?.displayName
                                                        let messgae = "Friend request from \(myName!)"
                                                        let title = ""
                                                        
                                                        let userKey = snilly.value as! String
                                                           OneSignal.postNotification(["headings": ["en": title], "contents": ["en": messgae], "include_player_ids": [userKey]])
                                                    }
                                                })
                                                ref.removeAllObservers()
                                            }
                                        }
                                        
                                    }
                                    else {
                                        // if user has requested
                                        let alert2 = UIAlertController(title: "You have already requested to friend this user or they have sent you a friend request", message: "The user must respond to your last request before you send another, or accept their request", preferredStyle: .alert)
                                        let actionCanc = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                                        alert2.addAction(actionCanc)
                                        self.present(alert2, animated: true, completion: nil)
                                        
                                    }
                                    
                                }, withCancel: nil)
                            }, withCancel: nil)
                            
                            
                               
                            }
                                
                            
                        } else {
                            let alertio = UIAlertController(title: "Invalid Username", message: "The username you have entered does not exist, please make sure the spelling is correct or search the user", preferredStyle: .alert)
                            let actionCanc = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                            alertio.addAction(actionCanc)
                            self.present(alertio, animated: true, completion: nil)
                            }
                    
                    })
                }
                }
            
            
                })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            secondAlert.addAction(send)
            secondAlert.addAction(cancel)
        }
            self.present(secondAlert, animated: true, completion: nil)
    }
        }
    
    
    var binderCount = [Binder]()
    func pullBinderCount () {
    let ref = Database.database().reference()
        ref.child("Binders").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            if let binders = snapshot.value as? [String : AnyObject] {
                
                for (_, val) in binders {
                    if let useri = val["postUid"] as? String {
                        if useri == Auth.auth().currentUser?.uid {
                            if let tlitler = val["title"] as? String {
                            let aBind = Binder()
                                aBind.title = tlitler
                            self.binderCount.append(aBind)
                            }
                        }
                    }
                }
            }
        })
       
        let uid = Auth.auth().currentUser?.uid
        ref.child("Binders").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            if let binder = snapshot.value as? [String : AnyObject] {
                for (_, vale) in binder {
                    if let sharlers = vale["sharers"] as? [String] {
                        for each in sharlers {
                            if each == uid {
                                let newpie = Binder()
                                if let titlerr = vale["title"] as? String {
                                    newpie.title = titlerr
                                    self.binderCount.append(newpie)
                                    
                                }
                            }
                        }
                    }
                }
            }
            self.labelBinderCount.text = "\(self.binderCount.count)"
        })
    }
    
    
    
 
    var followings = [String]()
    func pull () {
        let ref = Database.database().reference()
        let uidi = Auth.auth().currentUser?.uid
        if let uid = uidi {
            ref.child("users").child(uid).child("friends").queryOrderedByKey().observeSingleEvent(of: .value, with:  { snapshot in
                
                if let following = snapshot.value as? [String : AnyObject] {
                    for (_, value) in following {
                        print(value)
                        
                        self.followings.append(value as! String)
                        
                        
                    }
                    
                     self.labelFriendCount.text = "\(following.count)"
                  
                }
                
            })
            
        }
        ref.removeAllObservers()
    }
   
    @IBOutlet weak var organizeTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

         self.tabBarController?.tabBar.items?[0].badgeValue = nil
        checkIfThereIsUnseen()
        grabProfilePhoto()
        profileImageView.layer.cornerRadius = 25.0
        profileImageView.clipsToBounds = true
       pullBinderCount()
        
        pull()
        if Auth.auth().currentUser?.uid != nil {
            if Auth.auth().currentUser?.displayName != nil {
                pullname()
               
               nameLabel.text = Auth.auth().currentUser?.displayName
                firAuthUser = Auth.auth().currentUser?.uid
            }
        }
        
        
        
        
        organizeTableView.frame = CGRect(x: 0, y: self.view.frame.height / 3, width: self.view.frame.width, height: self.view.frame.height / 1.68)
        
        labelFriendCount.frame = CGRect(x: self.view.frame.width - 95, y: 100, width: 50, height: 50)
        friendsLabel.frame = CGRect(x: self.view.frame.width - 100, y: 90, width: 60, height: 20)
        labelBinderCount.frame = CGRect(x: 40, y: 100, width: 50, height: 50)
        bindersLabel.frame = CGRect(x: 35, y: 90, width: 60, height: 20)
        profileImageView.frame = CGRect(x: self.view.frame.width / 2.55, y: 80, width: self.view.frame.width / 4.6, height: 55)
        addProfilePhotoButoon.frame = profileImageView.frame
        
        nameLabel.frame = CGRect(x: 50, y: self.view.frame.height / 4, width: self.view.frame.width - 100, height: 20)
        usernameLabel.frame = CGRect(x: 50, y: self.view.frame.height / 3.5, width: self.view.frame.width - 100, height: 20)
        changeNameButton.frame = nameLabel.frame
        numberOfFriendsButton.frame = CGRect(x: self.view.frame.width - 95, y: 100, width: 80, height: 80)
        organizeTableView.separatorColor = .clear
        organizeTableView.delegate = self
        organizeTableView.dataSource = self
        
        if view.frame.height == 812 {
            profileImageView.frame = CGRect(x: self.view.frame.width / 2.55, y: 80 + 50, width: self.view.frame.width / 4.6, height: 55)
        }
        navigationItem.title = "Organize"
        self.navigationController?.navigationBar.tintColor = .white
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var usernme: String?
    func pullname () {
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        if let uid = uid {
        ref.child("users").child(uid).child("Username").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
            
            self.usernme = snapshot.value as? String
                self.usernameLabel.text = snapshot.value as? String
            self.organizeTableView.reloadData()
            }
        })
        }
    }
   
    func checkIfThereIsUnseen () {
        let ref = Database.database().reference()
        if let myuid = Auth.auth().currentUser?.uid {
            ref.child("users").child(myuid).child("Notifications").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let notifications = snapshot.value as? [String : AnyObject] {
                    for (_, veel) in notifications {
                        if let unseen = veel["notSeen"] as? String {
                            print(unseen)
                            let indexer = IndexPath(row: 0, section: 0)
                            let cell = self.organizeTableView.cellForRow(at: indexer) as! FolderTableViewCell
                      cell.miniView.backgroundColor = .blue
                            cell.miniView.layer.cornerRadius = 6.0
                            cell.miniView.clipsToBounds = true 
                            
                        }
                    }
                }
            }, withCancel: nil)
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        
        if indexPath.row == 1 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "friends")
            self.present(vc, animated: true, completion: nil)
        }
        
        if indexPath.row == 3 {
            let alert = UIAlertController(title: "Change Password", message: "Would you like to change your password?", preferredStyle: .alert)
            let action = UIAlertAction(title: "Change Password", style: .default, handler: {( alert : UIAlertAction) -> Void in
                let alert2 = UIAlertController(title: "Change Password", message: "Are you sure you want to change your password?", preferredStyle: .alert)
                let anotherAction = UIAlertAction(title: "Change Password", style: .default, handler: {( alert : UIAlertAction) -> Void in
                    if let currentUserEmail = Auth.auth().currentUser?.email {
                        Auth.auth().sendPasswordReset(withEmail: currentUserEmail, completion: { (error) in
                            if error == nil {
                                let alert3 = UIAlertController(title: "Email sent to \(currentUserEmail)", message: "Please check your email, an email containing information on how to change your password has been sent to the entered email", preferredStyle: .alert)
                                let oky = UIAlertAction(title: "Okay", style: .cancel, handler: { (action : UIAlertAction!) -> Void in
                                    self.dismiss(animated: true, completion: nil)
                                })
                               
                                alert3.addAction(oky)
                                self.present(alert3, animated: true, completion: nil)
                            }
                            else {
                                let alertCo = UIAlertController(title: "Error", message: "Sorry there was an error, please try again later", preferredStyle: .alert)
                                let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                                alertCo.addAction(okay)
                                self.present(alertCo, animated: true, completion: nil)
                            }
                        })
                        
                    }

                    
                    
                })
                   let cancelAct = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert2.addAction(anotherAction)
                alert2.addAction(cancelAct)
                self.present(alert2, animated: true, completion: nil)
                    
                })
        
            let cancelOut = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelOut)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
        if indexPath.row == 0 {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "notifys")
        
            self.present(vc, animated: true, completion: nil)
        }
        if indexPath.row == 2 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "manageBinders")
            self.present(vc, animated: true, completion: nil)

        }
        if indexPath.row == 5 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "privacyPolicy") as! PrivacyPolicyViewController
            self.present(vc, animated: true, completion: nil)
        }
        if indexPath.row == 4 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "termsOfService") as! TermsOfServiceViewController
            self.present(vc, animated: true, completion: nil)
        }
        if indexPath.row == 6 {
            var alert = UIAlertController()
            alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let logoutAction = UIAlertAction(title: "Sign Out", style: .default, handler: {( alert : UIAlertAction) -> Void in
                self.signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginOrSignUp")
                self.present(vc, animated: true, completion: nil)
                
            })

            alert.addAction(cancel)
            alert.addAction(logoutAction)
            self.present(alert, animated: true, completion: nil)
        
            
        }
        
        organizeTableView.deselectRow(at: indexPath, animated: true)
    }

    func signOut () {
        if Auth.auth().currentUser?.uid != nil {
        do {
           try! Auth.auth().signOut()
            print("logged out")
        }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return essentialsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = organizeTableView.dequeueReusableCell(withIdentifier: "cellOrganize", for: indexPath) as! FolderTableViewCell
        cell.mainLabel.text = essentialsArray[indexPath.row]
    
        cell.miniView.frame = CGRect(x: 6, y: 28, width: 8, height: 8)
        cell.mainLabel.frame = CGRect(x: 20, y: 20, width: self.view.frame.width - 50, height: 25)
        cell.arrowImageView.frame = CGRect(x: self.view.frame.width - 50, y: 20, width: 40, height: 25)
        
        if indexPath.row != 0 {
            cell.miniView.backgroundColor = .clear
        }
       
        
        return cell 
    }
    
    @IBOutlet weak var changeNameButton: UIButton!
    
    @IBAction func changeNameAction(_ sender: Any) {
        let ref = Database.database().reference()
        if let currentUser = Auth.auth().currentUser?.uid {
            let alerti = UIAlertController(title: "Change Name", message: "Would you like to change your name?", preferredStyle: .alert)
             alerti.addTextField { (textField : UITextField!) -> Void in
                alerti.textFields?[0].placeholder = "Enter a new name"
               alerti.textFields?[0].keyboardType = .asciiCapable
            }
            let action = UIAlertAction(title: "Save", style: .default, handler:  { (alert : UIAlertAction) -> Void in
                
                if let text = alerti.textFields?[0].text {
                    if text != "", text.characters.count > 2 {
                    let string = alerti.textFields![0].text!.lowercased()
                    if  string.contains(";") || string.contains(")") || string.contains("$") || string.contains("&") || string.contains("@") || string.contains("(") || string.contains("shit") || string.contains("fuck") || string.contains("suck") || string.contains("ass")  || string.contains("dick") || string.contains("cock") || string.contains("penis") || string.contains("lick") || string.contains("vagina") || string.contains("pussy") || string.contains("fag") || string.contains("tit") || string.contains("boob") || string.contains("hole") || string.contains("butt") || string.contains("anal") || string.contains("milf") || string.contains("cunt") || string.contains("/") || string.contains("hate") || string.contains("\\") || string.contains("\"") || string.contains(".") || string.contains(",") || string.contains("?") || string.contains("!") || string.contains("[") || string.contains("]") || string.contains("{") || string.contains("}") || string.contains("#") || string.contains("%") || string.contains("^") || string.contains("*") || string.contains("+") || string.contains("=") || string.contains("|") || string.contains("<") || string.contains(">") || string.contains("£") || string.contains("€") || string.contains("¥") || string.contains("•") || string.contains("porn") || string.contains("sex") || string.contains("nigger") || string.contains("beaner") || string.contains("coon") || string.contains("spic") || string.contains("wetback") || string.contains("chink") || string.contains("gook") || string.contains("porn") || string.contains("twat") || string.contains("crow")  || string.contains("darkie")  || string.contains("bitch") || string.contains("god hates") || string.contains("  ") || string.contains("klux") || string.contains("kkk") || string.contains("nigga") {
                    } else {
                        let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                    
                    
                    changeRequest.displayName = text
                    changeRequest.commitChanges(completion: nil)
                    
                    ref.child("users").child(currentUser).child("Full Name").removeValue()
                       let newTitle = ["Full Name" : text]
                        ref.child("users").child(currentUser).updateChildValues(newTitle)
                     self.nameLabel.text = text
                }
                    }
                }
                
            })
                 alerti.addAction(action)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alerti.addAction(cancel)
            self.present(alerti, animated: true, completion: nil)
            
            
            
        }
    }
    
}
