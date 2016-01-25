//
//  AddFriendViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/23/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import SDWebImage

protocol AddFriendVCDelegate {
    func addDFriendDidSelectFriend(userInfo: [String: String])
}

class AddFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: AddFriendVCDelegate?
    
    var userListByUsername: [[String: String]] = []
    var userListByNickname: [[String: String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return userListByUsername.count
        } else {
            return userListByNickname.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "AddFriendCell")
        if indexPath.section == 0 {
            let nickname: String = userListByUsername[indexPath.row]["nickname"]!
            let profileImageURL :String = userListByUsername[indexPath.row]["profile_img_url"]!
            cell.textLabel?.text = nickname
            cell.imageView?.sd_setImageWithURL(NSURL(string: profileImageURL))
        } else {
            let nickname: String = userListByNickname[indexPath.row]["nickname"]!
            let profileImageURL :String = userListByNickname[indexPath.row]["profile_img_url"]!
            cell.textLabel?.text = nickname
            cell.imageView?.sd_setImageWithURL(NSURL(string: profileImageURL))
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            delegate?.addDFriendDidSelectFriend(userListByUsername[indexPath.row])
        } else {
            delegate?.addDFriendDidSelectFriend(userListByNickname[indexPath.row])
        }
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Results by Username"
        } else {
            return "Results by Nickname"
        }
    }

}
