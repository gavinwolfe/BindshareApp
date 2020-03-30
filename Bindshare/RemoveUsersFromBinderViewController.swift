//
//  RemoveUsersFromBinderViewController.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 8/29/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class RemoveUsersFromBinderViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    var users = [usera]()
    var solars = [String]()
    var binderKey: String?
    var titleStrng: String?
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var labelRemove: UILabel!
    @IBOutlet weak var tableViewRemove: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        dismissButton.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        titleLabel.frame = CGRect(x: 80, y: 30, width: self.view.frame.width - 160, height: 30)
        labelRemove.frame = CGRect(x: 15, y: 70, width: self.view.frame.width - 30, height: 20)
        tableViewRemove.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height - 180)
        saveButton.frame = CGRect(x: 15, y: self.view.frame.height - 60, width: self.view.frame.width - 30, height: 45)

        
         self.navigationController?.navigationBar.tintColor = UIColor.white
        saveButton.layer.cornerRadius = 24
        saveButton.clipsToBounds = true 
        if let strih = titleStrng {
            titleLabel.text = strih
        }
        pull()
        tableViewRemove.delegate = self
        tableViewRemove.dataSource = self
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableViewRemove.dequeueReusableCell(withIdentifier: "removeCell", for: indexPath) as! RemoveUserFromBinderTableViewCell
        cell.labelMain.text = users[indexPath.row].name
        cell.labelMain.frame = CGRect(x: 10, y: 10, width: self.view.frame.width - 20, height: 30)
        return cell 
    }
    
    var shareArray  = [String]()
    var originArray = [String]()
    func pull() {
        if let bindKey = binderKey {
            let ref = Database.database().reference()
            ref.child("Binders").child(bindKey).child("sharers").observe(.value, with: { snapshot in
                if let sharers = snapshot.value as? [String] {
                    for (vel) in sharers {
                        
                        
                        self.shareArray.append(vel)
                        self.originArray.append(vel)
                    }
                    ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with:  { snap in
                        
                        if let userz = snap.value as? [String: AnyObject] {
                            
                            for (_,useri) in userz {
                                if let userID = useri["uid"] as? String {
                                    for each in self.shareArray {
                                        if each == userID {
                                            let newUser = usera()
                                            if let fullName = useri["Full Name"] as? String, let  userid = useri["uid"] as? String, let username = useri["Username"] as? String {
                                                newUser.name = fullName
                                                newUser.uid = userid
                                                newUser.username = username
                                                self.users.append(newUser)
                                            }
                                            
                                        }
                                    }
                                    self.tableViewRemove.reloadData()
                                    
                                }
                            }
                        }
                    })
                }
            })
            ref.removeAllObservers()
        }

    }
    @IBAction func saveButtonPressed(_ sender: Any) {
        let ref = Database.database().reference()
        
        if users.count != 0 {
            if shareArray.count < originArray.count {
        if let bindKey = binderKey {
            
                let array = shareArray
            let newShares = ["sharers" : array]
                ref.child("Binders").child(bindKey).child("sharers").removeValue()
                ref.child("Binders").child(bindKey).updateChildValues(newShares)
        }
                self.dismiss(animated: true, completion: nil)
            }
            if shareArray.count == originArray.count {
                let alert = UIAlertController(title: "Cannot save", message: "You have not removed any users", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
              
            }

    }
    }
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shareArray = shareArray.filter{$0 != users[indexPath.row].uid}

    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
         shareArray.append(users[indexPath.row].uid)
    }
    

  }
