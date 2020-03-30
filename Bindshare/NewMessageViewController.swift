//
//  NewMessageViewController.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 7/10/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase
import OneSignal

class NewMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate {

    var usersForNotifications = [usera]()
    
    @IBOutlet weak var orChoseFriendsLbl: UILabel!
    var theirKey: String?
    
    let activityIndcc = UIActivityIndicatorView()
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var newMessageLbl: UILabel!
    @IBOutlet weak var enterMessageLbl: UILabel!
    @IBOutlet weak var textViewMessage: UITextView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var imageViewPhoto: UIImageView!
    var username: String?
    var friends = [User]()
    var solars = [String]()
    var sharers = [usera]()
    let lael = UILabel()
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tableViewSelect: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white

        backBtn.frame = CGRect(x: 10, y: 10, width: 45, height: 45)
        newMessageLbl.frame = CGRect(x: self.view.frame.width / 3, y: 15, width: 120, height: 30)
        segmentControl.frame = CGRect(x: 80, y: 50, width: self.view.frame.width - 160, height: 30)
        enterMessageLbl.frame = CGRect(x: 15, y: self.view.frame.height / 6, width: 120, height: 20)
        imageViewPhoto.frame = CGRect(x: 50, y: 88, width: self.view.frame.width - 100, height: self.view.frame.height / 3.6)
        choseAphoto.frame = imageViewPhoto.frame
        textViewMessage.frame = CGRect(x: 15, y: self.view.frame.height / 5, width: self.view.frame.width - 30, height: self.view.frame.height / 5)
        textFieldUsername.frame = CGRect(x: 15, y: self.view.frame.height / 2.25, width: self.view.frame.width - 30, height: 30)
        orChoseFriendsLbl.frame = CGRect(x: 15, y: self.view.frame.height / 1.9, width: self.view.frame.width - 30, height: 25)
        tableViewSelect.frame = CGRect(x: 15, y: self.view.frame.height / 1.75, width: self.view.frame.width - 30, height: self.view.frame.height / 3.5)
        sendButton.frame = CGRect(x: 15, y: self.view.frame.height - 55, width: self.view.frame.width - 30, height: 45)
        
        
        
        sendButton.layer.cornerRadius = 24
        sendButton.clipsToBounds = true 
        pullFollowing()
        imageViewPhoto.isHidden = true
        choseAphoto.isHidden = true 
        let myColor = UIColor.gray
        self.textFieldUsername.layer.borderColor = myColor.cgColor
        self.textFieldUsername.layer.borderWidth = 1.0
        
