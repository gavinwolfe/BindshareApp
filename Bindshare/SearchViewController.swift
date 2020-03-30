//
//  SearchViewController.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 6/15/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchTableView: UITableView!
    
    let actvIndicator = UIActivityIndicatorView()
    var friendsBindersArray = [Binder]()
    var array = [Binder]()
    var filteredArray = [Binder]()
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()

        boolDidRefresh = true
        //pullFire()
        pullBindersFromFriends()
   
        
                self.searchTableView.separatorColor = .black
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.frame = CGRect(x: 0, y: 92, width: self.view.frame.width, height: self.view.frame.height - 92)
        
        searchController.searchBar.placeholder = "Search All Binders"
        filteredArray = friendsBindersArray
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.layer.cornerRadius = 6.0
        searchController.searchBar.clipsToBounds = true
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchTableView.tableHeaderView = searchController.searchBar

        searchTableView.layer.cornerRadius = 6.0
        searchTableView.clipsToBounds = true 
        self.navigationController?.navigationBar.tintColor = .white
        searchController.searchBar.tintColor = .black 
        // Do any additional setup after loading the view.
    }
    var testerOfDuplicates = [String]()
    func pullFire () {
        let ref = Database.database().reference()
        ref.child("Binders").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            if let binders = snapshot.value as? [String: AnyObject] {
                for (_, one) in binders {
                    let bind = Binder()
                    if let uidcreator = one["postUid"] as? String, let descriptioni = one["description"] as? String, let setter = one["setter"] as? String, let title = one["title"] as? String, let sharers = one["sharers"] as? [String], let name = one["creatorName"] as? String, let kev = one["key"] as? String, let creatorUsername = one["creatorUsername"] as? String {
                        bind.descriptions = descriptioni
                        bind.title = title
                        bind.uidCreator = uidcreator
                        bind.sharers = sharers
                        bind.setter = setter
                        bind.creatorName = name
                        bind.key = kev
                        bind.usernameOfBinder = creatorUsername
                        bind.friendInBinder = ""
                        
                        if self.testerOfDuplicates.contains(bind.key) {
                            print("already")
                        }
                        else {
                            self.testerOfDuplicates.append(bind.key)
                        self.array.append(bind)
                    }
                    }
                    
                }
            }
            
            self.searchTableView.reloadData()
        }
        )

    }
    var boolDidRefresh : Bool?
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if boolDidRefresh == true {
        pullFire()
            boolDidRefresh = false
        }
    }
    
    // suggested search
    var checkinForDuplis = [String]()
    var friends = [String]()
    func pullBindersFromFriends() {
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            ref.child("users").child(uid).child("friends").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                if let frienders = snapshot.value as? [String : AnyObject] {
                    for (_, uno) in frienders {
                        self.friends.append(uno as! String)
                    }
                    if self.friends.count != 0 {
                        ref.child("Binders").queryOrderedByKey().observeSingleEvent(of: .value, with: { snap in                             if let bindors = snap.value as? [String : AnyObject] {
                                for (_, lir) in bindors {
                                    if let sharers = lir["sharers"] as? [String] {
                                         let bind = Binder()
                                        for each in self.friends {
                                            for one in sharers {
                                                if one == each {
                                                  
                                                    if let uidcreator = lir["postUid"] as? String, let descriptioni = lir["description"] as? String, let setter = lir["setter"] as? String, let title = lir["title"] as? String, let name = lir["creatorName"] as? String, let kev = lir["key"] as? String, let creatorUsername = lir["creatorUsername"] as? String {
                                                        bind.descriptions = descriptioni
                                                        bind.title = title
                                                        bind.uidCreator = uidcreator
                                                        bind.setter = setter
                                                        bind.creatorName = name
                                                        bind.key = kev
                                                        bind.sharers = sharers
                                                        bind.usernameOfBinder = creatorUsername
                                                        bind.friendInBinder = "A friend is in this Binder"
                                                        
                                                    }

                                                }
                                               }
                                            }
                                        if (bind.key) != nil {
                                            if self.checkinForDuplis.contains(bind.key) {
                                                print("already there")
                                            }
                                            else {
                                        self.friendsBindersArray.append(bind)
                                                print("added binder")
                                                self.checkinForDuplis.append(bind.key)
                                            }
                                        }
                                        
                                        self.searchTableView.reloadData()
                                    }
                                    
                                
                                }
                            }
                        })
                    }
                } else {
                    ref.child("Binders").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                        if let binderis = snapshot.value as? [String : AnyObject] {
                            for (_, valer) in binderis {
                                if let discoverBinder = valer["discoverBinder"] as? String {
                                    let bind = Binder()
                                    if let uidcreator = valer["postUid"] as? String, let descriptioni = valer["description"] as? String, let setter = valer["setter"] as? String, let title = valer["title"] as? String, let name = valer["creatorName"] as? String, let kev = valer["key"] as? String, let creatorUsername = valer["creatorUsername"] as? String, let sharers = valer["sharers"] as? [String] {
                                        bind.descriptions = descriptioni
                                        bind.title = title
                                        bind.uidCreator = uidcreator
                                        bind.setter = setter
                                        bind.creatorName = name
                                        bind.key = kev
                                        bind.sharers = sharers
                                        bind.usernameOfBinder = creatorUsername
                                       bind.friendInBinder = discoverBinder
                                        if self.checkinForDuplis.contains(kev) {
                                            print("there")
                                        } else {
                                            self.friendsBindersArray.append(bind)
                                            self.checkinForDuplis.append(kev)
                                        }
                                    }
                                    

                                    self.searchTableView.reloadData()
                                    
                                }
                            }
                        }
                        
                    }, withCancel: nil)
                }
            })
        
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.searchBar.text! == "" {
            filteredArray = friendsBindersArray
        }
        
        return self.filteredArray.count
    }
    
    var checklers = [String]()
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text == "" {
            filteredArray = friendsBindersArray
        }

        else if searchController.searchBar.text != "" {
        filteredArray = array.filter( { ($0.title.lowercased().contains(searchController.searchBar.text!.lowercased())) })
        }
       searchTableView.reloadData()
    }
    
    
    // cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        
            cell.friendInBinder.text = filteredArray[indexPath.row].friendInBinder
        
        cell.mainLabel.text = filteredArray[indexPath.row].title
        cell.minorLabel.text = filteredArray[indexPath.row].usernameOfBinder
        
        cell.mainLabel.frame = CGRect(x: 20, y: 10, width: cell.frame.width - 25, height: 21)
        cell.minorLabel.frame = CGRect(x: 20, y: cell.frame.height - 24, width: cell.frame.width / 2.5, height: 14)
        cell.friendInBinder.frame = CGRect(x: cell.frame.width - 180, y: 28, width: 170, height: 12)
        
        
        
        return cell
    }
    
   // segue to selected search
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedSearch" {
            let destVc = segue.destination as! SelectedBinderSearchViewController
            let indexPath = searchTableView.indexPathForSelectedRow!
            destVc.stringi = filteredArray[indexPath.row].title
            destVc.desct = filteredArray[indexPath.row].descriptions
            destVc.settler = filteredArray[indexPath.row].setter
            destVc.key = filteredArray[indexPath.row].key
            destVc.sharers = filteredArray[indexPath.row].sharers
            destVc.creatorun = filteredArray[indexPath.row].usernameOfBinder
            destVc.creatorUid = filteredArray[indexPath.row].uidCreator
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchTableView.deselectRow(at: indexPath, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       self.array.removeAll()
        self.filteredArray.removeAll()
    }
    
    
}
