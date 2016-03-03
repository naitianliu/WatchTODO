//
//  FriendsViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/22/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, AddFriendVCDelegate, CallAPIHelperDelegate, UpdateAPIHelperDelegate {
    
    let apiURL_GetFriendList = "\(const_APIEndpoint)friends/get_friend_list/"
    let apiURL_GetUserListByKeyword = "\(const_APIEndpoint)friends/get_user_list_by_keyword/"
    let apiURL_SendFriendRequest = "\(const_APIEndpoint)friends/send_friend_request/"
    let apiURL_AcceptFriendRequest = "\(const_APIEndpoint)friends/accept_friend_request/"
    let apiURL_GetPendingFriendRequestList = "\(const_APIEndpoint)friends/get_pending_friend_request_list/"

    @IBOutlet weak var friendTableView: UITableView!
    var addFriendVC: AddFriendViewController!
    var selectedAddFriendUsername: String?
    var selectedAddFriendNickname: String?
    
    var pendingFriends: [[String: AnyObject]] = []
    var friends: [[String: String]] = []
    let friendModelHelper = FriendModelHelper()
    
    var addSearchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchResultsController = self.storyboard?.instantiateViewControllerWithIdentifier("AddFriendNavigationController") as! UINavigationController
        addFriendVC = searchResultsController.viewControllers[0] as! AddFriendViewController
        addFriendVC.delegate = self
        addSearchController = UISearchController(searchResultsController: searchResultsController)
        addSearchController.searchResultsUpdater = self
        addSearchController.searchBar.delegate = self
        addSearchController.searchBar.placeholder = "Username / Nickname"
        addSearchController.searchBar.frame = CGRect(x: addSearchController.searchBar.frame.origin.x, y: addSearchController.searchBar.frame.origin.y, width: addSearchController.searchBar.frame.width, height: 44)
        addSearchController.searchBar.sizeToFit()
        addSearchController.hidesNavigationBarDuringPresentation = true
        self.definesPresentationContext = true
        
        friendTableView.tableFooterView = UIView()
        friendTableView.estimatedRowHeight = 200
        
        self.reloadTable()
        
        let updateAPIHelper = UpdateAPIHelper()
        updateAPIHelper.delegate = self
        updateAPIHelper.getUpdatedInfo()
        
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
        friendTableView.tableHeaderView = addSearchController.searchBar
        addSearchController.searchBar.becomeFirstResponder()
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
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        friendTableView.tableHeaderView = nil
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let keyword = searchBar.text
        CallAPIHelper(url: apiURL_GetUserListByKeyword, data: ["keyword": keyword!], delegate: self).GET("search")
        
    }
    
    func addDFriendDidSelectFriend(userInfo: [String : String]) {
        friendTableView.tableHeaderView = nil
        addSearchController.active = false
        let username: String = userInfo["username"]!
        let nickname: String = userInfo["nickname"]!
        selectedAddFriendUsername = username
        selectedAddFriendNickname = nickname
        self.showSendAlertController(selectedAddFriendUsername, nickname: selectedAddFriendNickname)
    }
    
    private func showSendAlertController(username: String?, nickname: String?) {
        let alertController = UIAlertController(title: "Send Friend Invitation", message: nickname, preferredStyle: UIAlertControllerStyle.Alert)
        let alertActionSend = UIAlertAction(title: "Send", style: UIAlertActionStyle.Default) { (action) -> Void in
            if let selectedUsername = username, selectedNickname = nickname {
                FriendAPIHelper().sendFriendRequest(selectedUsername, nickname: selectedNickname)
                self.reloadTable()
            }
        }
        let alertActionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(alertActionSend)
        alertController.addAction(alertActionCancel)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func showAcceptAlertController(username: String, nickname: String) {
        print("show accept alert")
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
    
    func beforeSendRequest(index: String?) {
        if index == "search" {
            
        }
    }
    
    func afterReceiveResponse(responseData: AnyObject, index: String?) {
        if index == "search" {
            let result = responseData as! [String: AnyObject]
            let userListByNickname = result["user_list_by_nickname"] as! [[String: String]]
            let userListByUsername = result["user_list_by_username"] as! [[String: String]]
            addFriendVC.userListByNickname = userListByNickname
            addFriendVC.userListByUsername = userListByUsername
            addFriendVC.tableView.reloadData()
        }
    }
    
    func apiReceiveError(error: ErrorType) {
        
    }
}
