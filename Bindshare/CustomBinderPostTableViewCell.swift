//
//  CustomBinderPostTableViewCell.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 7/6/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit

class CustomBinderPostTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var imageCell: UIImageView!

   
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
