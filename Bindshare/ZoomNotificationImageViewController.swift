//
//  ZoomNotificationImageViewController.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 7/17/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit

// selected message zoom imgage if tnere is one 

class ZoomNotificationImageViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollViewZoom: UIScrollView!
    var image: UIImage?
    @IBOutlet weak var imageViewZoom: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.white

        self.scrollViewZoom.maximumZoomScale = 6.0
        self.scrollViewZoom.minimumZoomScale = 1.0
        
        if let image = image {
            imageViewZoom.image = image
        }
        
        
        // Do any additional setup after loading the view.
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageViewZoom
    }
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
