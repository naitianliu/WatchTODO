//
//  MeTableViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 2/25/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class MeTableViewController: UITableViewController {
    
    let cellIdentifier1 = "MeInfoCell"
    let cellIdentifier2 = "MeItemCell"
    
    let iconTitleArray = [
        ["icon": "complete-icon", "title": "Complete Actions"],
        ["icon": "calendar", "title": "Calendar"],
    ]
    let settingsIconTitleArray = [
        ["icon": "bell-icon", "title": "Notification"],
        ["icon": "settings", "title": "Settings"],
    ]
    
    var countNumberDict = ActionItemModelHelper(me: true).countNumber()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        countNumberDict = ActionItemModelHelper(me: true).countNumber()
        self.tableView.reloadData()
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
            return 1
        case 1:
            return 2
        case 2:
            return 0
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        } else {
            return 44
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier1, forIndexPath: indexPath) as! MeInfoTableViewCell
            cell.label1.text = self.countNumberDict["0"]
            cell.label2.text = self.countNumberDict["1"]
            cell.label3.text = self.countNumberDict["2"]
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier2, forIndexPath: indexPath)
            let icon: String = iconTitleArray[indexPath.row]["icon"]!
            let title: String = iconTitleArray[indexPath.row]["title"]!
            cell.imageView?.image = UIImage(named: icon)
            cell.textLabel?.text = title
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier2, forIndexPath: indexPath)
            let icon: String = settingsIconTitleArray[indexPath.row]["icon"]!
            let title: String = settingsIconTitleArray[indexPath.row]["title"]!
            cell.imageView?.image = UIImage(named: icon)
            cell.textLabel?.text = title
            return cell
        } else {
            let cell = UITableViewCell()
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 1 && indexPath.row == 1 {
            self.performSegueWithIdentifier("SettingsSegue", sender: nil)
        } else if indexPath.section == 1 && indexPath.row == 0 {
            if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(appSettings)
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
