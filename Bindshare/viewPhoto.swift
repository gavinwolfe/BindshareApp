//
//  viewPhoto.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 7/7/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit

class viewPhoto: NSObject {

    

    
    func showPhotoView () {
        print("showing view")
        if let viewOver = UIApplication.shared.keyWindow {
            let view = UIView(frame: viewOver.frame)
            
            viewOver.addSubview(view)
            view.backgroundColor = UIColor.black
            let backButton = UIButton()
            backButton.frame = CGRect(x: 10, y: 20, width: 50, height: 50)
            backButton.backgroundColor = .white
           
            view.addSubview(backButton)
            
        }
    }
    
   
    
}
