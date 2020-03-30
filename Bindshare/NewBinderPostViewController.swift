//
//  NewBinderPostViewController.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 6/30/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit

class NewPageViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var textViewPage: UITextView!
    
    @IBOutlet weak var takePhotoAction: UIButton!
    @IBOutlet weak var labelTakePhoto: UILabel!
    
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var imageViewField: UIImageView!
       @IBOutlet weak var titleTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController?.navigationBar.tintColor = .black
       
        
        // Do any additional setup after loading the view.
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        return numberOfChars < 290
    }
    
    
   
    
        @IBAction func buttonTakePhotoAction(_ sender: Any) {
        let alert = UIAlertController(title: "Im Working on it, Gosh!", message: "We have our brightest chimpanzees working to fix your problem", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "You will take a photo", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true 
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
