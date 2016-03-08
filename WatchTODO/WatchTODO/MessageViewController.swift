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
    func toSetTabBage(number: Int)
}

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, APNSNotificationDelegate, CommentAPIHelperDelegate, UpdateAPIHelperDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var messages: [[String: AnyObject]] = []
    
    var delegate: MessageVCDelegate?
    
    var presented: Bool = false
    
    let actionItemModelHelper = ActionItemModelHelper(me: false)
    
    var actionContentDict = [String: String]()
    
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
        self.actionContentDict = self.actionItemModelHelper.getAllActionContentDict()
        self.messages = SortMessagesHelper().getTimeSortedMessages()
        self.tableView.reloadData()
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
            let cell = tableView.dequeueReusableCellWithIdentifier("MessageNewMessageCell") as! NewMessageTableViewCell
            let commentDict = messageDict["latestComment"] as! [String: AnyObject]
            let commentMessage: String = commentDict["message"] as! String
            let actionId: String = commentDict["actionId"] as! String
            let timestamp: Int = commentDict["timestamp"] as! Int
            let nickname: String = commentDict["nickname"] as! String
            let unreadCount: String = commentDict["unreadCount"] as! String
            cell.messageLabel.text = commentMessage
            if let content = actionContentDict[actionId] {
                cell.contentLabel.text = content
            } else {
                cell.contentLabel.text = ""
            }
            cell.timeLabel.text = DateTimeHelper().convertEpochToHumanFriendlyTime(timestamp)
            cell.nameLabel.text = nickname
            if unreadCount == "0" {
                cell.iconImageView.image = UIImage(named: "new_message")
            } else {
                cell.iconImageView.image = UIImage(named: "new_message_unread")
            }
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
        let messageDict = self.messages[indexPath.row]
        let type: String = messageDict["type"] as! String
        if type == "comment" {
            return 80
        } else if type == "friend" {
            return 60
        } else {
            return 60
        }
    }
    
    func didReceiveCommentNotification(actionId: String) {
        let commentAPIHelper = CommentAPIHelper()
        commentAPIHelper.delegate = self
        commentAPIHelper.getCommentList(actionId)
    }
    
    func didReceiveFriendNotification(subtype: String) {
        let updateHelperAPI = UpdateAPIHelper()
        updateHelperAPI.delegate = self
        updateHelperAPI.getUpdatedInfo()
    }
    
    func didAppBecomeActive() {
        let updateHelperAPI = UpdateAPIHelper()
        updateHelperAPI.delegate = self
        updateHelperAPI.getUpdatedInfo()
        
    }
    
    func didGetCommentList() {
        print("message did get comment list")
        if !presented {
            self.delegate?.toSetTabBage(1)
        } else {
            self.reloadTable()
        }
    }
    
    func didCommentsUpdated(number: Int) {
        if presented {
            self.reloadTable()
        } else {
            self.delegate?.toSetTabBage(number)
        }
    }
    
    func didFriendsUpdated() {
        if presented {
            self.reloadTable()
        } else {
            self.delegate?.toSetTabBage(1)
        }
    }

}
