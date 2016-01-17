//
//  AddActionViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/16/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class AddActionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EditActionContentVCDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "AddActionContentTableViewCell", bundle: nil), forCellReuseIdentifier: "AddActionContentTableViewCell")

        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelButtonOnClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    @IBAction func addButtonOnClick(sender: AnyObject) {
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "AddActionCell")
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            cell.textLabel?.text = "Action Content"
            cell.textLabel?.textColor = UIColor.lightGrayColor()
        case (0, 1):
            cell.textLabel?.text = "Project"
            cell.textLabel?.textColor = UIColor.lightGrayColor()
            break
        case (1, 0):
            cell.textLabel?.text = "Defer until"
            cell.textLabel?.textColor = UIColor.lightGrayColor()
            break
        case (1, 1):
            cell.textLabel?.text = "Due to"
            cell.textLabel?.textColor = UIColor.lightGrayColor()
            break
        case (1, 2):
            cell.textLabel?.text = "Estimated Time"
            cell.textLabel?.textColor = UIColor.lightGrayColor()
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            self.performSegueWithIdentifier("EditActionContentSegue", sender: nil)
        default:
            break
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditActionContentSegue" {
            let editActionContentVC = segue.destinationViewController as! EditActionContentViewController
            editActionContentVC.delegate = self
        }
    }
    
    func didEditActionContent(content: String) {
        print(content)
    }
}
