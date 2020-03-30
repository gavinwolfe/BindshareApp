//
//  ViewController.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 6/15/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase



//This class controls tab bar index 1 (Home)

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   
    
    let loader = UIActivityIndicatorView()
    //Check if user is logged in//
     var firAuthUser: String?
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser?.uid != nil {
        pull()
        pullFromSharers()
        if let newUser = firAuthUser {
            if newUser != Auth.auth().currentUser?.uid {
                pullname()
            }
        }
        }
    }
    func checkLoggedin () {
        if Auth.auth().currentUser?.uid == nil {
            firAuthUser = "nil"
            perform(#selector(logoutnow), with: nil, afterDelay: 0)
            
        }
        else {
            print("your good")
        }
        
    }
    @objc func logoutnow () {
        do {
            try Auth.auth().signOut()
        }   catch let loginError {
            print(loginError)
        }
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginOrSignUp")
        self.present(vc, animated: true, completion: nil)
    }
    


    //Reload page button//
    @IBAction func refreshAction(_ sender: Any) {
        binds.removeAll()
        checkForDuplicates.removeAll()
        duplicateChecker.removeAll()
        pull()
        pullFromSharers()
        tableViewMain.reloadData()
    }
  
    //find the current user's username//
    var usernameString: String?

    func pullname () {
        if Auth.auth().currentUser?.uid != nil {
            
            let ref = Database.database().reference()
            
            let uid = Auth.auth().currentUser?.uid
            ref.child("users").child(uid!).child("Username").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                self.usernameString = snapshot.value as? String
            })
           
        }
    }

    
    
    // ui connections
    @IBOutlet weak var yourBindersLabel: UILabel!
    @IBOutlet weak var tableViewMain: UITableView!
    
    // binder array //
    var binds = [Binder]()

    var badgeNums = [String]()
    // view did load //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Database.database().reference()
        if let myuid = Auth.auth().currentUser?.uid {
            ref.child("users").child(myuid).child("Notifications").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let notifications = snapshot.value as? [String : AnyObject] {
                    for (_, veel) in notifications {
                        if let unseen = veel["notSeen"] as? String {
                            self.badgeNums.append(unseen)
                            
                        }
                    }
                }
                if self.badgeNums.count != 0 {
                    if self.badgeNums.count < 10 {
                    self.tabBarController?.tabBar.items?[0].badgeValue = "\(self.badgeNums.count)"
                    }
                    else {
                         self.tabBarController?.tabBar.items?[0].badgeValue = "9"
                    }
                }
            }, withCancel: nil)
            
           
        }
      
        
        // check if user is logged in, then do something //
        if Auth.auth().currentUser?.uid != nil {
            firAuthUser = Auth.auth().currentUser?.uid
            loader.startAnimating()
            
            view.addSubview(loader)

        }
        loader.frame = CGRect(x: self.view.frame.width / 2.25, y: self.view.frame.height / 2, width: 30, height: 30)
        loader.color = UIColor.black
       

        // check if user is logged in
        checkLoggedin()
        // table view
        tableViewMain.delegate = self
        tableViewMain.dataSource = self
        tableViewMain.frame = CGRect(x: 0, y: 90, width: self.view.frame.width, height: self.view.frame.height - 160)
        tableViewMain.layer.cornerRadius = 2.0
        tableViewMain.clipsToBounds = true
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Futura", size: 22)!, NSAttributedStringKey.foregroundColor : UIColor.white]
        yourBindersLabel.frame = CGRect(x: 15, y: 67.5, width: 150, height: 20)
        
        if view.frame.height == 812 {
              tableViewMain.frame = CGRect(x: 0, y: 110, width: self.view.frame.width, height: self.view.frame.height - 160)
             yourBindersLabel.frame = CGRect(x: 5, y: 87.5, width: 150, height: 20)
        }
            }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 0
    }
  
    // pull binders //
    var checkForDuplicates = [String]()
    func pull () {
        var reloadTableViewIfNewValue = false
        let ref = Database.database().reference()
        ref.child("Binders").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
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
                                
                                if self.checkForDuplicates.contains(bindfl.key) {
                                    print("binder already there")
                                }
                                else {
                                    self.binds.append(bindfl)
                                    self.checkForDuplicates.append(bindfl.key)
                                    reloadTableViewIfNewValue = true
                                }
                            }
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                if reloadTableViewIfNewValue == true {
                    self.tableViewMain.reloadData()
                    print("reloaded")
                }
            }
            self.loader.stopAnimating()
        
        }, withCancel: nil)
    }
       func createNewBindshare() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newBindVc")
        self.present(vc, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return binds.count 
    }
    // add binders to [binds] based on if they are in it
    var duplicateChecker = [String]()
    func pullFromSharers () {
        var shouldReloadTableView = false
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        ref.child("Binders").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            if let binder = snapshot.value as? [String : AnyObject] {
                for (_, vale) in binder {
                    if let sharlers = vale["sharers"] as? [String] {
                        for each in sharlers {
                            if each == uid {
                                let newpie = Binder()
                                if let title = vale["title"] as? String, let descript = vale["description"] as? String,
                                    let sharers = vale["sharers"] as? [String], let creatorUn = vale["creatorUsername"] as? String, let setter = vale["setter"] as? String, let creatorName = vale["creatorName"] as? String, let kev = vale["key"] as? String, let postUID = vale["postUid"] as? String {
                                    newpie.title = title
                                    newpie.descriptions = descript
                                    newpie.setter = setter
                                    newpie.sharers = sharers
                                    newpie.usernameOfBinder = creatorUn
                                    newpie.creatorName = creatorName
                                    newpie.key = kev
                                    newpie.uidCreator = postUID
                                    if self.duplicateChecker.contains(newpie.key) {
                                        print("Binder of share is already in array")
                                    }
                                    else {
                                        shouldReloadTableView = true
                                        self.binds.append(newpie)
                                        self.duplicateChecker.append(newpie.key)
                                       
                                    }
                                }
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    if shouldReloadTableView == true {
                        self.tableViewMain.reloadData()
                       
                    }
                }
            }
            
        }, withCancel: nil)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewMain.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainTableViewCell
        cell.labelCell.text = binds[indexPath.row].title
        return cell
    }
   
    // segue data to other vcs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = .white
        navigationItem.backBarButtonItem = backButton
        if segue.identifier == "customBind" {
            let destVc = segue.destination as! CustomBindViewController
            let indexPath = tableViewMain.indexPathForSelectedRow!
            destVc.string = binds[indexPath.row].title
            destVc.dest = binds[indexPath.row].descriptions
            destVc.username = binds[indexPath.row].creatorName
            destVc.imprt = binds[indexPath.row].key
        }
       
       
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
       let ref = Database.database().reference().child("Binders")
        ref.removeAllObservers()
        print("ViewController observers removed")
    
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewMain.deselectRow(at: indexPath, animated: true)
    }
    
}




