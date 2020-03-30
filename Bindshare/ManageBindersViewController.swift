//
//  ManageBindersViewController.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 7/17/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class ManageBindersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

   
    let myUid = Auth.auth().currentUser?.uid
    let myName = Auth.auth().currentUser?.displayName
    var manageBinders = [Binder]()
    @IBOutlet weak var tableViewManage: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if Auth.auth().currentUser?.uid != nil, Auth.auth().currentUser?.displayName != nil {
            pull()
            pullFromSharers()
        }
        
        tableViewManage.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        tableViewManage.delegate = self
        tableViewManage.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manageBinders.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewManage.dequeueReusableCell(withIdentifier: "bindersYouAreIn", for: indexPath) as! ManageYourBindersTableViewCell
        cell.labelMain.text = manageBinders[indexPath.row].title
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.clipsToBounds = true
        cell.labelMain.frame = CGRect(x: 10, y: 10, width: self.view.frame.width - 20, height: 30)
        return cell
    }
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        return true && numberOfChars < 30
    }
    var newArray = [String]()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if let creatorUid = manageBinders[indexPath.row].uidCreator {
            if let uip = myUid {
                
                if uip != creatorUid {
                    let alert = UIAlertController(title: manageBinders[indexPath.row].title, message: "Do you want to leave this binder? If you leave, press refresh back at my binders and this binder will be gone", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Leave Binder", style: .default, handler: {( alert : UIAlertAction) -> Void in
                        let ref = Database.database().reference()
                        if let keyp = self.manageBinders[indexPath.row].key {
                         
                            ref.child("Binders").child(keyp).child("sharers").observeSingleEvent(of: .value, with: { snapshot in
                                if let sharers = snapshot.value as? [String] {
                                    for i in 0..<sharers.count {
                                        if sharers[i] == uip {
                                            ref.child("Binders").child(keyp).child("sharers").child("\(i)").removeValue()
                                        } 
                                    } 
                                } 
                                
                            })
                            self.manageBinders.remove(at: indexPath.row)
                            self.tableViewManage.reloadData()
                            
                        }
                       
                    })
                    
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alert.addAction(action)
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
                }
                if uip == creatorUid {
                    
                    if let thisBindersSharers = manageBinders[indexPath.row].sharers {
                        if thisBindersSharers.contains("Anyone") {
                            let alertio = UIAlertController(title: "\(manageBinders[indexPath.row].title!)", message: "Select what you wouls like to do?", preferredStyle: .alert )
                            let changeNamer = UIAlertAction(title: "Change Binder Name", style: .default, handler: {( alert : UIAlertAction) -> Void in
                                let secondAlert = UIAlertController(title: "Change Binder Name", message: "Please enter a new name for your binder", preferredStyle: .alert)
                                secondAlert.addTextField { (textField : UITextField!) -> Void in
                                    textField.placeholder = "Enter a title"
                                    textField.keyboardType = .asciiCapable
                                    
                                }
                                let cancelSecond = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
                                let save = UIAlertAction(title: "Save", style: .default, handler: { (alert : UIAlertAction) -> Void in
                                    if secondAlert.textFields?[0].text != "" {
                                        if secondAlert.textFields?[0].text != " " {
                                            let string = secondAlert.textFields![0].text!.lowercased()
                                            if  string.contains(";") || string.contains(")") || string.contains("$") || string.contains("&") || string.contains("@") || string.contains("(") || string.contains("shit") || string.contains("fuck") || string.contains("suck") || string.contains("ass")  || string.contains("dick") || string.contains("cock") || string.contains("penis") || string.contains("lick") || string.contains("vagina") || string.contains("pussy") || string.contains("fag") || string.contains("tit") || string.contains("boob") || string.contains("hole") || string.contains("butt") || string.contains("anal") || string.contains("milf") || string.contains("cunt") || string.contains("/") || string.contains("hate") || string.contains("\\") || string.contains("\"") || string.contains(".") || string.contains(",") || string.contains("?") || string.contains("!") || string.contains("[") || string.contains("]") || string.contains("{") || string.contains("}") || string.contains("#") || string.contains("%") || string.contains("^") || string.contains("*") || string.contains("+") || string.contains("=") || string.contains("|") || string.contains("<") || string.contains(">") || string.contains("£") || string.contains("€") || string.contains("¥") || string.contains("•") || string.contains("porn") || string.contains("sex") || string.contains("nigger") || string.contains("beaner") || string.contains("coon") || string.contains("spic") || string.contains("wetback") || string.contains("chink") || string.contains("gook") || string.contains("porn") || string.contains("twat") || string.contains("crow")  || string.contains("darkie")  || string.contains("bitch") || string.contains("god hates") || string.contains("  ") || string.contains("klux") || string.contains("kkk") {
                                            } else {
                                                if (secondAlert.textFields?[0].text?.characters.count)! <= 40 {
                                                    if let key = self.manageBinders[indexPath.row].key {
                                                        let refer = Database.database().reference()
                                                        if let text = secondAlert.textFields?[0].text {
                                                            let newTitle = ["title" : text]
                                                            refer.child("Binders").child(key).child("title").removeValue()
                                                            refer.child("Binders").child(key).updateChildValues(newTitle)
                                                        }
                                                    }
                                                    self.manageBinders.removeAll()
                                                    self.checkSharersDuplicates.removeAll()
                                                    self.pull()
                                                    self.pullFromSharers()
                                                    self.tableViewManage.reloadData()
                                                }
                                                if (secondAlert.textFields?[0].text?.characters.count)! > 40 {
                                                    let alevvt = UIAlertController(title: "Too many characters", message: "Your title is too long, please make it less than 40 characters", preferredStyle: .alert)
                                                    let cancelll = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                                                    alevvt.addAction(cancelll)
                                                    self.present(alevvt, animated: true, completion: nil)
                                                }
                                            }
                                        }
                                    }
                                })
                                secondAlert.addAction(cancelSecond)
                                secondAlert.addAction(save)
                                self.present(secondAlert, animated: true, completion: nil)
                            })
                            let changeDesc = UIAlertAction(title: "Change Binder Description", style: .default, handler: {( alert : UIAlertAction) -> Void in
                                let secondAlert = UIAlertController(title: "Change Binder Description", message: "Please enter a new description for your binder", preferredStyle: .alert)
                                secondAlert.addTextField { (textField : UITextField!) -> Void in
                                    textField.placeholder = "Enter a description"
                                    textField.keyboardType = .asciiCapable
                                }
                                let cancelSecond = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
                                let save = UIAlertAction(title: "Save", style: .default, handler: { (alert : UIAlertAction) -> Void in
                                    if secondAlert.textFields?[0].text != "" {
                                        if (secondAlert.textFields?[0].text?.characters.count)! <= 296 {
                                            if let key = self.manageBinders[indexPath.row].key {
                                                let refer = Database.database().reference()
                                                if let text = secondAlert.textFields?[0].text {
                                                    let newTitle = ["description" : text]
                                                    refer.child("Binders").child(key).child("description").removeValue()
                                                    refer.child("Binders").child(key).updateChildValues(newTitle)
                                                }
                                            }
                                        }
                                        if (secondAlert.textFields?[0].text?.characters.count)! > 40 {
                                            let alevvt = UIAlertController(title: "Too many characters", message: "Your description is too long, please make it less than 296 characters", preferredStyle: .alert)
                                            let cancelll = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                                            alevvt.addAction(cancelll)
                                            self.present(alevvt, animated: true, completion: nil)
                                        }
                                        
                                    }
                                })
                                secondAlert.addAction(cancelSecond)
                                secondAlert.addAction(save)
                                self.present(secondAlert, animated: true, completion: nil)
                                
                                
                            })
                            
                            let deleteBinder = UIAlertAction(title: "Delete Binder", style: .default, handler: {( alert : UIAlertAction) -> Void in
                                let areYousSureAlert = UIAlertController(title: "Delete this Binder?", message: "Are you sure that you want to delete this binder, all data in it will also be deleted. If you press delete, make sure to press refresh back at my binders", preferredStyle: .alert)
                                let canceeeel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                                let delete = UIAlertAction(title: "Delete", style: .default, handler: {( alert : UIAlertAction) -> Void in
                                    if let keyy = self.manageBinders[indexPath.row].key {
                                        let reff = Database.database().reference()
                                        reff.child("Binders").child(keyy).removeValue()
                                    }
                                    self.manageBinders.removeAll()
                                    self.checkSharersDuplicates.removeAll()
                                    self.pull()
                                    self.pullFromSharers()
                                    self.tableViewManage.reloadData()
                                })
                                areYousSureAlert.addAction(canceeeel)
                                areYousSureAlert.addAction(delete)
                                self.present(areYousSureAlert, animated: true, completion: nil)
                            })
                            
                            
                            alertio.addAction(deleteBinder)
                            alertio.addAction(changeNamer)
                            alertio.addAction(changeDesc)
                            let cancelerty = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                            alertio.addAction(cancelerty)
                            self.present(alertio, animated: true, completion: nil)
                        } else {
                    
                    
                    let alert = UIAlertController(title: manageBinders[indexPath.row].title, message: "Select what you would like to do", preferredStyle: .alert)
                    let changeName = UIAlertAction(title: "Change Binder Name", style: .default, handler: {( alert : UIAlertAction) -> Void in
                    let secondAlert = UIAlertController(title: "Change Binder Name", message: "Please enter a new name for your binder", preferredStyle: .alert)
                        secondAlert.addTextField { (textField : UITextField!) -> Void in
                            textField.placeholder = "Enter a title"
                            textField.keyboardType = .asciiCapable
                            
                                }
                        let cancelSecond = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
                        let save = UIAlertAction(title: "Save", style: .default, handler: { (alert : UIAlertAction) -> Void in
                            if secondAlert.textFields?[0].text != "" {
                                if secondAlert.textFields?[0].text != " " {
                                    let string = secondAlert.textFields![0].text!.lowercased()
                                    if  string.contains(";") || string.contains(")") || string.contains("$") || string.contains("&") || string.contains("@") || string.contains("(") || string.contains("shit") || string.contains("fuck") || string.contains("suck") || string.contains("ass")  || string.contains("dick") || string.contains("cock") || string.contains("penis") || string.contains("lick") || string.contains("vagina") || string.contains("pussy") || string.contains("fag") || string.contains("tit") || string.contains("boob") || string.contains("hole") || string.contains("butt") || string.contains("anal") || string.contains("milf") || string.contains("cunt") || string.contains("/") || string.contains("hate") || string.contains("\\") || string.contains("\"") || string.contains(".") || string.contains(",") || string.contains("?") || string.contains("!") || string.contains("[") || string.contains("]") || string.contains("{") || string.contains("}") || string.contains("#") || string.contains("%") || string.contains("^") || string.contains("*") || string.contains("+") || string.contains("=") || string.contains("|") || string.contains("<") || string.contains(">") || string.contains("£") || string.contains("€") || string.contains("¥") || string.contains("•") || string.contains("porn") || string.contains("sex") || string.contains("nigger") || string.contains("beaner") || string.contains("coon") || string.contains("spic") || string.contains("wetback") || string.contains("chink") || string.contains("gook") || string.contains("porn") || string.contains("twat") || string.contains("crow")  || string.contains("darkie")  || string.contains("bitch") || string.contains("god hates") || string.contains("  ") || string.contains("klux") || string.contains("kkk") {
                                    } else {
                                if (secondAlert.textFields?[0].text?.characters.count)! <= 40 {
                            if let key = self.manageBinders[indexPath.row].key {
                                let refer = Database.database().reference()
                                if let text = secondAlert.textFields?[0].text {
                                let newTitle = ["title" : text]
                                    refer.child("Binders").child(key).child("title").removeValue()
                            refer.child("Binders").child(key).updateChildValues(newTitle)
                            }
                                    }
                                self.manageBinders.removeAll()
                                    self.checkSharersDuplicates.removeAll()
                                self.pull()
                                self.pullFromSharers()
                                self.tableViewManage.reloadData()
                                }
                                if (secondAlert.textFields?[0].text?.characters.count)! > 40 {
                                    let alevvt = UIAlertController(title: "Too many characters", message: "Your title is too long, please make it less than 40 characters", preferredStyle: .alert)
                                    let cancelll = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                                    alevvt.addAction(cancelll)
                                    self.present(alevvt, animated: true, completion: nil)
                                }
                                    }
                            }
                            }
                        })
                        secondAlert.addAction(cancelSecond)
                        secondAlert.addAction(save)
                    self.present(secondAlert, animated: true, completion: nil)

                    
                    
                    })
                    
                
                    let editAct = UIAlertAction(title: "Add User(s)", style: .default, handler: {( alert : UIAlertAction) -> Void in
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editBinder") as! EditUsersInBinderViewController
                        vc.BinderKey = self.manageBinders[indexPath.row].key
                        vc.titleString = self.manageBinders[indexPath.row].title
                        self.present(vc, animated: true, completion: nil)
                    
                    })
                    let changeDesc = UIAlertAction(title: "Change Binder Description", style: .default, handler: {( alert : UIAlertAction) -> Void in
                        let secondAlert = UIAlertController(title: "Change Binder Description", message: "Please enter a new description for your binder", preferredStyle: .alert)
                        secondAlert.addTextField { (textField : UITextField!) -> Void in
                            textField.placeholder = "Enter a description"
                            textField.keyboardType = .asciiCapable
                        }
                        let cancelSecond = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
                        let save = UIAlertAction(title: "Save", style: .default, handler: { (alert : UIAlertAction) -> Void in
                            if secondAlert.textFields?[0].text != "" {
                                  if (secondAlert.textFields?[0].text?.characters.count)! <= 296 {
                                if let key = self.manageBinders[indexPath.row].key {
                                    let refer = Database.database().reference()
                                    if let text = secondAlert.textFields?[0].text {
                                        let newTitle = ["description" : text]
                                        refer.child("Binders").child(key).child("description").removeValue()
                                        refer.child("Binders").child(key).updateChildValues(newTitle)
                                    }
                                }
                                }
                                if (secondAlert.textFields?[0].text?.characters.count)! > 40 {
                                    let alevvt = UIAlertController(title: "Too many characters", message: "Your description is too long, please make it less than 296 characters", preferredStyle: .alert)
                                    let cancelll = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                                    alevvt.addAction(cancelll)
                                    self.present(alevvt, animated: true, completion: nil)
                                }

                            }
                        })
                        secondAlert.addAction(cancelSecond)
                        secondAlert.addAction(save)
                        self.present(secondAlert, animated: true, completion: nil)
                        

                    })
                    let action = UIAlertAction(title: "Remove User(s)", style: .default, handler: {( alert : UIAlertAction) -> Void in
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "removeUsers") as! RemoveUsersFromBinderViewController
                        vc.binderKey = self.manageBinders[indexPath.row].key
                        vc.titleStrng = self.manageBinders[indexPath.row].title
                    self.present(vc, animated: true, completion: nil)
                    })
                      let deleteBinder = UIAlertAction(title: "Delete Binder", style: .default, handler: {( alert : UIAlertAction) -> Void in
                    let areYousSureAlert = UIAlertController(title: "Delete this Binder?", message: "Are you sure that you want to delete this binder, all data in it will also be deleted. If you press delete, make sure to press refresh back at my binders", preferredStyle: .alert)
                        let canceeeel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        let delete = UIAlertAction(title: "Delete", style: .default, handler: {( alert : UIAlertAction) -> Void in
                            if let keyy = self.manageBinders[indexPath.row].key {
                                let reff = Database.database().reference()
                                reff.child("Binders").child(keyy).removeValue()
                            }
                            self.manageBinders.removeAll()
                            self.checkSharersDuplicates.removeAll()
                            self.pull()
                            self.pullFromSharers()
                            self.tableViewManage.reloadData()
                        })
                        areYousSureAlert.addAction(canceeeel)
                        areYousSureAlert.addAction(delete)
                        self.present(areYousSureAlert, animated: true, completion: nil)
                    })
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alert.addAction(action)
                    alert.addAction(editAct)
                    alert.addAction(changeName)
                    alert.addAction(deleteBinder)
                    alert.addAction(cancel)
                    alert.addAction(changeDesc)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
                }
        }
        
    }
    
    
    func pull () {
        let ref = Database.database().reference()
        ref.child("Binders").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            if let binders = snapshot.value as? [String : AnyObject] {
                
                for (_, val) in binders {
                    if let useri = val["postUid"] as? String {
                        if useri == Auth.auth().currentUser?.uid {
                            
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
                                self.manageBinders.append(bindfl)
                            }
                        }
                    }
                }
            }
            self.tableViewManage.reloadData()
        })
        ref.removeAllObservers()
    }
    var checkSharersDuplicates = [String]()
    func pullFromSharers () {
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        ref.child("Binders").queryOrderedByKey().observeSingleEvent(of: .value, with:  { snapshot in
            if let binder = snapshot.value as? [String : AnyObject] {
                for (_, vale) in binder {
                    if let sharlers = vale["sharers"] as? [String] {
                        for each in sharlers {
                            if each == uid {
                                let newpie = Binder()
                                if let title = vale["title"] as? String, let descript = vale["description"] as? String,
                                    let sharers = vale["sharers"] as? [String], let creatorUn = vale["creatorUsername"] as? String, let setter = vale["setter"] as? String, let creatorName = vale["creatorName"] as? String, let kev = vale["key"] as? String, let postUID = vale["postUid"] as? String {
                                    print("making good")
                                    newpie.title = title
                                    newpie.descriptions = descript
                                    newpie.setter = setter
                                    newpie.sharers = sharers
                                    newpie.usernameOfBinder = creatorUn
                                    newpie.creatorName = creatorName
                                    newpie.key = kev
                                    newpie.uidCreator = postUID
                                    if self.checkSharersDuplicates.contains(kev) {
                                        print("Binder of sharer is already appended")
                                    }
                                    else {
                                    self.manageBinders.append(newpie)
                                        self.checkSharersDuplicates.append(kev)
                                    }
                                }
                            }
                        }
                    }
                }
                self.tableViewManage.reloadData()
            }
        })
        ref.removeAllObservers()
    }


}
