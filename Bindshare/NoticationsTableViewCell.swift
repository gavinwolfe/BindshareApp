//
//  NoticationsTableViewCell.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 7/6/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit

class NoticationsTableViewCell: UITableViewCell {

    @IBOutlet weak var notSeenView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
