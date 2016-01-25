//
//  WatchViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/16/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import SDWebImage
import CNPPopupController

class WatchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedContentData: [String: String]!
    
    var popupController: CNPPopupController = CNPPopupController()
    
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
            cell.commentButton.addTarget(self, action: Selector("commentButtonOnClick:"), forControlEvents: .TouchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("WatchNoCommentCell") as! WatchNoCommentTableViewCell
            cell.profileImageView.sd_setImageWithURL(NSURL(string: profileImageURL!), placeholderImage: UIImage(named: ""))
            cell.nameLabel.text = name
            cell.actionContentLabel.text = actionContent
            cell.statusLabel.text = status
            cell.commentButton.addTarget(self, action: Selector("commentButtonOnClick:"), forControlEvents: .TouchUpInside)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedContentData = data[indexPath.row]
        self.performSegueWithIdentifier("WatchItemDetailSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "WatchItemDetailSegue" {
            let watchItemDetailVC = segue.destinationViewController as! WatchItemDetailViewController
            watchItemDetailVC.contentData = selectedContentData
        }
    }
    
    func commentButtonOnClick(sender: UIButton) {
        let cell = sender.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        self.showCommentPopupView(indexPath)
    }
    
    func showCommentPopupView(selectedIndexPath: NSIndexPath) {
        let commentView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 60))
        commentView.layer.borderColor = UIColor.lightGrayColor().CGColor
        commentView.layer.borderWidth = 2
        commentView.layer.cornerRadius = 5
        let commentTextView = UITextView(frame: CGRectMake(5, 5, 240, 50))
        commentView.addSubview(commentTextView)
        commentTextView.becomeFirstResponder()
        let button = CNPPopupButton(frame: CGRect(x: 0, y: 0, width: 160, height: 40))
        button.setTitle("Submit Comment", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
        button.backgroundColor = UIColor.init(colorLiteralRed: 0.46, green: 0.8, blue: 1.0, alpha: 1.0)
        button.layer.cornerRadius = 4;
        button.selectionHandler = { (CNPPopupButton button) -> Void in
            self.popupController.dismissPopupControllerAnimated(true)
            print("Block for button: \(button.titleLabel?.text)")
        }
        self.popupController = CNPPopupController(contents: [commentView, button])
        self.popupController.theme = CNPPopupTheme.defaultTheme()
        self.popupController.theme.popupStyle = .Centered
        self.popupController.presentPopupControllerAnimated(true)
    }

}
