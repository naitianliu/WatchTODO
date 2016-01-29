//
//  TodoActionItemTableViewCell.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/17/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class TodoActionItemTableViewCell: UITableViewCell {

    @IBOutlet weak var actionContentLabel: UILabel!
    @IBOutlet weak var extraInfoView: UIView!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var priorityView: UIView!
    @IBOutlet weak var dueLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
                
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
