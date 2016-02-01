//
//  WatchTableViewCell.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/20/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class WatchTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
