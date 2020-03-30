//
//  SearchTableViewCell.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 6/18/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var minorLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var friendInBinder: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
