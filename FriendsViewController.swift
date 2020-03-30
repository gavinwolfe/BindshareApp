//
//  FriendsViewController.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 6/28/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    deinit {
        self.searchController.view.removeFromSuperview()
    }
    
    
    
   
   let addButton = UIButton()
    var friends = [usera]()
    var filteredFriends = [usera]()
    @IBOutlet weak var searchMyFrindsTableView: UITableView!
    @IBOutlet weak var barButtonBack: UIBarButtonItem!
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white

        pull()
        
        
        searchMyFrindsTableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        addButton.frame = CGRect(x: self.view.frame.width - 100, y: self.view.frame.height - 100, width: 80, height: 80)
        addButton.setImage(#imageLiteral(resourceName: "plusBlack"), for: .normal)
        view.addSubview(addButton)
        addButton.addTarget(self, action: #selector(addUserFunc), for: .touchUpInside)
        
        searchController.searchBar.placeholder = "Search Your Friends"
        filteredFriends = friends
        searchController.searchResultsUpdater = self
        definesPresentationContext = true 
        searchMyFrindsTableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.tintColor = .black
        searchController.dimsBackgroundDuringPresentation = false 
        
        searchMyFrindsTableView.delegate = self
        searchMyFrindsTableView.dataSource = self
        navigationItem.title = "Friends"
        // Do any additional setup after loading the view.
    }

    @objc func addUserFunc() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchUser")
        self.navigationController?.pushViewController(vc, animated: true)
     
    }
    
    
    @IBAction func backActionButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
      return 1
    }
    
  
    var checkForDuplicators = [String]()
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
                                                if self.checkForDuplicators.contains(userid) {
                                                    print("already in")
                                                }
                                                else {
                                                self.friends.append(newUser)
                                                    self.checkForDuplicators.append(userid)
                                                    
                                                }
                                            }
                                            
                                        }
                                    }
                                  
                                    self.searchMyFrindsTableView.reloadData()
                                        
                                    
                                    
                                    
                                }
                            }
                        }
                        
                    })
                
                }
                              else {
                                let alert = UIAlertController(title: "Add friends", message: "You currently have no friends", preferredStyle: .alert)
                                let act = UIAlertAction(title: "Add friends", style: .default, handler:
                                { (action : UIAlertAction!) -> Void in
                                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchUser")
                                    self.navigationController?.pushViewController(vc, animated: true)
                                })
                                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                                alert.addAction(act)
                                alert.addAction(cancel)
                                self.present(alert, animated: true, completion: nil)
                                    
                                
                }
                
            })
            
        }
       
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.searchBar.text == "" {
            filteredFriends = friends
        }
        
        return self.filteredFriends.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchMyFrindsTableView.dequeueReusableCell(withIdentifier: "searchFriendsCell", for: indexPath) as! SearchFriendsTableViewCell
    cell.label.text = filteredFriends[indexPath.row].name
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.clipsToBounds = true
        cell.label.frame = CGRect(x: 5, y: 5, width: cell.frame.width - 10, height: cell.frame.height - 10)
        return cell 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       // do something
    }
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text == "" {
            filteredFriends = friends
        }
        if searchController.searchBar.text != "" {
            filteredFriends = friends.filter( { $0.name.lowercased().contains(searchController.searchBar.text!.lowercased())})
        }
        searchMyFrindsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // remove or message friend 
        if let uid = Auth.auth().currentUser?.uid {
            if self.searchController.searchBar.text == "" {
            let alert = UIAlertController(title: friends[indexPath.row].name, message: "select what you would like to do", preferredStyle: .alert)
            let profileAct = UIAlertAction(title: "View Profile", style: .default, handler: { (UIAlertAction) -> Void in
                print(uid)
               let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userProfileSearch") as! SelectedUserSearchViewController
                vc.theirUid = self.filteredFriends[indexPath.row].uid
                vc.theirName = self.filteredFriends[indexPath.row].name
                vc.theirUsername = self.filteredFriends[indexPath.row].username
                self.navigationController?.pushViewController(vc, animated: true)
            })
            let messageAction = UIAlertAction(title: "Message", style: .default, handler: { (UIAlertAction) -> Void in
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "messageToUserFromSearchUsers") as! SelectedUserMessageViewController
                vc.toUid = self.friends[indexPath.row].uid
                vc.toUsername = self.friends[indexPath.row].username
                self.present(vc, animated: true, completion: nil)
            })
                let removeFriend = UIAlertAction(title: "Remove Friend", style: .default, handler: { (alert : UIAlertAction) -> Void in
                    let alert2 = UIAlertController(title: "Remove Friend?", message: "Are you sure you want to remove this friend?", preferredStyle: .alert)
                    let actionUnfriend = UIAlertAction(title: "Remove", style: .default, handler: { (alert : UIAlertAction) -> Void in
                        if let theirId = self.filteredFriends[indexPath.row].uid {
                            if let myId = Auth.auth().currentUser?.uid {
                                let ref = Database.database().reference()
                                ref.child("users").child(myId).child("friends").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                                    if let friendz = snapshot.value as? [String : String] {
                                        for (era,ver) in friendz {
                                            if ver  == theirId {
                                                print("removing")
                                                ref.child("users").child(myId).child("friends/\(era)").removeValue()
                                                ref.child("users").child(theirId).child("friends/\(era)").removeValue()
                                              
                                            }
                                         
                                        }
                                    }
                                    
                                })
                             self.friends.remove(at: indexPath.row)
                                self.searchMyFrindsTableView.reloadData()
                            }
                        }
                    })
                    let canceller = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alert2.addAction(actionUnfriend)
                    alert2.addAction(canceller)
                    self.present(alert2, animated: true, completion: nil)
                })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(profileAct)
            alert.addAction(messageAction)
            alert.addAction(cancel)
                alert.addAction(removeFriend)
            self.present(alert, animated: true, completion: nil)
        
            }
            if self.searchController.searchBar.text != "" {
                let alert = UIAlertController(title: filteredFriends[indexPath.row].name, message: "select what you would like to do", preferredStyle: .alert)
                let profileAct = UIAlertAction(title: "View Profile", style: .default, handler: { (UIAlertAction) -> Void in
                    
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userProfileSearch") as! SelectedUserSearchViewController
                    vc.theirUid = self.filteredFriends[indexPath.row].uid
                    vc.theirName = self.filteredFriends[indexPath.row].name
                    vc.theirUsername = self.filteredFriends[indexPath.row].username
                    vc.indexPather = indexPath
                    self.navigationController?.pushViewController(vc, animated: true)
                })
                
                let messageAction = UIAlertAction(title: "Message", style: .default, handler: { (UIAlertAction) -> Void in
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "messageToUserFromSearchUsers") as! SelectedUserMessageViewController
                    vc.toUid = self.filteredFriends[indexPath.row].uid
                    vc.toUsername = self.filteredFriends[indexPath.row].username
                    self.present(vc, animated: true, completion: nil)
                })
                let removeFriend = UIAlertAction(title: "Remove Friend", style: .default, handler: { (alert : UIAlertAction) -> Void in
                    let alert2 = UIAlertController(title: "Remove Friend?", message: "Are you sure you want to remove this friend?", preferredStyle: .alert)
                    let actionUnfriend = UIAlertAction(title: "Remove", style: .default, handler: { (alert : UIAlertAction) -> Void in
                    if let theirId = self.filteredFriends[indexPath.row].uid {
                        if let myId = Auth.auth().currentUser?.uid {
                            let ref = Database.database().reference()
                                    ref.child("users").child(myId).child("friends").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                                        if let friendz = snapshot.value as? [String : String] {
                                            for (era,ver) in friendz {
                                                if ver  == theirId {
                                                    print("removing")
                                                    ref.child("users").child(myId).child("friends/\(era)").removeValue()
                                                    ref.child("users").child(theirId).child("friends/\(era)").removeValue()
                                                 
                                                }
                                             
                                            }
                                        }
                                        
                                    })
                                  
                                   self.friends = self.friends.filter{$0 != self.filteredFriends[indexPath.row]}
                                      self.filteredFriends.remove(at: indexPath.row)
                                    self.searchMyFrindsTableView.reloadData()
                                }
                            }
                    })
                    let canceller = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alert2.addAction(actionUnfriend)
                    alert2.addAction(canceller)
                    self.present(alert2, animated: true, completion: nil)
                })
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(profileAct)
                alert.addAction(removeFriend)
                alert.addAction(messageAction)
                alert.addAction(cancel)
                
                self.present(alert, animated: true, completion: nil)
              
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
}
