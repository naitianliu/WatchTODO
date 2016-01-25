//
//  WatchItemDetailCommentTableViewCell.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/24/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class WatchItemDetailCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let width: CGFloat = profileImageView.frame.width
        profileImageView.layer.cornerRadius = width / 2
        profileImageView.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
