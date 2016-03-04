//
//  AddFriendViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/23/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import MBProgressHUD

class AddFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FriendAPIHelperDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var userList: [[String: String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonOnClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let keyword = searchBar.text {
            searchBar.resignFirstResponder()
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            let friendAPIHelper = FriendAPIHelper()
            friendAPIHelper.delegate = self
            friendAPIHelper.getUserListByKeyword(keyword)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AddFriendTableViewCell") as! AddFriendTableViewCell
        let nickname: String = userList[indexPath.row]["nickname"]!
        let username: String = userList[indexPath.row]["username"]!
        cell.nicknameLabel.text = nickname
        cell.usernameLabel.text = username
        cell.inviteButton.addTarget(self, action: Selector("inviteButtonOnClick:"), forControlEvents: .TouchDown)
        return cell
    }
    
    func inviteButtonOnClick(sender: UIButton!) {
        let cell = sender.superview?.superview as! AddFriendTableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        let userInfo: [String: String] = self.userList[indexPath.row]
        let username: String = userInfo["username"]!
        let nickname: String = userInfo["nickname"]!
        self.showSendAlertController(username, nickname: nickname)
    }
    
    func didGetUserListByKeyword(userList: [[String : String]]) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.userList = userList
        self.tableView.reloadData()
    }
    
    func didSendFriendRequest() {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didFailCallFriendAPI() {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
    private func showSendAlertController(username: String?, nickname: String?) {
        let alertController = UIAlertController(title: "Send Friend Invitation", message: nickname, preferredStyle: UIAlertControllerStyle.Alert)
        let alertActionSend = UIAlertAction(title: "Send", style: UIAlertActionStyle.Default) { (action) -> Void in
            if let selectedUsername = username, selectedNickname = nickname {
                let friendAPIHelper = FriendAPIHelper()
                friendAPIHelper.delegate = self
                friendAPIHelper.sendFriendRequest(selectedUsername, nickname: selectedNickname)
            }
        }
        let alertActionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(alertActionSend)
        alertController.addAction(alertActionCancel)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
