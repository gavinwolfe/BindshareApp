//
//  CustomBindViewController.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 6/16/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

// This class controls selected binder (pages inside, description, creator)

class CustomBindViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    
    // observe value is removed when user leaves view, and is restarted on it appearing again
    override func viewWillAppear(_ animated: Bool) {
      pull()

        print("loaded binder pages")
    }
   
    
    var pages = [Page]()
    @IBOutlet weak var binderTableView: UITableView!
    let usernameLabel = UILabel()
    let descriptionLabel = UILabel()

    var imprt: String?
    let cellSpacingHeight: CGFloat = 5

    var username: String?
    var dest: String?
    var string: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // description segue from viewcontroller
        if let strin = dest {
            descriptionLabel.text = strin
        }
        
        // binder key segued from viewcontroller
        if let bert = imprt {
            print(bert)
        }
    
        usernameLabel.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        descriptionLabel.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        
        usernameLabel.font = UIFont(name: "Times New Roman", size: 15)
        usernameLabel.textAlignment = NSTextAlignment.center
        
        // username of binder segue from vc
        if let usnm = username {
            usernameLabel.text = usnm
        }
        descriptionLabel.textAlignment = NSTextAlignment.center
        descriptionLabel.numberOfLines = 5
        descriptionLabel.font = UIFont(name: "Palatino", size: 12)
        usernameLabel.frame = CGRect(x: 0, y: 60, width: self.view.frame.width , height: 30)
        descriptionLabel.frame = CGRect(x: 0, y: 90, width: self.view.frame.width , height: 80)
        binderTableView.frame = CGRect(x: 0, y: 170, width: self.view.frame.width, height: self.view.frame.height - 210)

        
        // binder title segue from vc
        if let string = string {
         navigationItem.title = string
        }

        binderTableView.delegate = self
        binderTableView.dataSource = self

         view.addSubview(usernameLabel)
         view.addSubview(descriptionLabel)
                
  
       
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newPageFunc)), animated: true)
        self.navigationItem.rightBarButtonItem?.tintColor = .white

    
       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return pages.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = binderTableView.dequeueReusableCell(withIdentifier: "pageCell", for: indexPath) as! CustomBinderPostTableViewCell
        if pages.count >  1 {
            if let timeStamp = pages[indexPath.section].timeStamp {
             pages.sort { $1.timeStamp < $0.timeStamp }
                print("\(timeStamp) - timestamp for each cell")
                      }
        }
        
        cell.imageCell.frame = CGRect(x: 10, y: 30, width: 20, height: 20)
        cell.labelTitle.frame = CGRect(x: 50, y: 30, width: self.view.frame.width - 55, height: 20)
        cell.labelTitle.text = pages[indexPath.section].title
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
       
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
      let timeStampi: Int = Int(NSDate().timeIntervalSince1970)
    
    // delete page
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if let keyExists = pages[indexPath.section].key {
            print(keyExists)
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let alert = UIAlertController(title: "Delete Page?", message: "If you select delete, all photos along with the page will be deleted", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let delete = UIAlertAction(title: "Delete", style: .default, handler: { (action : UIAlertAction!) -> Void in
                if let key = self.imprt {
                    let ref = Database.database().reference()
                  
                    ref.child("Binders").child(key).child("Page").child(self.pages[indexPath.section].key).removeValue()
                    //remove all elements while page is being delete (dont want them to try to click delete again)
                    self.pages.removeAll()
                    self.checkForDuplicates.removeAll()
                    self.binderTableView.reloadData()
                }
                
              
                
            })
            alert.addAction(cancel)
            alert.addAction(delete)
            self.present(alert, animated: true, completion: nil)
            alert.view.tintColor = .black
        }
        }
    }

    var textfeld = UITextField()
    var refreshBool: Bool?
    @objc func newPageFunc () {
        refreshBool = false
        let alert = UIAlertController(title: "New Page", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter a title"
            textField.keyboardType = .asciiCapable
        }
        let createAction = UIAlertAction(title: "Create", style: .default, handler: { (action : UIAlertAction!) -> Void in
            
                  if alert.textFields?[0].text != "" {
                if (alert.textFields?[0].text?.characters.count)! < 40 {
                    let ref = Database.database().reference()
                let titler = alert.textFields?[0].text
          
                    
                    if let bindKey = self.imprt {
                                     let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
                                    print("ok")
                                     let key = ref.child("Binders").child(bindKey).child("Page").childByAutoId().key
                        let page = ["title" : titler!, "poster" : Auth.auth().currentUser?.displayName as Any, "key" : key, "timeStamp" : timeStamp] as [String : Any]
                                   
                                    let setup = ["\(key)" : page]
                                    ref.child("Binders").child(bindKey).child("Page").updateChildValues(setup)
                                    self.binderTableView.reloadData()
                                  
                    
                    }
                    
                }
                if (alert.textFields?[0].text?.characters.count)! >= 40 {
                    let alert = UIAlertController(title: "Too many characters", message: "Your title has too many characters, please limit it to 49 characters or less", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
                }
                   
            }
            
          
        })
                alert.addAction(createAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {( alert : UIAlertAction) -> Void in
        })
       
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)

       
    }
   
    var checkForDuplicates = [String]()
    func pull () {
        var reloadTableView = false
        let ref = Database.database().reference()
        if let imr = imprt {
            ref.child("Binders").child(imr).child("Page").queryOrderedByKey().observe(.value, with: { (snapshot) in
                print("hito")
                if let inside = snapshot.value as? [String : AnyObject] {
                    for (_, val) in inside {
                        let newp = Page()
                        if let titlie = val["title"] as? String, let poster = val["poster"] as? String, let key = val["key"] as? String, let timer = val["timeStamp"] as? Int {
                            newp.title = titlie
                            newp.creatorName = poster
                            newp.key = key
                            newp.timeStamp = timer
                            if self.checkForDuplicates.contains(key) {
                                print("page already there")
                            }
                            else {
                                self.pages.append(newp)
                                reloadTableView = true
                                self.checkForDuplicates.append(key)
                            }
                        }
                    }
                
                    
                    
                }
                DispatchQueue.main.async {
                    if reloadTableView == true {
                    self.binderTableView.reloadData()
                    }
                }
                
            }, withCancel: nil)

        }
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = .white
        navigationItem.backBarButtonItem = backButton

        if segue.identifier == "seguePage" {
            let destVC = segue.destination as! PageViewController
            var indexPath = binderTableView.indexPathForSelectedRow!
            destVC.string = pages[indexPath.section].title
            destVC.key = pages[indexPath.section].key
            if let keyp = imprt {
                destVC.binderKey = keyp
            }
            if let usn = username {
                destVC.currentUn = usn
            }
        }
        
        
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "seguePage" {
            var indexPath = binderTableView.indexPathForSelectedRow!
            if let key = pages[indexPath.section].key {
                print(key)
                return true
            }
          
        }
        return false
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        binderTableView.deselectRow(at: indexPath, animated: true)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
            if let binderKel = imprt {
                let ref = Database.database().reference().child("Binders").child(binderKel).child("Page")
                ref.removeAllObservers()
                print("observer page off")
            }
    }
}
