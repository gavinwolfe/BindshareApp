//
//  viewImageObj.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 7/7/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit

class viewImageObj: NSObject {

    func viewPres () {
        if let window = UIApplication.shared.keyWindow {
            let view = UIView(frame: window.frame)
            view.backgroundColor = .black
            window.addSubview(view)
        }
    }
}
