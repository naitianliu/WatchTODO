//
//  WatchViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/16/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import SDWebImage

class WatchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let data = [
        [
            "profileImageURL": "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcSLufx6iMI4Pehvf4-kHOi8aktMVdCiPAkJJyPd0RFRu2JEtcBp",
            "name": "Bill Gates",
            "actionContent": "I know this is a noob question but ...I have these labels on a tableview, ... The most flexible approach to add padding to UILabel is to subclass",
            "status": "WorkInProgress",
            "commentProfileImageURL": "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcSLufx6iMI4Pehvf4-kHOi8aktMVdCiPAkJJyPd0RFRu2JEtcBp",
            "commentTime": "2 hours ago",
            "commentMessage": "I'm looking to set the left inset/margin of a UILabel and can't find a method to do so. The label has a background set so just changing its origin won't do the trick."
        ],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let rowDict = data[0]
        let profileImageURL = rowDict["profileImageURL"]
        let name = rowDict["name"]
        let actionContent = rowDict["actionContent"]
        let status = rowDict["status"]
        let commentProfileImageURL = rowDict["commentProfileImageURL"]
        let commentTime = rowDict["commentTime"]
        let commentMessage = rowDict["commentMessage"]
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("WatchCell") as! WatchTableViewCell
            cell.profileImageView.sd_setImageWithURL(NSURL(string: profileImageURL!), placeholderImage: UIImage(named: ""))
            cell.nameLabel.text = name
            cell.actionContentLabel.text = actionContent
            cell.statusLabel.text = status
            cell.commentProfileImageView.sd_setImageWithURL(NSURL(string: commentProfileImageURL!), placeholderImage: UIImage(named: ""))
            cell.commentTimeLabel.text = commentTime
            cell.commentNameLabel.text = "Naitian Liu"
            cell.commentMessageLabel.text = commentMessage
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("WatchNoCommentCell") as! WatchNoCommentTableViewCell
            cell.profileImageView.sd_setImageWithURL(NSURL(string: profileImageURL!), placeholderImage: UIImage(named: ""))
            cell.nameLabel.text = name
            cell.actionContentLabel.text = actionContent
            cell.statusLabel.text = status
            return cell
        }
    }

}
