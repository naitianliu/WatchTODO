//
//  CommentsViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/28/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let commentCellIdentifier1 = "ChatBubbleCell1"
    let commentCellIdentifier2 = "ChatBubbleCell2"
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var sendButton: UIBarButtonItem!
    @IBOutlet weak var textFieldBarButtonItem: UIBarButtonItem!
    
    let kOFFSET_FOR_KEYBOARD:CGFloat = 20
    var keyboardFrame:CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var currentKeyboardHeight:CGFloat = 0
    var originViewFrame:CGRect!
    
    let data = [
        "Click the Start Slicing button that is displayed over the center of the image. Set a breakpoint on this line and see what self.mediaItem.image.size looks like.",
        "appropriate button"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.originViewFrame = self.view.frame
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShown:", name: UIKeyboardWillShowNotification, object: nil)
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard"))
        self.view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.textFieldBarButtonItem.width = self.view.frame.width - self.sendButton.width - 80
        self.inputTextField.placeholder = "Comment"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardShown(notification:NSNotification) {
        let info = notification.userInfo!
        let value:AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
        let rawFrame = value.CGRectValue
        self.keyboardFrame = view.convertRect(rawFrame, fromView: nil)
        print(self.keyboardFrame.size.height)
        self.viewMoveUp()
    }
    
    func dismissKeyboard() {
        self.inputTextField.resignFirstResponder()
        print("dismiss")
        self.viewMoveDown()
    }
    
    func viewMoveUp() {
        UIView.animateWithDuration(0.5) { () -> Void in
            var newFrame:CGRect = self.view.frame
            newFrame.size.height -= self.keyboardFrame.size.height - self.currentKeyboardHeight
            self.view.frame = newFrame
        }
        self.reloadTable()
        self.currentKeyboardHeight = self.keyboardFrame.size.height
    }
    
    func viewMoveDown() {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.view.frame = self.originViewFrame
        }
        self.reloadTable()
        self.currentKeyboardHeight = 0
    }
    
    func reloadTable() {
        tableView.reloadData()
        if data.count > 0 {
            let ipath:NSIndexPath = NSIndexPath(forRow: data.count - 1, inSection: 0)
            tableView.scrollToRowAtIndexPath(ipath, atScrollPosition: UITableViewScrollPosition.Top, animated: false)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(commentCellIdentifier1) as! ChatBubbleTableViewCell
        let content = data[indexPath.row]
        cell.contentLabel.text = content
        cell.nameLabel.text = "Naitian Liu"
        return cell
    }

}
