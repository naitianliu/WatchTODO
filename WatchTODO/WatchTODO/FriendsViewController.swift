//
//  FriendsViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/22/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let apiURL_GetFriendList = "\(const_APIEndpoint)friends/get_friend_list/"
    let apiURL_GetUserListByKeyword = "\(const_APIEndpoint)friends/get_user_list_by_keyword/"
    let apiURL_SendFriendRequest = "\(const_APIEndpoint)friends/send_friend_request/"
    let apiURL_AcceptFriendRequest = "\(const_APIEndpoint)friends/accept_friend_request/"
    let apiURL_GetPendingFriendRequestList = "\(const_APIEndpoint)friends/get_pending_friend_request_list/"

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonOnClick(sender: AnyObject) {
        
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
    
}
