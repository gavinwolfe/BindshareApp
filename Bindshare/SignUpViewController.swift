//
//  SignUpViewController.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 7/28/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase


class SignUpViewController: UIViewController, UITextFieldDelegate {

    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.becomeFirstResponder()
    }
    var name: String?
    var username: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
        // Do any additional setup after loading the view.
        let myColor = UIColor.darkGray
        self.emailTextField.layer.borderWidth = 1.0
        self.emailTextField.layer.borderColor = myColor.cgColor
        self.passwordField.layer.borderWidth = 1.0
        self.passwordField.layer.borderColor = myColor.cgColor
        self.reenterField.layer.borderColor = myColor.cgColor
        self.reenterField.layer.borderWidth = 1.0 
        
        emailLabel.frame = CGRect(x: 100, y: 90, width: self.view.frame.width - 200, height: 20)
        emailTextField.frame = CGRect(x: 15, y: 120, width: self.view.frame.width - 30, height: 30)
        passwordLabel.frame = CGRect(x: 100, y: 160, width: self.view.frame.width - 200, height: 20)
        passwordField.frame = CGRect(x: 15, y: 190, width: self.view.frame.width - 30, height: 30)
        reEnterPasswordLabel.frame = CGRect(x: 50, y: 230, width: self.view.frame.width - 100, height: 20)
        reenterField.frame = CGRect(x: 15, y: 260, width: self.view.frame.width - 30, height: 30)
        
        
        signUpButton.frame = CGRect(x: 0, y: self.view.frame.height - 60, width: self.view.frame.width, height: 60)
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= 50 // Bool
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if emailTextField.text != "" && passwordField.text == "" {
            passwordField.becomeFirstResponder()
        }
        if emailTextField.text != "" && passwordField.text != "" && reenterField.text == "" {
            reenterField.becomeFirstResponder()
        }
        else {
        textField.resignFirstResponder()
        }
        return true
    }
    @IBOutlet weak var emailLabel: UILabel!
 
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var reEnterPasswordLabel: UILabel!
    
    @IBOutlet weak var reenterField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBAction func signUpAction(_ sender: Any) {
            guard emailTextField.text != "", passwordField.text != "", name != "", username != "" else { return }
        if reenterField.text == passwordField.text {
            
            if let namer = name {
                if let usernm = username {
                    signUpButton.isHidden = true
                    self.navigationItem.leftBarButtonItem?.isEnabled = false
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordField.text!, completion: { (user, error) in
                if let error = error {
                    let alert = UIAlertController(title: error.localizedDescription, message: "Please enter a different email", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                    alert.addAction(cancel)
                    self.signUpButton.isHidden = false
                    self.navigationItem.leftBarButtonItem?.isEnabled = true 
                    self.present(alert, animated: true, completion: nil)
                }
                if let user = user {
                    let ref = Database.database().reference()
                    let userInfo : [String : Any] = ["uid": user.uid as String, "Full Name": namer, "Username": usernm]
                    ref.child("users").child(user.uid).setValue(userInfo)
                    let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                    
                    
                    changeRequest.displayName = namer
                    changeRequest.commitChanges(completion: nil)
                    print(changeRequest.displayName!)
                    print(user)
                    self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)            
                    
                }
            })
        }
            }
        }
        else {
            let alerto = UIAlertController(title: "Password and confirm password are not equal", message: "Please re enter a password and confirm it", preferredStyle: .alert)
            let cancelerg = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alerto.addAction(cancelerg)
            self.present(alerto, animated: true, completion: nil)

        }
   
        
    }
}
