//
//  NewBindViewController.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 6/16/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase
import OneSignal


// This class controls new binder class (create binder)

class NewBindViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
  let addFriendsButton = UIButton()
 
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var whoCanJoin: UILabel!
    @IBOutlet weak var textViewTitle: UITextField!
    @IBOutlet weak var textViewShare: UITextView!
    @IBOutlet weak var theSharersLabel: UILabel!
    @IBAction func changeSegment(_ sender: Any) {
        if segmentBinder.selectedSegmentIndex == 1 {
         print("changed")
            selectionTableView.isHidden = false
            theSharersLabel.text = "Who can also post?"
            theSharersLabel.isHidden = false
      
            
            
            anyoneCanPost.isHidden = false
            
        } else {
        
            label.isHidden = true
            
            selectionTableView.isHidden = false
            theSharersLabel.isHidden = false
            theSharersLabel.text = "Who can join?"
            anyoneCanPost.isHidden = true
        }
    }
    @IBOutlet weak var segmentBinder: UISegmentedControl!
    var sharers = [usera]()
    var selectedSharers = [String]()
   var onesForKeys = [usera]()
    var solars = [String]()
    
    @IBOutlet weak var selectionTableView: UITableView!
  
    func pullname () {
        if Auth.auth().currentUser?.uid != nil {
            
            let ref = Database.database().reference()
            
            let uid = Auth.auth().currentUser?.uid
            ref.child("users").child(uid!).child("Username").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                self.creationUN = snapshot.value as? String
            })
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textField.text != "" {
                let string = textViewTitle.text!.lowercased()
            if  string.contains(";") || string.contains(")") || string.contains("$") || string.contains("&") || string.contains("@") || string.contains("(") || string.contains("shit") || string.contains("fuck") || string.contains("suck") || string.contains("ass")  || string.contains("dick") || string.contains("cock") || string.contains("penis") || string.contains("lick") || string.contains("vagina") || string.contains("pussy") || string.contains("fag") || string.contains("tit") || string.contains("boob") || string.contains("hole") || string.contains("butt") || string.contains("anal") || string.contains("milf") || string.contains("cunt") || string.contains("/") || string.contains("hate") || string.contains("\\") || string.contains("\"") || string.contains(".") || string.contains(",") || string.contains("?") || string.contains("!") || string.contains("[") || string.contains("]") || string.contains("{") || string.contains("}") || string.contains("#") || string.contains("%") || string.contains("^") || string.contains("*") || string.contains("+") || string.contains("=") || string.contains("|") || string.contains("<") || string.contains(">") || string.contains("£") || string.contains("€") || string.contains("¥") || string.contains("•") || string.contains("porn") || string.contains("sex") || string.contains("nigger") || string.contains("beaner") || string.contains("coon") || string.contains("spic") || string.contains("wetback") || string.contains("chink") || string.contains("gook") || string.contains("porn") || string.contains("twat") || string.contains("crow")  || string.contains("darkie")  || string.contains("bitch") || string.contains("god hates") || string.contains("  ") || string.contains("klux") || string.contains("kkk") {
                    let alert = UIAlertController(title: "Please use a different title", message: "Please use only letters in the title and no profanity", preferredStyle: .alert)
                    let cancelerg = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                    alert.addAction(cancelerg)
                    self.present(alert, animated: true, completion: nil)
                    self.textViewTitle.text = ""
                
            }
                else {

        if (textField.text?.characters.count)! > 50 {
            textViewTitle.text = ""
            let alerto = UIAlertController(title: "Too Long of a title", message: "The title needs to be less than 50 characters", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alerto.addAction(cancel)
            self.present(alerto, animated: true, completion: nil)
        }
        }
        }
    }
   
    var creationUN: String?
    override func viewDidLoad() {
        super.viewDidLoad()
     
        addFriendsButton.setTitle("Add Friends", for: .normal)
        changedValue = false
        // to handle if all users are removed from sharers after creating binder
        let dummyString = "tH3WaY"
        solars.append(dummyString)
        
        segmentBinder.frame = CGRect(x: 60, y: 70, width: self.view.frame.width - 120, height: 30)
        titleLabel.frame = CGRect(x: 15, y: 122, width: 40, height: 20)
        textViewTitle.frame = CGRect(x: 65, y: 120, width: self.view.frame.width - 85, height: 30)
        descriptionLabel.frame = CGRect(x: 15, y: self.view.frame.height / 3.6, width: 100, height: 20)
        textViewShare.frame = CGRect(x: 15, y: self.view.frame.height / 3.1, width: self.view.frame.width - 30, height: self.view.frame.height / 4.5)
        whoCanJoin.frame = CGRect(x: 15, y: self.view.frame.height / 1.8, width: 150, height: 20)
        anyoneCanPost.frame = CGRect(x: self.view.frame.width - 80, y: self.view.frame.height / 1.8, width: 70, height: 25)
        anyoneCanPost.layer.borderWidth = 1.0
        anyoneCanPost.layer.borderColor = UIColor.black.cgColor
        anyoneCanPost.layer.cornerRadius = 12
        anyoneCanPost.clipsToBounds = true
        
        selectionTableView.frame = CGRect(x: 15, y: self.view.frame.height / 1.7, width: self.view.frame.width - 30, height: self.view.frame.height / 3.2)
        
        selectionTableView.delegate = self
        selectionTableView.dataSource = self
       self.navigationController?.navigationBar.tintColor = .white
        pull()
        pullname()
        textViewShare.layer.cornerRadius = 12.0
      textViewShare.clipsToBounds = true
        anyoneCanPost.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"  
        {
            textView.resignFirstResponder()
            return false
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        return true && numberOfChars < 296
    }
  var followings = [String]()
    func pull () {
        let ref = Database.database().reference()
        let uidi = Auth.auth().currentUser?.uid
        if let uid = uidi {
        ref.child("users").child(uid).child("friends").queryOrderedByKey().observeSingleEvent(of: .value, with:  { (snapshot) in
            
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (_, value) in following {
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
                                            if let theirKey = useri["userKey"] as? String {
                                                newUser.tokenKey = theirKey
                                            }
                                            self.sharers.append(newUser)
                                                
                                        }
                                        
                                    }
                                }
                                self.selectionTableView.reloadData()
                            }
                        }
                    }
                    
                })
            } else {
              
                self.addFriendsButton.addTarget(self, action: #selector(self.addFriends), for: .touchUpInside)
                self.addFriendsButton.frame = CGRect(x: 50, y: self.view.frame.height - 200, width: self.view.frame.width - 100, height: 30)
              self.addFriendsButton.backgroundColor = UIColor(white: 0.9, alpha: 0.6)
                self.addFriendsButton.setTitleColor(.black, for: .normal)
                self.addFriendsButton.layer.cornerRadius = 12.0
                self.addFriendsButton.layer.borderWidth = 1.0
                self.addFriendsButton.layer.borderColor = UIColor.black.cgColor
               self.addFriendsButton.clipsToBounds = false
                self.view.addSubview(self.addFriendsButton)
            }
            
            
        })
        }
        
    }
    
    @objc func addFriends () {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchUser")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func funcPost(_ sender: Any) {
        
        
        if textViewShare.text == "", textViewTitle.text != "" {
            let alert = UIAlertController(title: "Description Box is empty", message: "Please enter a description", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)

        }
        if textViewTitle.text == "", textViewShare.text != "" {
            let alert = UIAlertController(title: "Title Box is empty", message: "Please enter a title", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)

        }
        if textViewTitle.text == "", textViewShare.text == "" {
            let alert = UIAlertController(title: "Both description and title boxes are empty", message: "Please enter a title and description", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)

        }
        var puborpri = String()
        let title = textViewTitle.text
        if segmentBinder.selectedSegmentIndex == 1 {
            puborpri = "Public"
            if changedValue == true {
                solars.removeAll()
                let anyone = "Anyone"
                solars.append(anyone)
            }
        }
        else {
            puborpri = "Private"
        }
        
        
               
        let ref = Database.database().reference()
         let key = ref.child("Binders").childByAutoId().key
        let name = Auth.auth().currentUser?.displayName
        let des = textViewShare.text
              let array = solars
        print("not past")
        if let creatorNm = creationUN {
         print("past name")
               if textViewShare.text != "", textViewTitle.text != "" {
            let binderi  =                     ["setter" : puborpri,
                                                "title" : title!,
                                                "description" : des!,
                                                "postUid" : Auth.auth().currentUser!.uid as Any,
                                                "creatorUsername" : creatorNm,
                                                "sharers" : array, "creatorName" : name!,
                                                "key" : key] as [String : Any]
           
                let setup = ["\(key)" : binderi]
                ref.child("Binders").updateChildValues(setup)
            print("just created new binder")
                
                //if selected sharers have notification key, send one to them.
                if onesForKeys.count != 0 {
                    // check if the binder is public-anyone
                    if array.contains("Anyone") {
                    } else {
                        for each in onesForKeys {
                            if each.tokenKey != nil {
                                let myName = Auth.auth().currentUser?.displayName
                                let messgae = "\(myName!) has created a binder with you in it"
                                let title = ""
                                
                                let userKey = each.tokenKey
                                OneSignal.postNotification(["headings": ["en": title], "contents": ["en": messgae], "include_player_ids": [userKey]])
                                print("sent message")
                            }
                        }
                    }
                }
            }
            
       
            
            self.navigationController?.popViewController(animated: true)

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
        let cell = selectionTableView.dequeueReusableCell(withIdentifier: "selectFriendsCell", for: indexPath) as! SelectNewSharersTableViewCell
        cell.labelSharer.text = sharers[indexPath.row].name
        cell.labelSharer.frame = CGRect(x: 10, y: 10, width: self.view.frame.width - 20, height: 30)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
              solars.append(sharers[indexPath.row].uid)
        onesForKeys.append(sharers[indexPath.row])
        print(solars)
       
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        solars = solars.filter{$0 != sharers[indexPath.row].uid}
        onesForKeys = onesForKeys.filter{$0 != sharers[indexPath.row]}
        print(solars)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    var changedValue: Bool?
     let label = UILabel()
    @IBAction func anyoneCanPostAct(_ sender: Any) {
        if changedValue == false {
        anyoneCanPost.backgroundColor = UIColor.green
           label.isHidden = false 
            label.text = "Any user can post"
            label.textAlignment = .center 
            addFriendsButton.isHidden = true
            label.frame = CGRect(x: 50, y: self.view.frame.height - 150, width: self.view.frame.width - 100, height: 30)
        view.addSubview(label)
        selectionTableView.isHidden = true
            changedValue = true
        }
        else {
            anyoneCanPost.backgroundColor = .clear
            changedValue = false
            selectionTableView.isHidden = false
            label.isHidden = true
            addFriendsButton.isHidden = false
        }
    }
    
    @IBOutlet weak var anyoneCanPost: UIButton!
    

}
