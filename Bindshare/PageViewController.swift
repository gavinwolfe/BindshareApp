//
//  PageViewController.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 7/6/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//  \\  //  \\  //  \\

import UIKit
import Firebase

class PageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITabBarDelegate {

    // I would just like to say that the code for seguing the image to the zoom viewcontroller is very weird and works quite odd, but it is because I used boolean to be set to true before seguing. I know there are very simple and cleaner ways of going about this, but I honestly wanted to make as much of the app as i could on my own, and that is why it does not look the best, but I believe it will work for now. As I get better and in the next version, I plan on fixing things like this. Learning was important to me with this app, so you may see many examples of me doing things the way I wanted to. Thanks for understanding, any feedback is great!
    
    //current caching
    let cache = NSCache<AnyObject, AnyObject>()
    var anyoneCanPost: String? 
    var pagers = [imagePage]()
    
    let session = URLSession.shared
    //dummy image array (filler for first image)
    var imaqes = ["feb"] //<- this image does not exist
    
    let loader = UIActivityIndicatorView()
    
    @IBOutlet weak var collectionViewPage: UICollectionView!
    var label = UILabel()
    var nameLabel = UILabel()
  
    var string: String?
    var currentUn: String?
    var isPublic: String?
    

    let gestureView = UITapGestureRecognizer()
    var key: String?
    var binderKey: String?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if let string = string {
            navigationItem.title = string
        }
        self.navigationController?.navigationBar.tintColor = UIColor.white

        print("Posts Viewcontroller")
        pullname()
        // pull the posts from firebase
        pull()
        
        
        loader.frame = CGRect(x: self.view.frame.width / 2.25, y: self.view.frame.height / 2, width: 30, height: 30)
        loader.color = UIColor.white
        loader.startAnimating()
        
        view.addSubview(loader)

       
        collectionViewPage.clipsToBounds = false 
        collectionViewPage.frame = CGRect(x: 0, y: 130, width: self.view.frame.width, height: self.view.frame.height - 200)
        
