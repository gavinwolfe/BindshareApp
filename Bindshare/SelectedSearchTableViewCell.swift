//
//  SelectedSearchTableViewCell.swift
//  Bindshare
//
//  Created by Gavin Wolfe on 6/28/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit

class SelectedSearchTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var labelMain: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
