//
//  WatchItemDetailViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/24/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class WatchItemDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var contentData = Dictionary<String, String>()
    var commentList: [[String: String]] = []
    
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
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return commentList.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("WatchItemDetailContentCell") as! WatchItemDetailContentTableViewCell
            let profileImageURL = contentData["profileImageURL"]
            let name = contentData["name"]
            let actionContent = contentData["actionContent"]
            let status = contentData["status"]
            cell.profileImageView.sd_setImageWithURL(NSURL(string: profileImageURL!))
            cell.nameLabel.text = name
            cell.contentLabel.text = actionContent
            cell.statusLabel.text = status
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("WatchItemDetailCommentCell") as! WatchItemDetailCommentTableViewCell
            return cell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Comments"
        } else {
            return nil
        }
    }

}
