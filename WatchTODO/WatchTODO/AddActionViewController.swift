//
//  AddActionViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/16/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import DateTools

protocol AddActionVCDelegate {
    func didAddAction(actionContent:String?, project:String?, dueDate:String?, deferDate:String?)
}

class AddActionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EditActionContentVCDelegate, SelectProjectVCDelegate, UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var actionContent: String?
    var project: String?
    var dueDate: String?
    var deferDate: String?
    
    var delegate: AddActionVCDelegate?
    
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
        delegate?.didAddAction(actionContent, project: project, dueDate: dueDate, deferDate: deferDate)
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = tableView.dequeueReusableCellWithIdentifier("AddActionContentCell") as! AddActionContentTableViewCell
            cell.contentTextView.delegate = self
            if let content = actionContent {
                cell.contentTextView.text = content
            }
            return cell
        case (0, 1):
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: "AddActionDefaultCell")
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.text = "Project"
            if let projectName = project {
                cell.detailTextLabel?.text = projectName
            } else {
                cell.detailTextLabel?.text = "Inbox"
            }
            return cell
        case (1, 0):
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: "AddActionDefaultCell")
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.text = "Defer Until"
            if let deferDateString = deferDate {
                cell.detailTextLabel?.text = deferDateString
            }
            return cell
        case (1, 1):
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: "AddActionDefaultCell")
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.text = "Due Date"
            if let dueDateString = dueDate {
                cell.detailTextLabel?.text = dueDateString
            }
            return cell
        case (2, 0):
            let cell = tableView.dequeueReusableCellWithIdentifier("AddActionPriorityCell") as! AddActionPriorityTableViewCell
            return cell
        default:
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: "AddActionDefaultCell")
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            // self.performSegueWithIdentifier("EditActionContentSegue", sender: nil)
            break
        case (0, 1):
            self.performSegueWithIdentifier("SelectProjectSegue", sender: nil)
        case (1, 0):
            self.setupDate("defer")
        case (1, 1):
            self.setupDate("due")
        default:
            break
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditActionContentSegue" {
            let editActionContentVC = segue.destinationViewController as! EditActionContentViewController
            editActionContentVC.delegate = self
        } else if segue.identifier == "SelectProjectSegue" {
            let selectProjectVC = segue.destinationViewController as! SelectProjectViewController
            selectProjectVC.delegate = self
        }
    }
    
    private func setupDate(dateType:String) {
        let datePicker = ActionSheetDatePicker(title: nil, datePickerMode: .Date, selectedDate: NSDate(), doneBlock: { (picker, value, index) -> Void in
            let datetime = value as! NSDate
            let formatter = NSDateFormatter()
            formatter.dateFormat = "YYYY-MM-DD"
            let dateString: String = formatter.stringFromDate(datetime)
            self.setDateValue(dateType, dateString: dateString)
            }, cancelBlock: nil, origin: self.view)
        datePicker.addCustomButtonWithTitle("Today", actionBlock: { () -> Void in
            self.setDateValue(dateType, dateString: "today")
        })
        datePicker.addCustomButtonWithTitle("Tomorrow", actionBlock: { () -> Void in
            self.setDateValue(dateType, dateString: "tomorrow")
        })
        datePicker.addCustomButtonWithTitle("Everyday", actionBlock: { () -> Void in
            self.setDateValue(dateType, dateString: "everyday")
        })
        datePicker.minimumDate = NSDate(timeInterval: 0, sinceDate: NSDate())
        datePicker.minuteInterval = 1440
        datePicker.showActionSheetPicker()
    }
    
    private func setDateValue(dateType: String, dateString: String) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        var newDateString = dateString
        if dateString == "today" {
            newDateString = formatter.stringFromDate(NSDate())
        } else if dateString == "tomorrow" {
            newDateString = formatter.stringFromDate(NSDate().dateByAddingDays(1))
        }
        if dateType == "due" {
            dueDate = newDateString
        } else if dateType == "defer" {
            deferDate = newDateString
        }
        print(dueDate)
        print(deferDate)
        print(dateType)
        tableView.reloadData()
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        print(text)
        if text == "\n" {
            actionContent = textView.text
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func didEditActionContent(content: String) {
        print(content)
        actionContent = content
        tableView.reloadData()
    }
    
    func didSelectProject(projectName: String) {
        print(projectName)
        project = projectName
        tableView.reloadData()
    }
}
