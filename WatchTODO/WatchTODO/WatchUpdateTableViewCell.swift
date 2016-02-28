//
//  WatchUpdateTableViewCell.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 2/27/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class WatchUpdateTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var priorityView: UIView!
    @IBOutlet weak var actionContentLabel: UILabel!
    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var code: String = ""
    var priority: Int = 4
    
    let codeImageMap = [
        "1001": "update-create",
        "1002": "update-progress",
        "1003": "update-complete",
        "1004": "update-delete",
        "1005": "",
        "1011": "update-add_watcher",
        "1012": "update-remove_watcher",
    ]
    
    let codeColorMap = [
        "1001": UIColor.lightGrayColor(),
        "1002": UIColor.orangeColor(),
        "1003": UIColor.greenColor(),
        "1004": UIColor.redColor(),
        "1005": const_ThemeColor,
        "1011": const_ThemeColor,
        "1012": UIColor.redColor(),
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
        
        self.iconImageView.image = UIImage(named: codeImageMap[code]!)
        self.priorityView.backgroundColor = priorityColorMap[String(priority)]
        self.updateLabel.textColor = UIColor.lightGrayColor()
    }

}
