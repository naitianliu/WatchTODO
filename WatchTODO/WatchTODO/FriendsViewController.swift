//
//  FriendsViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/22/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UpdateAPIHelperDelegate {
    

    @IBOutlet weak var friendTableView: UITableView!
    var selectedAddFriendUsername: String?
    var selectedAddFriendNickname: String?
    
    var pendingFriends: [[String: AnyObject]] = []
    var friends: [[String: String]] = []
    let friendModelHelper = FriendModelHelper()
    
    var addSearchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendTableView.tableFooterView = UIView()
        friendTableView.estimatedRowHeight = 200
        
        self.reloadTable()
        
        let updateAPIHelper = UpdateAPIHelper()
        updateAPIHelper.delegate = self
        updateAPIHelper.getUpdatedInfo()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func reloadTable() {
        pendingFriends = friendModelHelper.getPendingFriendList()
        friends = friendModelHelper.getAllFriendList()
        friendTableView.reloadData()
    }
    
    @IBAction func addButtonOnClick(sender: AnyObject) {
        let addFriendNC = self.storyboard?.instantiateViewControllerWithIdentifier("AddFriendNavigationController") as! UINavigationController
        // let addFriendVC = addFriendNC.viewControllers[0] as! AddFriendViewController
        addFriendNC.modalTransitionStyle = .CoverVertical
        self.presentViewController(addFriendNC, animated: true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if pendingFriends.count == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pendingFriends.count == 0 {
            return friends.count
        } else {
            if section == 0 {
                return pendingFriends.count
            } else {
                return friends.count
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell") as! FriendTableViewCell
        if pendingFriends.count == 0 {
            let rowDict = friends[indexPath.row]
            let username = rowDict["username"]
            let nickname = rowDict["nickname"]
            cell.nicknameLabel.text = nickname
            cell.usernameLabel.text = username
        } else {
            if indexPath.section == 0 {
                let rowDict = pendingFriends[indexPath.row]
                // let username = rowDict["username"]!
                let nickname = rowDict["nickname"] as! String
                let username = rowDict["username"] as! String
                cell.nicknameLabel.text = nickname
                cell.usernameLabel.text = username
                cell.status = "waiting"
            } else {
                let rowDict = friends[indexPath.row]
                let username = rowDict["username"]
                let nickname = rowDict["nickname"]
                cell.nicknameLabel.text = nickname
                cell.usernameLabel.text = username
                cell.status = "connected"
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.friendTableView.deselectRowAtIndexPath(indexPath, animated: true)
        if pendingFriends.count != 0 && indexPath.section == 0 {
            let rowDict = pendingFriends[indexPath.row]
            let username = rowDict["username"] as! String
            let nickname = rowDict["nickname"] as! String
            let role = rowDict["role"] as! String
            if role == "requester" {
                self.showAcceptAlertController(username, nickname: nickname)
            }
        }
    }
    
    private func showAcceptAlertController(username: String, nickname: String) {
        let alertController = UIAlertController(title: "Accept", message: "Accept invitation from \(nickname)", preferredStyle: UIAlertControllerStyle.Alert)
        let actionAccept = UIAlertAction(title: "Accept", style: UIAlertActionStyle.Default) { (action) -> Void in
            FriendAPIHelper().acceptFriendRequest(username)
            self.reloadTable()
        }
        let actionDecline = UIAlertAction(title: "Decline", style: UIAlertActionStyle.Default) { (action) -> Void in
            
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(actionAccept)
        alertController.addAction(actionDecline)
        alertController.addAction(actionCancel)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func didFriendsUpdated() {
        self.reloadTable()
    }
}
