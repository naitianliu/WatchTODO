//
//  FriendsViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/22/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, AddFriendVCDelegate, CallAPIHelperDelegate, UIAlertViewDelegate {
    
    let apiURL_GetFriendList = "\(const_APIEndpoint)friends/get_friend_list/"
    let apiURL_GetUserListByKeyword = "\(const_APIEndpoint)friends/get_user_list_by_keyword/"
    let apiURL_SendFriendRequest = "\(const_APIEndpoint)friends/send_friend_request/"
    let apiURL_AcceptFriendRequest = "\(const_APIEndpoint)friends/accept_friend_request/"
    let apiURL_GetPendingFriendRequestList = "\(const_APIEndpoint)friends/get_pending_friend_request_list/"

    @IBOutlet weak var friendTableView: UITableView!
    var addFriendVC: AddFriendViewController!
    var selectedAddFriendUsername: String = ""
    
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonOnClick(sender: AnyObject) {
        friendTableView.tableHeaderView = addSearchController.searchBar
        addSearchController.searchBar.becomeFirstResponder()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "FriendCell")
        
        return cell
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
        let profileImageURL: String = userInfo["profile_img_url"]!
        selectedAddFriendUsername = username
        let alertView = UIAlertView(title: "Send Friend Request", message: nickname, delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Send")
        alertView.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            
        }
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
