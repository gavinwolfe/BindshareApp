//
//  EditUsersInBinderViewController.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 8/24/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class EditUsersInBinderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var users = [usera]()
    var solars = [String]()
    
    var uid = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var adsharersLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    var titleString: String?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableViewEdit: UITableView!
    var addUsers: String?
    var removeUsers: String?
    
    var BinderKey: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let titlee = titleString {
            titleLabel.text = titlee
        }
        
        
        backButton.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        titleLabel.frame = CGRect(x: 80, y: 30, width: self.view.frame.width - 160, height: 30)
        adsharersLabel.frame = CGRect(x: 15, y: 70, width: self.view.frame.width - 30, height: 20)
        tableViewEdit.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height - 180)
        saveButton.frame = CGRect(x: 15, y: self.view.frame.height - 60, width: self.view.frame.width - 30, height: 45)
        
        saveButton.layer.cornerRadius = 24
        saveButton.clipsToBounds = true
         pull()
        tableViewEdit.delegate = self
        tableViewEdit.dataSource = self
        // Do any additional setup after loading the view.
         self.navigationController?.navigationBar.tintColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewEdit.dequeueReusableCell(withIdentifier: "selectedManageBinders", for: indexPath) as! SelectNewSharersTableViewCell
        cell.labelSharer.text = users[indexPath.row].name
        cell.labelSharer.frame = CGRect(x: 10, y: 10, width: self.view.frame.width - 20, height: 30)

        return cell
    }
    
    
    var newArr = [String]()
    var shareArray = [String]()
    var arrayOfSharers = [String]()
    var followings = [String]()
    var checkForDuplicates = [String]()
    
    // friends minus sharers
    func pull() {
        if let uid = uid {
            let ref = Database.database().reference()
            print("doing")
        if let bindKey = BinderKey {
            ref.child("Binders").child(bindKey).child("sharers").observeSingleEvent(of: .value, with: { snapshot in
                if let sharers = snapshot.value as? [String] {
                    for (vel) in sharers {
                      
                        self.shareArray.append(vel)
                        self.arrayOfSharers.append(vel)
                    }
                    ref.child("users").child(uid).child("friends").queryOrderedByKey().observeSingleEvent(of: .value, with:  { snaps in
                        if let following = snaps.value as? [String : AnyObject] {
                            for (_, value) in following {
                                print(value)
                                self.followings.append(value as! String)
                            }
                            if self.followings.count != 0, self.shareArray.count != 0 {
                                self.newArr = Array(Set(self.followings).subtracting(self.shareArray))
                            }
                                ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with:  { snap in
                                
                                if let userz = snap.value as? [String: AnyObject] {
                                    
                                    for (_,useri) in userz {
                                        if let userID = useri["uid"] as? String {
                                            for each in self.newArr {
                                                if each == userID {
                                                    let newUser = usera()
                                                    if let fullName = useri["Full Name"] as? String, let  userid = useri["uid"] as? String, let username = useri["Username"] as? String {
                                                        newUser.name = fullName
                                                        newUser.uid = userid
                                                        newUser.username = username
                                                        if self.checkForDuplicates.contains(userid) {
                                                            print("aleady in array")
                                                        }
                                                        else {
                                                        self.users.append(newUser)
                                                            self.checkForDuplicates.append(userid)
                                                        }
                                                    }
                                                    
                                                }
                                            }
                                            self.tableViewEdit.reloadData()
                                        }
                                    }
                                }
                                
                            })


                }
        
            })
}
})
            ref.removeAllObservers()
}
}
}

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         solars.append(users[indexPath.row].uid)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        solars = solars.filter{$0 != users[indexPath.row].uid}
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        
        if shareArray.count != 0 {
            for each in arrayOfSharers {
                solars.append(each)
            }
        }
        
       
        if let bindKey = BinderKey {
            if users.count != 0 {
                           if solars.count != 0 {
                            if arrayOfSharers.count != 0 {
                                
                                
                    let array = solars
                    let ref = Database.database().reference()
                let newShares = ["sharers" : array]
                ref.child("Binders").child(bindKey).child("sharers").removeValue()
                    ref.child("Binders").child(bindKey).updateChildValues(newShares)
                                }
                                
                            
                            self.dismiss(animated: true, completion: nil)
                           }
                else {
                let alert = UIAlertController(title: "Cannot save", message: "You have not added any users", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                            alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
                }
            
            }
        }
        if users.count == 0 {
            let alert = UIAlertController(title: "Cannot save", message: "All your friends are already in the binder", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        
        }
        
    }
    
    
}
