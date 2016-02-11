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
        self.reloadProjects()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadProjects() {
        projects = projectModelHelper.getAllProjects()
        tableView.reloadData()
    }
    
    @IBAction func logoutButtonOnClick(sender: AnyObject) {
        self.showLogoutActionSheet()
    }
    
    private func showLogoutActionSheet() {
        let alertController = UIAlertController(title: "Confirm to Logout", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let actionConfirm = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Destructive) { (action) -> Void in
            UserDefaultsHelper().removeUserInfo()
            self.appDelegate.switchToLoginVC()
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(actionConfirm)
        alertController.addAction(actionCancel)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return selectionList.count
        } else {
            return projects.count + 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier1)
            let rowDict = selectionList[indexPath.row]
            cell.textLabel?.text = rowDict["name"]
            cell.imageView?.image = UIImage(named: rowDict["icon"]!)
            return cell
        } else if indexPath.row < projects.count {
            let cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier2)
            let rowDict = projects[indexPath.row]
            let projectName: String = rowDict["name"]!
            cell.textLabel?.text = projectName
            return cell
        } else {
            let cell = UITableViewCell(style: .Default, reuseIdentifier: "addProjectCell")
            cell.imageView?.image = UIImage(named: "plus")
            cell.textLabel?.text = "New"
            cell.textLabel?.textColor = const_ThemeColor
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
        if indexPath.section == 0 {
            todoVC.selectedProjectId = nil
            if indexPath.row == 1 {
                todoVC.selectedCategory = "today"
            } else {
                todoVC.selectedCategory = nil
            }
            todoVC.setupDisplayItems()
            appDelegate.drawerController.closeDrawerAnimated(true) { (complete) -> Void in
                
            }
        } else if indexPath.row < projects.count {
            todoVC.selectedCategory = nil
            let rowDict = projects[indexPath.row]
            let projectId: String = rowDict["uuid"]!
            print(projectId)
            todoVC.selectedProjectId = projectId
            todoVC.setupDisplayItems()
            appDelegate.drawerController.closeDrawerAnimated(true) { (complete) -> Void in
                
            }
        } else {
            self.showAddNewProjectAlertController()
        }
        
    }
    
    private func showAddNewProjectAlertController() {
        let alertController = UIAlertController(title: "Create New Project", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Project Name"
        }
        let actionConfirm = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default) { (action) -> Void in
            let projectName = alertController.textFields![0].text
            if let tempProjectName = projectName {
                ProjectAPIHelper().addProject(tempProjectName)
                self.reloadProjects()
            }
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(actionConfirm)
        alertController.addAction(actionCancel)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
