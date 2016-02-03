//
//  LeftViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/30/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import PNChart

class LeftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var todayCompleteView: UIView!
    
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    let cellIdentifier1 = "SelectionCell"
    let cellIdentifier2 = "ProjectCell"
    
    let selectionList = [
        ["name": "Inbox", "icon": "inbox-icon"],
        ["name": "Today", "icon": "today-icon"],
        ["name": "Next 7 days", "icon": "week-icon"]
    ]
    
    let projectModelHelper = ProjectModelHelper()
    
    var projects: [[String: String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        self.initiateCompleteView()
        self.reloadProjects()
        print(projects)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initiateCompleteView() {
        let circleChart1 = PNCircleChart(frame: CGRect(x: 0, y: 0, width: todayCompleteView.frame.width, height: todayCompleteView.frame.height), total: NSNumber(integer: 100), current: NSNumber(integer: 60), clockwise: true)
        circleChart1.backgroundColor = UIColor.clearColor()
        circleChart1.strokeChart()
        todayCompleteView.addSubview(circleChart1)
    }
    
    func reloadProjects() {
        projects = projectModelHelper.getAllProjects()
        tableView.reloadData()
    }
    
    @IBAction func logoutButtonOnClick(sender: AnyObject) {
        let actionSheet = UIActionSheet(title: "Confirm to Logout", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Logout")
        actionSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            UserDefaultsHelper().removeUserInfo()
            appDelegate.switchToLoginVC()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return selectionList.count
        } else {
            return projects.count
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
            let rowDict = projects[indexPath.row]
            let projectName: String = rowDict["name"]!
            cell.textLabel?.text = projectName
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let centerTC = appDelegate.drawerController.centerViewController as! MainTabBarController
        let todoNC = centerTC.myTodoListNC as MyTodoListNavigationController
        let todoVC = todoNC.viewControllers[0] as! MyTodoListViewController
        if indexPath.section == 0 && indexPath.row == 1 {
            todoVC.selectedCategory = "today"
        } else {
            todoVC.selectedCategory = nil
        }
        todoVC.setupDisplayItems()
        appDelegate.drawerController.closeDrawerAnimated(true) { (complete) -> Void in
            
        }
    }

}
