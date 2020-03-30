//
//  SearchUserViewController.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 6/30/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class SearchUserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    var usersFriends = [usera]()
    var username: String?
    var users = [usera]()
    var filteredUsers = [usera]()
    let uid = Auth.auth().currentUser?.uid
 
    deinit {
        self.searchController.view.removeFromSuperview()
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var tableViewSearchUser: UITableView!
    override func viewDidLoad() {
        pullBlockers()
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        filteredUsers = usersFriends
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        tableViewSearchUser.tableHeaderView = searchController.searchBar

    
        pullFromFriends()
        boolDidRefresh = true 
        searchController.searchBar.placeholder = "Search any user"
        pullname()
        self.navigationItem.title = "Search Users"
        searchController.searchBar.tintColor = .black
        tableViewSearchUser.delegate = self
        tableViewSearchUser.dataSource = self
        searchController.dimsBackgroundDuringPresentation = false 
        
        // Do any additional setup after loading the view.
    }
    
    
    
  var checklers = [String]()
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text == "" {
            filteredUsers = usersFriends
        }
        else if searchController.searchBar.text != "" {
            filteredUsers = users.filter( { ($0.name.lowercased().contains(searchController.searchBar.text!.lowercased())) || ($0.username.lowercased().contains(searchController.searchBar.text!.lowercased()))})
        }

        tableViewSearchUser.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    var new = [usera]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.searchBar.text == "" {
            filteredUsers = usersFriends
        }
        
      return filteredUsers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewSearchUser.dequeueReusableCell(withIdentifier: "searchUsersCell", for: indexPath) as! UserSearchTableViewCell
         DispatchQueue.main.async {
        cell.labelUser.text = self.filteredUsers[indexPath.row].username
        }
        return cell
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
    //pull if you start searching
    var boolDidRefresh: Bool?
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if boolDidRefresh == true {
            pull()
            boolDidRefresh = false
        }
    }
var noMoreDuplicators = [String]()
    func pull () {
        if let myIdi = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference()
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            if let userers = snapshot.value as? [String : AnyObject] {
                for (_, velt) in userers {
                    let newUser = usera()
                    if let thierId = velt["uid"] as? String {
                        if thierId != myIdi {
                    if let userName = velt["Username"] as? String, let name = velt["Full Name"] as? String, let userIdent = velt["uid"] as? String {
                        newUser.name = name
                        newUser.username = userName
                        newUser.uid = userIdent
                        
                        if self.noMoreDuplicators.contains(userIdent) {
                            print("user already added")
                        } else {
                            self.users.append(newUser)
                            self.noMoreDuplicators.append(userIdent)
                        }
                    }
                        }
                    }
                }
                self.tableViewSearchUser.reloadData()
            }
            
        })
        
        ref.removeAllObservers()
        }
    }
    
    
    //  pull people you block 
    var blockers = [String]()
    func pullBlockers () {
        let ref = Database.database().reference()
        if let uipp = Auth.auth().currentUser?.uid {
            ref.child("users").child(uipp).child("Blocked").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                if let blockters = snapshot.value as? [String : AnyObject] {
                    for (_, vert) in blockters {
                       self.blockers.append(vert as! String)
                    }
                }
            })
        }
        ref.removeAllObservers()

    }
    // since following array on firebase is just a key: uid, i just store uids in array, the friends. 
    //should change name to friends but whatever
 
    
    // im stoked on this code, grabbing your friend's friends. 
    var followings = [String]()
    var moreUsers = [String]()
    var Ifollows = [String]()
    var checkers = [String]()
    func pullFromFriends () {
        let ref = Database.database().reference()
        let uidi = Auth.auth().currentUser?.uid
        if let uid = uidi {
           
            ref.child("users").child(uid).child("friends").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                if let friends = snapshot.value as? [String : AnyObject] {
                    for (_, uno) in friends {
                        self.followings.append(uno as! String)
                        self.Ifollows.append(uno as! String)
                    }
                    ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snap in
                        if self.followings.count != 0 {
                            if let usert = snap.value as? [String : AnyObject] {
                                for (_, sip) in usert {
                                    if let uider = sip["uid"] as? String {
                                        for each in self.followings {
                                            if each == uider {
                                                if let friendsOfFriends = sip["friends"] as? [String : AnyObject] {
                                                    for (_, loop) in friendsOfFriends {
                                                        if self.moreUsers.contains(loop as! String) {
                                                          
                                                        }
                                                            else {
                                                                self.moreUsers.append(loop as! String)
                                                            }
                                                        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with:  { snapy in
                                                            
                                                            if let userz = snapy.value as? [String: AnyObject] {
                                                                
                                                                for (_,useri) in userz {
                                                                    if let userID = useri["uid"] as? String {
                                                                        let newUser = usera()
                                                                        for each in self.moreUsers {
                                                                            if each == userID {
                                                                                
                                                                                if let fullName = useri["Full Name"] as? String, let  userid = useri["uid"] as? String, let username = useri["Username"] as? String {
                                                                                    newUser.name = fullName
                                                                                    newUser.uid = userid
                                                                                    newUser.username = username
                                                                                    
                                                                                        print(self.moreUsers.count)
                                                                          }
                                                                                
                                                                            }
                                                                        }
                                                                        // check if the user has an uid, name, and un then see if it isalready in the array
                                                                        if let namer = newUser.uid {
                                                                            print(namer)
                                                                            if self.checkers.contains(newUser.uid) {
                                                                                print("user already added")
                                                                            }
                                                                            else {
                                                                                print(newUser.name)
                                                                                if newUser.uid != uid {
                                                                        self.usersFriends.append(newUser)
                                                                                    
                                                                                    self.checkers.append(newUser.uid)

                                                                                }
                                                                            }
                                                                        }
                                                                        self.tableViewSearchUser.reloadData()
                                                                    }
                                                                }
                                                            }
                                                            
                                                        })

                                                        
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

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.users.removeAll()
        self.filteredUsers.removeAll()
    }
   
   

    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        let ref = Database.database().reference().child("users")
        ref.removeAllObservers()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueSelectedSearchUser" {
            let destVc = segue.destination as! SelectedUserSearchViewController
            let indexPath = tableViewSearchUser.indexPathForSelectedRow!
            destVc.theirName = filteredUsers[indexPath.row].name
            destVc.theirUsername = filteredUsers[indexPath.row].username
            destVc.theirUid = filteredUsers[indexPath.row].uid
        }
    }
    
  }
