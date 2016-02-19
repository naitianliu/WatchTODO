//
//  MessageViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 2/17/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

protocol MessageVCDelegate {
    func toCleanTabBadge()
    func toSetTabBage()
}

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, APNSNotificationDelegate, CommentAPIHelperDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var messages: [[String: AnyObject]] = []
    
    var delegate: MessageVCDelegate?
    
    var presented: Bool = false
    
    let actionItemModelHelper = ActionItemModelHelper(me: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.tableFooterView = UIView()
        
        appDelegate.apnsDelegate = self
        
        self.reloadTable()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        presented = true
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.apnsDelegate = self
        self.reloadTable()
        self.delegate?.toCleanTabBadge()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        presented = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTable() {
        self.messages = SortMessagesHelper().getUnsortedCommentMessages()
        if FriendModelHelper().getPendingFriendList().count > 0 {
            let friendMessage: [String: AnyObject] = ["type": "friend", "message": "Friend Invitation Updated"]
            self.messages.insert(friendMessage, atIndex: 0)
        }
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let messageDict = self.messages[indexPath.row]
        let type: String = messageDict["type"] as! String
        if type == "comment" {
            let cell = tableView.dequeueReusableCellWithIdentifier("MessageNewMessageCell")!
            let commentDict = messageDict["latestComment"] as! [String: String]
            let commentMessage = commentDict["message"]!
            let actionId: String = commentDict["actionId"]!
            cell.textLabel?.text = commentMessage
            cell.detailTextLabel?.text = self.actionItemModelHelper.getActionContentByActionId(actionId)
            return cell
        } else if type == "friend" {
            let cell = tableView.dequeueReusableCellWithIdentifier("MessageAddFriendCell")!
            let message = messageDict["message"] as! String
            cell.textLabel?.text = message
            return cell
        } else {
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let messageDict = self.messages[indexPath.row]
        let type: String = messageDict["type"] as! String
        if type == "comment" {
            let actionId: String = messageDict["actionId"] as! String
            let todoListStoryboard = UIStoryboard(name: "MyTodoList", bundle: nil)
            let commentsVC = todoListStoryboard.instantiateViewControllerWithIdentifier("CommentsViewController") as! CommentsViewController
            commentsVC.actionId = actionId
            self.navigationController?.pushViewController(commentsVC, animated: true)
        } else if type == "friend" {
            let watchStoryboard = UIStoryboard(name: "Watch", bundle: nil)
            let friendVC = watchStoryboard.instantiateViewControllerWithIdentifier("FriendsViewController") as! FriendsViewController
            self.navigationController?.pushViewController(friendVC, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func didReceiveCommentNotification(actionId: String) {
        let commentAPIHelper = CommentAPIHelper()
        commentAPIHelper.delegate = self
        commentAPIHelper.getCommentList(actionId)
    }
    
    func didReceiveFriendNotification(subtype: String) {
        var message = ""
        if subtype == "send" {
            message = "You received a friend invitation."
        } else {
            message = "You invitation has been accepted."
        }
        let friendMessage = ["type": "friend", "message": message]
        self.messages.insert(friendMessage, atIndex: 0)
        if !presented {
            self.delegate?.toSetTabBage()
        } else {
            self.tableView.reloadData()
        }
    }
    
    func didGetCommentList() {
        print("message did get comment list")
        if !presented {
            self.delegate?.toSetTabBage()
        } else {
            self.reloadTable()
        }
    }

}
