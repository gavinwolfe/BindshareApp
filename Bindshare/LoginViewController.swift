//
//  LoginViewController.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 6/23/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    override func viewWillAppear(_ animated: Bool) {
        emailField.becomeFirstResponder()
    }
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var dontHaveAccountBtn: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        loginLabel.frame = CGRect(x: 100, y: 20, width: self.view.frame.width - 200, height: 35)
        dividerView.frame = CGRect(x: 0, y: 65, width: self.view.frame.width, height: 5)
        dontHaveAccountBtn.frame = CGRect(x: 60, y: 80, width: self.view.frame.width - 120, height: 20)
        emailLabel.frame = CGRect(x: 100, y: self.view.frame.height / 4.35, width: self.view.frame.width - 200, height: 20)
        emailField.frame = CGRect(x: 30, y: self.view.frame.height / 3.7, width: self.view.frame.width - 60, height: 30)
        
        passwordLabel.frame = CGRect(x: 100, y: self.view.frame.height / 2.8, width: self.view.frame.width - 200, height: 20)
        passwordField.frame = CGRect(x: 30, y: self.view.frame.height / 2.5, width: self.view.frame.width - 60, height: 30)
        forgotPasswordButton.frame = CGRect(x: 90, y: self.view.frame.height / 2, width: self.view.frame.width - 180, height: 20)
        
        
        
        let myColor = UIColor.darkGray
        self.emailField.layer.borderWidth = 1.0
        self.emailField.layer.borderColor = myColor.cgColor
        self.passwordField.layer.borderWidth = 1.0
        self.passwordField.layer.borderColor = myColor.cgColor
        signInButton.frame = CGRect(x: 20, y: self.view.frame.height - 100, width: self.view.frame.width - 40, height: 60)
       signInButton.layer.cornerRadius = 24.0
        signInButton.clipsToBounds = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailField.text != "", passwordField.text == "" {
            passwordField.becomeFirstResponder()
        } else {
        textField.resignFirstResponder()
        }
        return true 
    }
    @IBAction func signIn(_ sender: Any) {
        
        
        
        guard emailField.text != "", passwordField.text != "" else { return }
        
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!, completion: {(logedIn, error) in
            if let error = error {
                print(error.localizedDescription)
                var problem = UIAlertController()
                problem = UIAlertController(title: "There was a problem", message: "The email or password is incorrect", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                problem.addAction(cancel)
                self.present(problem, animated: true, completion: nil)
            }
            else {
                 self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                           }
            })
      
            }

    @IBAction func actionDown(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        if emailField.isFirstResponder == true {
            emailField.resignFirstResponder()
        }
    }
  
    
}
