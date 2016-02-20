//
//  CommentsViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/28/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, APNSNotificationDelegate, CommentAPIHelperDelegate {

    @IBOutlet weak var tableView: UITableView!
    let commentCellIdentifier1 = "ChatBubbleCell1"
    let commentCellIdentifier2 = "ChatBubbleCell2"
    let commentCellIdentifier3 = "ActionInfoCell"
    
    let myUsername = UserDefaultsHelper().getUsername()
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var sendButton: UIBarButtonItem!
    @IBOutlet weak var textFieldBarButtonItem: UIBarButtonItem!
    
    let kOFFSET_FOR_KEYBOARD:CGFloat = 20
    var keyboardFrame:CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var originViewFrame:CGRect!
    
    var keyboardShown: Bool = false
    
    var data: [[String: String]] = []
    var actionId: String = ""
    
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("comment view did load")
        
        self.navigationController?.navigationBar.translucent = false
        
        CommentModelHelper().setReadByActionId(actionId)
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShown:", name: UIKeyboardWillShowNotification, object: nil)
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard"))
        self.view.addGestureRecognizer(tap)
        
        self.appDelegate.apnsDelegate = self
        
        self.reloadTable()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.textFieldBarButtonItem.width = self.view.frame.width - self.sendButton.width - 80
        self.inputTextField.placeholder = "Comment"
        self.view.backgroundColor = const_CommentsBgColor
        self.toolbar.translucent = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.apnsDelegate = self
        self.originViewFrame = self.view.frame
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        appDelegate.apnsDelegate = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendMessageButtonOnClick(sender: AnyObject) {
        if keyboardShown {
            if let message = inputTextField.text {
                print(message)
                if message != "" {
                    CommentAPIHelper().addComment(nil, actionId: actionId, message: message)
                    data = CommentModelHelper().getCommentListByActionId(actionId)
                    self.reloadTable()
                    inputTextField.text = nil
                }
            }
        }
    }
    
    func keyboardShown(notification:NSNotification) {
        let info = notification.userInfo!
        let value:AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
        let rawFrame = value.CGRectValue
        self.keyboardFrame = view.convertRect(rawFrame, fromView: nil)
        self.viewMoveUp()
    }
    
    func dismissKeyboard() {
        self.inputTextField.resignFirstResponder()
        if keyboardShown {
            self.viewMoveDown()
        }
    }
    
    func viewMoveUp() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            var newFrame:CGRect = self.view.frame
            newFrame.size.height -= self.keyboardFrame.size.height
            self.view.frame = newFrame
            }) { (complete) -> Void in
                if complete {
                    self.reloadTable()
                }
        }
        keyboardShown = true
    }
    
    func viewMoveDown() {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.view.frame = self.originViewFrame
        }
        keyboardShown = false
    }
    
    func reloadTable() {
        data = CommentModelHelper().getCommentListByActionId(actionId)
        tableView.reloadData()
        if data.count > 0 {
            let ipath:NSIndexPath = NSIndexPath(forRow: data.count - 1, inSection: 1)
            tableView.scrollToRowAtIndexPath(ipath, atScrollPosition: UITableViewScrollPosition.Top, animated: false)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return self.data.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let actionContent: String = ActionItemModelHelper(me: false).getActionContentByActionId(actionId)
            let cell = tableView.dequeueReusableCellWithIdentifier(commentCellIdentifier3) as! ActionInfoTableViewCell
            cell.actionContentLabel.text = actionContent
            return cell
        } else {
            let rowDict = data[indexPath.row]
            let username = rowDict["username"]
            let nickname = rowDict["nickname"]!
            let message = rowDict["message"]
            let timestamp = rowDict["timestamp"]!
            if username == myUsername {
                let cell = tableView.dequeueReusableCellWithIdentifier(commentCellIdentifier2) as! ChatBubbleTableViewCell2
                cell.contentLabel.text = message
                cell.timeLabel.text = DateTimeHelper().convertEpochToHumanFriendlyTime(timestamp)
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(commentCellIdentifier1) as! ChatBubbleTableViewCell
                cell.contentLabel.text = message
                cell.nameLabel.text = nickname
                cell.timeLabel.text = DateTimeHelper().convertEpochToHumanFriendlyTime(timestamp)
                return cell
            }
        }
    }
    
    func didReceiveCommentNotification(actionId: String) {
        print("action id: \(actionId)")
        let commentAPIHelper = CommentAPIHelper()
        commentAPIHelper.delegate = self
        commentAPIHelper.getCommentList(actionId)
    }
    
    func didGetCommentList() {
        print("did get comment list")
        self.reloadTable()
    }

}
