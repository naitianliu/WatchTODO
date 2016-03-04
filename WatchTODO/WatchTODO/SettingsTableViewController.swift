//
//  SettingsTableViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 3/3/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    let cellIdentifier_NicknameCell = "SettingsNicknameCell"
    let cellIdentifier_EmailCell = "SettingsEmailCell"
    let cellIdentifier_LogoutCell = "SettingsLogoutCell"
    
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var userInfo: [String: String?] = UserDefaultsHelper().getUserInfo()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        default:
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: cellIdentifier_NicknameCell)
            cell.textLabel?.text = "Nickname"
            cell.detailTextLabel?.text = self.userInfo["nickname"]!
            return cell
        } else if indexPath.section == 0 && indexPath.row == 1 {
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: cellIdentifier_EmailCell)
            cell.textLabel?.text = "Email"
            cell.detailTextLabel?.text = self.userInfo["username"]!
            return cell
        } else if indexPath.section == 1 && indexPath.row == 0 {
            let cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier_LogoutCell)
            // let label: UILabel = UILabel(frame: cell.contentView.frame)
            cell.textLabel!.text = "Log out"
            cell.textLabel!.textColor = UIColor.redColor()
            cell.textLabel!.textAlignment = .Center
            return cell
        } else {
            let cell = UITableViewCell()
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 1 && indexPath.row == 0 {
            self.showLogoutActionSheet()
        }
    }
    
    private func showLogoutActionSheet() {
        let alertController = UIAlertController(title: "Confirm to Logout", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let actionConfirm = UIAlertAction(title: "Logout", style: UIAlertActionStyle.Destructive) { (action) -> Void in
            UserDefaultsHelper().removeUserInfo()
            self.appDelegate.switchToLoginVC()
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(actionConfirm)
        alertController.addAction(actionCancel)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
