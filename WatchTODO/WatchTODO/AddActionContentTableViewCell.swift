//
//  AddActionContentTableViewCell.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/25/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import SZTextView

class AddActionContentTableViewCell: UITableViewCell {

    @IBOutlet weak var contentTextView: SZTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