        lael.text = "Sending Image"
        lael.textColor = .black
        lael.frame = CGRect(x: self.view.frame.width / 3, y: 200, width: 150, height: 30)
        activityIndcc.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        activityIndcc.color = .black
        activityIndcc.addSubview(lael)
        sendButton.layer.cornerRadius = 24
        activityIndcc.backgroundColor = UIColor(white: 1, alpha: 0.8)
        tableViewSelect.delegate = self
        tableViewSelect.dataSource = self
        // Do any additional setup after loading the view.
    }
    var followings = [String]()
    func pullFollowing () {
        let ref = Database.database().reference()
        let uidi = Auth.auth().currentUser?.uid
        if let uid = uidi {
            ref.child("users").child(uid).child("friends").queryOrderedByKey().observeSingleEvent(of: .value, with:  { snapshot in
                
               
                if let following = snapshot.value as? [String : AnyObject] {
                    for (_, value) in following {
                        print(value)
                        self.followings.append(value as! String)
                    }
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
                                            
                                                if let theirKey = useri["userKey"] as? String {
                                                    newUser.tokenKey = theirKey
                                                }
                                                
                                                self.sharers.append(newUser)
                                            }
                                            
                                        }
                                    }
                                    
                                    self.tableViewSelect.reloadData()
                                }
                            }
                        }
                        
                    })
                
                
                
            })
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
        return sharers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewSelect.dequeueReusableCell(withIdentifier: "selectorNewCell", for: indexPath) as! SelectFriendsForNewMessageTableViewCell
        cell.labelName.text = sharers[indexPath.row].name
        return cell 
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.imageViewPhoto.image = nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        solars.append(sharers[indexPath.row].uid)
        usersForNotifications.append(sharers[indexPath.row])
        print(solars)
        print(usersForNotifications)
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        solars = solars.filter{$0 != sharers[indexPath.row].uid}
        usersForNotifications = usersForNotifications.filter{$0 != sharers[indexPath.row]}
        print(solars)
     print(usersForNotifications)
    }

    @IBAction func backDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        if textViewMessage.isFirstResponder == true {
        textViewMessage.resignFirstResponder()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBOutlet weak var choseAphoto: UIButton!
  
    var selectedImage: UIImage?
    var pageAlert = UIAlertController()
    @IBAction func functionChosePhoto(_ sender: Any) {
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

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        textViewMessage.text = ""
        selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageViewPhoto.image = selectedImage
        selectedImage?.accessibilityIdentifier = "selectedImage"
        
        self.dismiss(animated: true, completion: nil)
        choseAphoto.titleLabel?.isHidden = true 

    }
      var array = [String]()
    func textFieldDidBeginEditing(_ textField: UITextField) {
        array.removeAll()
    }
    var abOool: Bool?
    var uidz: String?
 var boolIs = Bool()
    func textFieldDidEndEditing(_ textField: UITextField) {
        abOool = false
        if let usernm = username {
        if textFieldUsername.text == usernm {
            textFieldUsername.text = "" 
        }
        }
        if textFieldUsername.text != "" {
            sharers.removeAll()
            solars.removeAll()
            followings.removeAll()
            tableViewSelect.reloadData()
            let ref = Database.database().reference()
            ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                if let useris = snapshot.value as? [String: AnyObject] {
                    let usernam1 = self.textFieldUsername.text?.lowercased()
                    for (_,value) in useris {
                        
                        if let usernamees = value["Username"] as? String {
                           
                            if usernamees.lowercased() == usernam1! {
                                //seperate from checking if username exists
                                if let blockers = value["Blocked"] as? [String : String] {
                                    print("ok blockers")
                                    for (_, lid) in blockers {
                                        
                                        if let myIdzl = Auth.auth().currentUser?.uid {
                                            if lid.lowercased() == myIdzl {
                                                self.abOool = true
                                                print("blocked")
                                            }
                                        }
                                    }
                                }
                                
                                print("adding")
                                let uip = "lipy"
                                self.array.append(uip)
                                if let uidd = value["uid"] as? String {
                                    self.uidz = uidd
                                }
                            
                                if let theriKey = value["userKey"] as? String {
                                    self.theirKey = theriKey
                                }
                            }
                           
                        }
                    }
                }
                if self.array.count == 1 {
                    let myColor = UIColor.green
                self.textFieldUsername.layer.borderColor = myColor.cgColor
                    self.textFieldUsername.layer.borderWidth = 1.0
                    self.boolIs = true
                }
                else {
                    var alert = UIAlertController()
                                alert = UIAlertController(title: "No username found", message: "The username you have entered does not exist", preferredStyle: .alert)
                                let cancel = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                                alert.addAction(cancel)
                                self.present(alert, animated: true, completion: nil)
                    let myColor = UIColor.gray
                    self.textFieldUsername.layer.borderColor = myColor.cgColor
                    self.textFieldUsername.layer.borderWidth = 1.0
                    self.textFieldUsername.text = ""
                    self.boolIs = false
                }
            })
            
            
        }
    

       

        if textFieldUsername.text == "", sharers.count == 0 {
            pullFollowing()
            
        }
    }
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func segmentAction(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 1 {
            choseAphoto.isHidden = false
            imageViewPhoto.isHidden = false
            textViewMessage.isHidden = true
            enterMessageLbl.isHidden = true
            
        }
        else {
            choseAphoto.isHidden = true
            imageViewPhoto.isHidden = true
            textViewMessage.isHidden = false
            enterMessageLbl.isHidden = false

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
    
    @IBAction func sendAction(_ sender: Any) {
        if abOool != true {
        if textViewMessage.text == "", imageViewPhoto.image == nil, textFieldUsername.text != "", solars.count != 0 {
            
            let aleerrt = UIAlertController(title: "Enter message or Image", message: "There is no image or message entered, please enter a message or add a photo", preferredStyle: .alert)
            let acttionn = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            aleerrt.addAction(acttionn)
            self.present(aleerrt, animated: true, completion: nil)
            sendButton.isHidden = false
        }
        if textFieldUsername.text == "", solars.count == 0, textViewMessage.text != "", imageViewPhoto.image != nil {
            let aleerrt = UIAlertController(title: "No reciever entered or selected", message: "You have not selected or entered a user to send your message to", preferredStyle: .alert)
            let acttionn = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            aleerrt.addAction(acttionn)
            self.present(aleerrt, animated: true, completion: nil)

            sendButton.isHidden = false
        }
        if textFieldUsername.text == "", solars.count == 0, textViewMessage.text == "", imageViewPhoto.image == nil {
            let aleerrt = UIAlertController(title: "Empty Message", message: "You have not typed a message or selected/entered a user", preferredStyle: .alert)
            let acttionn = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            aleerrt.addAction(acttionn)
            self.present(aleerrt, animated: true, completion: nil)
            sendButton.isHidden = false
        }
        if textFieldUsername.text != "", textViewMessage.text == "", imageViewPhoto.image == nil {
            let aleerrt = UIAlertController(title: "Empty Message", message: "You have not typed a message or selected a photo", preferredStyle: .alert)
            let acttionn = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            aleerrt.addAction(acttionn)
            self.present(aleerrt, animated: true, completion: nil)
            sendButton.isHidden = false

        }
        
                 if let usernm = username {
                    print("kek")
                    let array = solars
                    let storage = Storage.storage().reference(forURL: "gs://bindshare-a7805.appspot.com")
                    let ref = Database.database().reference()
                    if let uid = Auth.auth().currentUser?.uid {
                        let creatorName = Auth.auth().currentUser?.displayName
                        let creatorUn = usernm
                        let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                        let senderUid = uid
                if segmentControl.selectedSegmentIndex == 1 {
                    let imageImage = imageViewPhoto.image
                    if let imager = imageImage {
                                            if textFieldUsername.text == "", solars.count != 0 {
                                                view.addSubview(activityIndcc)
                                                activityIndcc.startAnimating()

                            for each in array {
                                let key =
                                    ref.child("users").child(each).child("Notifications").childByAutoId().key
                                let imageRef = storage.child("Messages").child(uid).child("\(key).jpg)")
                                let data = UIImageJPEGRepresentation(imager, 0.6)
                                let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
                                if let errr = error {
                                    let alert = UIAlertController(title: "There was a problem", message: "We have our best chimps working to solve your problem", preferredStyle: .alert)
                                    let action = UIAlertAction(title: "Alright", style: .cancel, handler: nil)
                                    alert.addAction(action)
                                    self.present(alert, animated: true, completion: nil)
                                    print(errr)
                                    }
                                else {
                                    imageRef.downloadURL(completion: { (url, errir) in
                                        if let errrrrrrrr = errir {
                                            print(errrrrrrrr.localizedDescription)
                                        }
                                        if let url = url {
                                            let notif = ["ImageUrl" : url.absoluteString, "senderId" : senderUid, "creatorName" : creatorName!, "creatorUsername" : creatorUn, "timeStamp" : timeStamp, "key" : key, "notSeen" : "notSeen"] as [String : Any]
                                            
                                             let postFeed = ["\(key)" : notif]
                                            ref.child("users").child(each).child("Notifications").updateChildValues(postFeed)
                                        }
                                        
                                        self.activityIndcc.stopAnimating()
                                    self.dismiss(animated: true, completion: nil)
                                    
                                    })
                                    }
                                    
                                }
                                uploadTask.resume()
                            }
                                                // send messages to selected users with notification keys
                                                if self.usersForNotifications.count != 0 {
                                                    for each in self.usersForNotifications {
                                                        if each.tokenKey != nil {
                                                            let myName = Auth.auth().currentUser?.displayName
                                                            let messgae = "New message from \(myName!)"
                                                            let title = ""
                                                            
                                                            let userKey = each.tokenKey
                                                            OneSignal.postNotification(["headings": ["en": title], "contents": ["en": messgae], "include_player_ids": [userKey]])
                                                            print("sent message")
                                                        }
                                                    }
                                                }
                                                
                            }
                            if textFieldUsername.text != "", array.count == 0, boolIs == true {
                                if let u2d = uidz {
                                    view.addSubview(activityIndcc)
                                    activityIndcc.startAnimating()

                               // let usernameSend = self.textFieldUsername.text
                                let key = ref.child("users").child(u2d).child("Notifications").childByAutoId().key
                                 let imageRef = storage.child("Messages").child(uid).child("\(key).jpg)")
                                let data = UIImageJPEGRepresentation(imager, 0.6)
                                  let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
                                    if let errler = error {
                                        let alert = UIAlertController(title: "There was a problem", message: "We have our best chimps working to solve your problem", preferredStyle: .alert)
                                        let action = UIAlertAction(title: "Alright", style: .cancel, handler: nil)
                                        alert.addAction(action)
                                        self.present(alert, animated: true, completion: nil)
                                        print(errler)
                                    }
                                    else {
                                        imageRef.downloadURL(completion: { (url, errir) in
                                            if let erlli = errir {
                                                print(erlli.localizedDescription)
                                            }
                                            if let url = url {
                                                let notif = ["ImageUrl" : url.absoluteString, "senderId" : senderUid, "creatorName" : creatorName!, "creatorUsername" : creatorUn, "timeStamp" : timeStamp, "key" : key, "notSeen" : "notSeen"] as [String : Any]
                                                let feedPost = ["\(key)" : notif]
                                                ref.child("users").child(u2d).child("Notifications").updateChildValues(feedPost)
                                                let messgae = "New message from \(creatorName!)"
                                                let title = ""
                                                
                                                if let thierKey = self.theirKey {
                                                    OneSignal.postNotification(["headings": ["en": title], "contents": ["en": messgae], "include_player_ids": [thierKey]])
                                                }

                                           
                                            }
                                            self.activityIndcc.stopAnimating()
                                        self.dismiss(animated: true, completion: nil)
                                        
                                        })
                        
                                    }
                                }
                                uploadTask.resume()

                                }
                        }
                    }
            
                }
                else {
                    if textViewMessage.text != "" {
                        print("flo")
                    if solars.count != 0, textFieldUsername.text == "" {
                        view.addSubview(activityIndcc)
                        activityIndcc.startAnimating()

                        for each in array {
                            let key =
                                ref.child("users").child(each).child("Notifications").childByAutoId().key
                             let notif = ["messageText" : textViewMessage.text, "senderId" : senderUid, "creatorName" : creatorName!, "creatorUsername" : creatorUn, "timeStamp" : timeStamp, "key" : key, "notSeen" : "notSeen"] as [String : Any]
                            let feedPst = ["\(key)" : notif]
                            ref.child("users").child(each).child("Notifications").updateChildValues(feedPst)
                        }
                         // send messages to selected users with notification keys
                        if self.usersForNotifications.count != 0 {
                            for each in self.usersForNotifications {
                                if each.tokenKey != nil {
                                    let myName = Auth.auth().currentUser?.displayName
                                    let messgae = "New message from \(myName!)"
                                    let title = ""
                                    
                                    let userKey = each.tokenKey
                                    OneSignal.postNotification(["headings": ["en": title], "contents": ["en": messgae], "include_player_ids": [userKey]])
                                    print("sent message")
                                }
                            }
                        }
                        self.activityIndcc.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                        }
                        if solars.count == 0, textFieldUsername.text != "", boolIs == true {
                            view.addSubview(activityIndcc)
                            activityIndcc.startAnimating()

                            if let u2d = uidz {
                                
                                let key =
                                    ref.child("users").child(u2d).child("Notifications").childByAutoId().key

                               print("ok")
                                let notif = ["messageText" : textViewMessage.text, "senderId" : senderUid, "creatorName" : creatorName!, "creatorUsername" : creatorUn, "timeStamp" : timeStamp, "key" : key, "notSeen" : "notSeen"] as [String : Any]
                                let feidPost = ["\(key)" : notif]
                                ref.child("users").child(u2d).child("Notifications").updateChildValues(feidPost)
                                let messgae = "New message from \(creatorName!)"
                                let title = ""
                             
                                if let thierKey = theirKey {
                                OneSignal.postNotification(["headings": ["en": title], "contents": ["en": messgae], "include_player_ids": [thierKey]])
                                }
                            }

                            self.activityIndcc.stopAnimating()
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                        }
                    }
        }
        }
        else {
            let alertyt = UIAlertController(title: "You cannot message this user", message: "Sorry you cannot send this message", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .cancel, handler: {( alert : UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
            })
            alertyt.addAction(action)
            
            self.present(alertyt, animated: true, completion: nil)
       
        }
    }
   
}
