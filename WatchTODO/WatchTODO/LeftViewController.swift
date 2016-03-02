//
//  LeftViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/30/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddProjectVCDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var todayCompleteView: UIView!
    
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    let cellIdentifier1 = "SelectionCell"
    let cellIdentifier2 = "ProjectCell"
    let cellIdentifier3 = "AddNewProjectCell"
    
    let selectionList = [
        ["name": "Inbox", "icon": "inbox-icon"],
        ["name": "Today", "icon": "today-icon"],
        ["name": "Next 7 days", "icon": "week-icon"]
    ]
    
    let projectModelHelper = ProjectModelHelper()
    
    var projects: [[String: String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.translucent = false
        tableView.tableFooterView = UIView()
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.None)
        self.reloadProjects()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier1)!
            let rowDict = selectionList[indexPath.row]
            cell.textLabel!.text = rowDict["name"]
            cell.imageView!.image = UIImage(named: rowDict["icon"]!)
            return cell
        } else if indexPath.row < projects.count {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier2)!
            let rowDict = projects[indexPath.row]
            let projectName: String = rowDict["name"]!
            cell.textLabel!.text = projectName
            cell.imageView!.image = UIImage(named: "folder-icon")
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier3)!
            cell.textLabel?.text = "Add Project"
            cell.imageView?.image = UIImage(named: "plus-white")
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
        } else if indexPath.row == projects.count {
            self.presentAddNewProjectVC()
        }
        
    }
    
    private func presentAddNewProjectVC() {
        let addProjectNC = self.storyboard?.instantiateViewControllerWithIdentifier("AddProjectNavigationController") as! UINavigationController
        addProjectNC.modalTransitionStyle = .CoverVertical
        let addProjectVC = addProjectNC.viewControllers[0] as! AddProjectViewController
        addProjectVC.delegate = self
        self.presentViewController(addProjectNC, animated: true) { () -> Void in
            
        }
    }
    
    func didAddNewProject() {
        self.reloadProjects()
    }
}
