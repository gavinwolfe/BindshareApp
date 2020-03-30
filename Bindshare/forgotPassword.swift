//
//  randomClass.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 9/15/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import Foundation
import Firebase

class forgotPassword: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var testfieldEmail: UITextField!
    @IBOutlet weak var emailToLabel: UILabel!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true 
    }
    
    override func viewDidLoad() {
        sendEmail.layer.cornerRadius = 12.0
        sendEmail.clipsToBounds = true
        
        
        cancelButton.frame = CGRect(x: 10, y: 10, width: 60, height: 60)
        forgotPasswordLabel.frame = CGRect(x: 70, y: 50, width: self.view.frame.width - 140, height: 30)
        backView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 120)
        emailToLabel.frame = CGRect(x: 15, y: self.view.frame.height / 4, width: self.view.frame.width - 30, height: 20)
        testfieldEmail.frame = CGRect(x: 15, y: self.view.frame.height / 3.2, width: self.view.frame.width - 30, height: 30)
        sendEmail.frame = CGRect(x: 15, y: self.view.frame.height - 60, width: self.view.frame.width - 30, height: 40)
        
    }
    @IBOutlet weak var sendEmail: UIButton!
    
    @IBAction func sendAction(_ sender: Any) {
        if testfieldEmail.text != "" {
            Auth.auth().sendPasswordReset(withEmail: testfieldEmail.text!, completion: { (error) in
                if error == nil {
                    let emailText = self.testfieldEmail.text!
                    let alert = UIAlertController(title: "Email sent to \(emailText)", message: "Please check your email, An email containing information on how to reset your password has been sent to the entered email", preferredStyle: .alert)
                    let oky = UIAlertAction(title: "Okay", style: .cancel, handler: { (action : UIAlertAction!) -> Void in
                        self.dismiss(animated: true, completion: nil)
                    })
                    alert.addAction(oky)
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    let alertCo = UIAlertController(title: "There is no user corresponding to this email", message: "Please enter the email of your registered account, or create an account by going back to sign up", preferredStyle: .alert)
                    let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                    alertCo.addAction(okay)
                    self.testfieldEmail.text = ""
                    self.present(alertCo, animated: true, completion: nil)
                }
            })
        }
    }
    
}
