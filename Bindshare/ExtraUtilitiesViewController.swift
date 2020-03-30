//
//  ExtraUtilitiesViewController.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 9/15/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit
import Firebase

class ExtraUtilitiesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        bindshareLabel.frame = CGRect(x: 50, y: 30, width: self.view.frame.width - 100, height: 35)
        loginButton.frame = CGRect(x: 0, y: self.view.frame.height / 3, width: self.view.frame.width, height: self.view.frame.height / 8)
        signUpButton.frame = CGRect(x: 0, y: self.view.frame.height / 2.15, width: self.view.frame.width, height: self.view.frame.height / 8)
        
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var bindshareLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!

}
