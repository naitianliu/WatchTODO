//
//  WatchByFriendTableViewCell.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 2/28/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class WatchByFriendTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var actionContentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priorityView: UIView!
    
    var priority: Int = 4
    var status: Int = 4
    
    let statusImageMap = [
        "0": "update-create",
        "1": "update-progress",
        "2": "update-complete"
    ]
    
    let priorityColorMap = [
        "1": UIColor.redColor(),
        "2": UIColor.orangeColor(),
        "3": UIColor.yellowColor(),
        "4": UIColor.lightGrayColor(),
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        self.iconImageView.image = UIImage(named: statusImageMap[String(status)]!)
        self.priorityView.backgroundColor = priorityColorMap[String(priority)]
    }

}
