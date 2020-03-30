//
//  SignUpFirstViewController.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 7/28/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class SignUpFirstViewController: UIViewController, UITextFieldDelegate {

    
    
    override func viewWillAppear(_ animated: Bool) {
        textFieldName.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        nameLabel.frame = CGRect(x: 15, y: 100, width: 100, height: 20)
        textFieldName.frame = CGRect(x: 15, y: 130, width: self.view.frame.width - 30, height: 30)
        
        usernameLabel.frame = CGRect(x: 15, y: 180, width: 100, height: 20)
        usernameTextField.frame = CGRect(x: 15, y: 210, width: self.view.frame.width - 30, height: 30)
        nextButton.frame = CGRect(x: 0, y: self.view.frame.height - 60, width: self.view.frame.width, height: 60)
        
        let myColor = UIColor.darkGray
        self.textFieldName.layer.borderWidth = 1.0
        self.textFieldName.layer.borderColor = myColor.cgColor
        self.usernameTextField.layer.borderWidth = 1.0
        self.usernameTextField.layer.borderColor = myColor.cgColor
        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textFieldName.text != "" && usernameTextField.text! == ""  {
            if let text = textFieldName.text {
                if text.characters.count > 2 {
                      usernameTextField.becomeFirstResponder()
                }
            }
        } else {
        textField.resignFirstResponder()
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= 20 // Bool
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        if textFieldName.isFirstResponder == true {
            textFieldName.resignFirstResponder()
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var textFieldName: UITextField!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    
    @IBOutlet weak var nextButton: UIButton!
   
    var boolIs: Bool?
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        if textFieldName.text != "" {
            if (textFieldName.text?.characters.count)! < 3 {
                self.textFieldName.text = ""
            }
            let string = textFieldName.text!.lowercased()
            if  string.contains("-") || string.contains("_") || string.contains(":") || string.contains(";") || string.contains(")") || string.contains("$") || string.contains("&") || string.contains("@") || string.contains("(") || string.contains("shit") || string.contains("fuck") || string.contains("suck") || string.contains("ass")  || string.contains("dick") || string.contains("cock") || string.contains("penis") || string.contains("lick") || string.contains("vagina") || string.contains("pussy") || string.contains("fag") || string.contains("tit") || string.contains("boob") || string.contains("hole") || string.contains("butt") || string.contains("anal") || string.contains("milf") || string.contains("cunt") || string.contains("/")  || string.contains("\\") || string.contains("\"") || string.contains(".") || string.contains(",") || string.contains("?") || string.contains("'") || string.contains("!") || string.contains("[") || string.contains("]") || string.contains("{") || string.contains("}") || string.contains("#") || string.contains("%") || string.contains("^") || string.contains("*") || string.contains("+") || string.contains("=") || string.contains("|") || string.contains("~") || string.contains("<") || string.contains(">") || string.contains("£") || string.contains("€") || string.contains("¥") || string.contains("•") || string.contains("nigger")
                || string.contains("beaner") || string.contains("coon") || string.contains("spic") || string.contains("wetback") || string.contains("chink") || string.contains("gook") || string.contains("porn") || string.contains("twat") || string.contains("crow")  || string.contains("darkie")  || string.contains("bitch") || string.contains("god hates") || string.contains("  ")
            {
                
                let alert = UIAlertController(title: "Only letters allowed, with no spaces, and no profanity", message: "Please use only letters without any profanity", preferredStyle: .alert)
                let cancelerg = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                alert.addAction(cancelerg)
                self.present(alert, animated: true, completion: nil)
                self.textFieldName.text = ""
            }
           
        }
        
        
        
        
        self.boolIs = true
        if usernameTextField.text != "" {
            if (usernameTextField.text?.characters.count)! < 3 {
                self.usernameTextField.text = ""
            }
            let string = usernameTextField.text!.lowercased()
            if string.contains(" ")  || string.contains(":") || string.contains(";") || string.contains(")") || string.contains("$") || string.contains("&") || string.contains("@") || string.contains("(") || string.contains("shit") || string.contains("fuck") || string.contains("suck") || string.contains("ass")  || string.contains("dick") || string.contains("cock") || string.contains("penis") || string.contains("lick") || string.contains("vagina") || string.contains("pussy") || string.contains("fag") || string.contains("tit") || string.contains("boob") || string.contains("hole") || string.contains("butt") || string.contains("anal") || string.contains("milf") || string.contains("cunt") || string.contains("/")  || string.contains("\\") || string.contains("\"") || string.contains(".") || string.contains(",") || string.contains("?") || string.contains("'") || string.contains("!") || string.contains("[") || string.contains("]") || string.contains("{") || string.contains("}") || string.contains("#") || string.contains("%") || string.contains("^") || string.contains("*") || string.contains("+") || string.contains("=") || string.contains("|") || string.contains("~") || string.contains("<") || string.contains(">") || string.contains("£") || string.contains("€") || string.contains("¥") || string.contains("•") || string.contains("nigger") || string.contains("nigga")
                || string.contains("beaner") || string.contains("coon") || string.contains("spic") || string.contains("wetback") || string.contains("chink") || string.contains("gook") || string.contains("porn") || string.contains("twat") || string.contains("crow")  || string.contains("darkie")  || string.contains("bitch") || string.contains("god hates"){

                let alert = UIAlertController(title: "Only letters and numbers allowed, with no spaces, and no profanity", message: "Please use only letters and numbers without any profanity", preferredStyle: .alert)
                let cancelerg = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                alert.addAction(cancelerg)
                self.present(alert, animated: true, completion: nil)
                usernameTextField.text = ""
            }
            else {

                let ref = Database.database().reference()
            ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                if let useris = snapshot.value as? [String: AnyObject] {
                    let usernam1 = self.usernameTextField.text?.lowercased()
                    for (_,value) in useris {
                        
                        if let usernamees = value["Username"] as? String {
                            print(usernamees)
                            print(usernam1!)
                            if usernamees == usernam1! {
                                let alert = UIAlertController(title: "Username is taken", message: "Another user already has this username, please create a new one", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                                
                                self.present(alert, animated: true, completion: nil)
                                self.usernameTextField.text = ""
                                self.boolIs = true
                                
                            }
                            else {
                                self.nextButton.isEnabled = true
                                self.boolIs = false
                            }
                        }
                    }
                }
            })
        }
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if usernameTextField.text != "", textFieldName.text != "" {
            if boolIs == true {
                return false
            }
            print("empty")
            return true
        }
        
        return false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = .black
        navigationItem.backBarButtonItem = backButton
        if segue.identifier == "segueSignUp" {
            let destVc = segue.destination as! SignUpViewController
            if textFieldName.text != "", usernameTextField.text != "" {
            destVc.name = textFieldName.text
                destVc.username = usernameTextField.text
            }
        }
    }
}
