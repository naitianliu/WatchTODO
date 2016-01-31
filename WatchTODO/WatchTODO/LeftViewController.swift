//
//  LeftViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/30/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier1 = "SelectionCell"
    let cellIdentifier2 = "ProjectCell"
    
    let selectionList = [
        ["name": "Inbox", "icon": "inbox-icon"],
        ["name": "Today", "icon": "today-icon"],
        ["name": "Next 7 days", "icon": "week-icon"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
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
            return selectionList.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier1)
            let rowDict = selectionList[indexPath.row]
            cell.textLabel?.text = rowDict["name"]
            cell.imageView?.image = UIImage(named: rowDict["icon"]!)
            return cell
        } else {
            let cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier2)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Projects"
        } else {
            return nil
        }
    }

}