        let memoryCapacity = 500 * 1024 * 1024
        let diskCapacity = 500 * 1024 * 1024
        let urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "myDiskPath")
        URLCache.shared = urlCache

        label.frame = CGRect(x: 5, y: 50, width: self.view.frame.width - 20, height: 100)
        label.numberOfLines = 5
        if isPublic != "itsPublic" {
            
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapPlus)), animated: true)
        }
        else if isPublic == "itsPublic" {
            if let anyoner = anyoneCanPost {
                
                self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapPlus)), animated: true)
                print(anyoner)
            }
        }
        booli = false
        label.textColor = .white
        nameLabel.frame = CGRect(x: 5, y: self.view.frame.height - 70, width: 150, height: 20)
        
     
        self.nameLabel.font = UIFont(name: "Didot", size: 12)
        self.label.font = UIFont(name: "Trebuchet MS", size: 11)

        nameLabel.textColor = .white
        collectionViewPage.delegate = self
        collectionViewPage.dataSource = self
        
       
        view.addSubview(label)
        view.addSubview(nameLabel)
        
        // Do any additional setup after loading the view.
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionViewPage.frame.width, height: collectionViewPage.frame.height)
    }
    
    //view dissappear (removing any observers)
    override func viewWillDisappear(_ animated: Bool) {
        session.finishTasksAndInvalidate()
        if anotherBool == false {
        anotherBool = true
        }
        else {
            if let binderKep = key {
                if let pageKey = key {
                    let ref = Database.database().reference().child("Binders").child(binderKep).child("Page").child(pageKey).child("Posts")
                    ref.removeAllObservers()
                    print("removed post observer")
        }
        }
        }
    }
   
    
    
    var booly: Bool?
    var duplicatorCheck = [String]()

       func pull () {
       
        let ref = Database.database().reference()
        if let bindKey = binderKey {
            if let keyt = key {
                ref.child("Binders").child(bindKey).child("Page").child(keyt).child("Posts").queryOrderedByKey().observe(.value, with: { snapshot in
                    
                    if let posts = snapshot.value as? [String : AnyObject] {
                        for (_, val) in posts {
                            let imagepst = imagePage()
                            if  let postUrl = val["url"] as? String {
                            if let creatorUsername = val["creatorUsername"] as? String, let creatorName = val["creatorName"] as? String, let descript = val["description"] as? String, let postId = val["key"] as? String, let timeStamp = val["timeStamp"] as? Int, let creatorID = val["userID"] as? String {
                                
                                imagepst.creatorName = creatorName
                                imagepst.creatorUsername = creatorUsername
                                imagepst.descript = descript
                                imagepst.key = postId
                                imagepst.timeStamp = timeStamp
                                imagepst.uid = creatorID
                                imagepst.url = postUrl
                                
                                if self.duplicatorCheck.contains(postId) {
                                    print("already")
                                }
                                else {
                                self.duplicatorCheck.append(postId)
                                self.pagers.append(imagepst)
                                
                                print("a post was added")
                                }
                            }
                            }
                            if let postUrl = val["urlWebsite"] as? String {
                                if let creatorUsername = val["creatorUsername"] as? String, let creatorName = val["creatorName"] as? String, let descript = val["description"] as? String, let postId = val["key"] as? String, let timeStamp = val["timeStamp"] as? Int, let creatorID = val["userID"] as? String {
                                    
                                    imagepst.creatorName = creatorName
                                    imagepst.creatorUsername = creatorUsername
                                    imagepst.descript = descript
                                    imagepst.key = postId
                                    imagepst.timeStamp = timeStamp
                                    imagepst.uid = creatorID
                                    imagepst.websiteUrl = postUrl
                                    
                                    if self.duplicatorCheck.contains(postId) {
                                        print("already")
                                    }
                                    else {
                                        self.duplicatorCheck.append(postId)
                                        self.pagers.append(imagepst)
                                        
                                        print("a post was added")
                                    }
                                }
                            }
                     
                        }
                         self.collectionViewPage.reloadData()
                     
                    }
                    else {
                        let aleerrt = UIAlertController(title: "There are no images on this page", message: "If you were added to this Binder, Click the plus sign in the top right corner to add a subpage. Otherwise, This page has no photos in it or was just deleted", preferredStyle: .alert)
                        let acttionn = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                        aleerrt.addAction(acttionn)
                        self.present(aleerrt, animated: true, completion: nil)
                        
                        self.loader.stopAnimating()
                    }
                   
                })
            }
        }
        ref.removeAllObservers()
        }
    
    
    
    @objc func tapPlus() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "underPage") as! UnderPagePostViewController
        if let bindkev = binderKey {
            if let kev = key {
                if let currnt = usernamer {
                    
                    anotherBool = false
            vc.binderkey = bindkev
                vc.key = kev
                vc.currentUsernm = currnt
                    self.present(vc, animated: true , completion: nil)
        }
        }
        }
            }
    
    // collection view below
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
          let cell = collectionViewPage.dequeueReusableCell(withReuseIdentifier: "subPageCell", for: indexPath) as! PageCollectionViewCell
        cell.imageViewPage.layer.cornerRadius = 8.0
        cell.imageViewPage.clipsToBounds = true
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if pagers.count != 0 {
            pagers.sort { $1.timeStamp < $0.timeStamp }
        self.label.text = pagers[0].descript
            self.nameLabel.text = pagers[0].creatorName
            
        }
     
        return pagers.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewPage.dequeueReusableCell(withReuseIdentifier: "subPageCell", for: indexPath) as! PageCollectionViewCell
        
        cell.imageViewPage.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)

        cell.backGroundView.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
        cell.imageViewPage.image = UIImage(named: imaqes[0])
       
       
        
        if pagers.count != 0 {
            if let post = pagers[indexPath.row].url {
                let url = URL(string: post)
                cell.imageDoc.image = nil
                cell.labelDoc.text = nil
                if let img = cache.object(forKey: post as AnyObject) {
                    cell.imageViewPage.image = img as? UIImage
                }
                else {
                    self.session.dataTask(with: url!, completionHandler: { (data, response, error) in
                        if let errer = error {
                            print(errer.localizedDescription)
                        }
                        DispatchQueue.main.async {
                            if data != nil {
                                cell.imageViewPage.image = UIImage(data: data!)
                                self.cache.setObject(UIImage(data: data!)!, forKey: post as AnyObject)
                                self.loader.stopAnimating()
                            }
                        }
                    }).resume()
                }
            }
           else if let urlWeb = pagers[indexPath.row].websiteUrl {
                print(urlWeb)
               
                if cell.imageViewPage.image == nil {
                cell.labelDoc.frame = CGRect(x: 50, y: cell.frame.height / 3.2, width: cell.frame.width - 100, height: 30)
                cell.labelDoc.textAlignment = .center
               cell.labelDoc.textColor = .white
               cell.labelDoc.text = "Tap to view document"
                cell.imageDoc.frame = CGRect(x: cell.frame.width / 2.3, y: cell.frame.height / 2.5, width: 50, height: 50)
                cell.imageDoc.image = UIImage(named: "page")
                self.loader.stopAnimating()
            }
            }
        }
        cell.imageViewPage.layer.cornerRadius = 8.0
        cell.imageViewPage.clipsToBounds = true
       
        session.finishTasksAndInvalidate()
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        cache.removeAllObjects()
        session.finishTasksAndInvalidate()
    }
    
    var usernamer: String?
    func pullname () {
        if Auth.auth().currentUser?.uid != nil {
            
            let ref = Database.database().reference()
            
            if let uid = Auth.auth().currentUser?.uid {
            ref.child("users").child(uid).child("Username").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                self.usernamer = snapshot.value as? String
            })
            }
        }
    }
    
    
    
   // all of this next code is for seguing the selected image to the next viewcontroller
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = collectionViewPage.contentOffset
        visibleRect.size = collectionViewPage.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX - 1, y: visibleRect.midY - 1)
        let visibli: NSIndexPath = collectionViewPage.indexPathForItem(at: visiblePoint)! as IndexPath as NSIndexPath
        indexiPat = visibli as IndexPath
        print(visibli.row)
        if pagers.count != 0 {
            label.text = pagers[visibli.row].descript
            nameLabel.text = pagers[visibli.row].creatorName
        }
    }

    
    
    var booli: Bool?

    var indexiPat : IndexPath?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       
        
        indexiPat = indexPath
        booli = true
        
    }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
            
            
        if segue.identifier == "segueZoomPage" {
            
           let destVc = segue.destination as! ImageSubPageViewController
            destVc.navigationController?.navigationBar.isHidden = true
            destVc.tabBarController?.tabBar.isHidden = true 
            if isPublic != "itsPublic" {
                destVc.privater = "private"
            }
            if let indexLow = indexiPat {
                destVc.key = pagers[indexLow.row].key
                if let bindk = binderKey {
                    destVc.binderKey = bindk
                }
                if let pagerit = key {
                    destVc.pageKey = pagerit
                }
                if let link = pagers[indexLow.row].websiteUrl {
                    destVc.urlString = link
                    
                } else {
                
                if let cellit = collectionViewPage.cellForItem(at: indexLow) as? PageCollectionViewCell {
           destVc.image = cellit.imageViewPage.image
                    
                    indexiPat = nil
                }
                else {
                    booli = false
                    
                }
                }
            }

        }
    }
    
    
    var anotherBool: Bool?
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        //if boolean from didselectrow is true, then segue, else dont 
        if identifier == "segueZoomPage" {
            
            
            anotherBool = false
        if booli == true {
        return true
        } else {
            return false
            }
        }
        return false
    }
    
    
}
