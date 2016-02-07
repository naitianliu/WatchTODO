//
//  TodoUnfoldTableViewCell.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/27/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class TodoUnfoldTableViewCell: UITableViewCell {
    
    @IBOutlet weak var revokeButton: UIBarButtonItem!
    @IBOutlet weak var completeButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addWatcherButton: UIBarButtonItem!
    @IBOutlet weak var commentButton: UIBarButtonItem!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
