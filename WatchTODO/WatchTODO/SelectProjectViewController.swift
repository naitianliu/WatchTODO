//
//  SelectProjectViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/17/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

protocol SelectProjectVCDelegate {
    func didSelectProject(projectId:String, projectName:String, watchers: [String])
}

class SelectProjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddProjectVCDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let projectModelHelper = ProjectModelHelper()
    
    var projects: [[String:String]]!
    
    var delegate: SelectProjectVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        projects = projectModelHelper.getAllProjects()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonOnClick(sender: AnyObject) {
        let addProjectNC = self.storyboard?.instantiateViewControllerWithIdentifier("AddProjectNavigationController") as! UINavigationController
        addProjectNC.modalTransitionStyle = .CoverVertical
        let addProjectVC = addProjectNC.viewControllers[0] as! AddProjectViewController
        addProjectVC.delegate = self
        self.presentViewController(addProjectNC, animated: true) { () -> Void in
            
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return projects.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "SelectProjectCell")
        if indexPath.section == 0 {
            cell.imageView?.image = UIImage(named: "inbox-blue")
            cell.textLabel?.text = "Inbox"
        } else {
            let projectName = projects[indexPath.row]["name"]!
            let projectId = projects[indexPath.row]["uuid"]!
            cell.imageView?.image = UIImage(named: "folder-blue")
            cell.textLabel?.text = projectName
            let watchers = ProjectModelHelper().getWatchersByProjectId(projectId)
            cell.detailTextLabel?.text = String(watchers.count)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var projectName = "Inbox"
        var projectId:String = "0"
        if indexPath.section == 1 {
            projectName = projects[indexPath.row]["name"]!
            projectId = projects[indexPath.row]["uuid"]!
        }
        var watchers: [String] = []
        if projectId != "0" {
            watchers = ProjectModelHelper().getWatchersByProjectId(projectId)
        }
        delegate?.didSelectProject(projectId, projectName: projectName, watchers: watchers)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Custom Projects"
        } else {
            return nil
        }
    }
    
    func didAddNewProject() {
        projects = projectModelHelper.getAllProjects()
        tableView.reloadData()
    }
}
