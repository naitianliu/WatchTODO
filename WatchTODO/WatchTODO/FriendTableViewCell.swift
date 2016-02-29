//
//  FriendTableViewCell.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 2/28/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var boxView: UIView!
    
    var status: String = "connected"
    
    let statusImageMap = [
        "connected": "friend-connected",
        "waiting": "friend-waiting"
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.boxView.layer.borderColor = const_ThemeColor.CGColor
        self.boxView.layer.borderWidth = 2
        self.boxView.layer.cornerRadius = 80
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        self.iconImageView.image = UIImage(named: statusImageMap[status]!)
        
        if status == "waiting" {
            self.boxView.layer.borderColor = UIColor.orangeColor().CGColor
        }
    }
}
