//
//  SelectProjectViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/17/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

protocol SelectProjectVCDelegate {
    func didSelectProject(projectId:String, projectName:String)
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
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "SelectProjectCell")
        if indexPath.section == 0 {
            cell.textLabel?.text = "Inbox"
        } else {
            cell.textLabel?.text = projects[indexPath.row]["name"]
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
        delegate?.didSelectProject(projectId, projectName: projectName)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Custom Projects"
        } else {
            return nil
        }
    }
    
    func didAddNewProject(projectName: String) {
        ProjectAPIHelper().addProject(projectName)
        projects = projectModelHelper.getAllProjects()
        tableView.reloadData()
    }
}
