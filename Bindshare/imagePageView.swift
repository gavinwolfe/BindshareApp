//
//  imagePageView.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 7/7/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit

class imagePageView: UIView {
    
    let buttonBack: UIButton = {
       let button = UIButton()
       button.backgroundColor = .white
        button.addTarget(imagePageView.self, action: #selector(done), for: .touchUpInside)
        
        return button
    }()
    func done () {
        if let window = UIApplication.shared.keyWindow {
            window.removeFromSuperview()
        }

        }
    
    func viewPres () {
        if let window = UIApplication.shared.keyWindow {
            let view = UIView(frame: window.frame)
            view.backgroundColor = .black
            window.addSubview(view)
            view.addSubview(buttonBack)
            buttonBack.frame = CGRect(x: 10, y: 20, width: 50, height: 50)
            
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
