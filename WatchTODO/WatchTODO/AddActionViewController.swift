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
    func didAddAction(actionContent:String?, projectId:String?, projectName:String?, dueDate:String?, deferDate:String?, priority: Int?)
}

class AddActionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EditActionContentVCDelegate, SelectProjectVCDelegate, UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var actionContent: String?
    var projectId: String?
    var projectName: String?
    var dueDate: NSDate?
    var deferDate: NSDate?
    var priority: Int?
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
        let dueDateEpoch: String? = DateTimeHelper().convertDateToEpoch(dueDate)
        let deferDateEpoch: String? = DateTimeHelper().convertDateToEpoch(deferDate)
        delegate?.didAddAction(actionContent, projectId: projectId, projectName: projectName, dueDate: dueDateEpoch, deferDate: deferDateEpoch, priority: priority)
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
            if let projectName = projectName {
                cell.detailTextLabel?.text = projectName
            } else {
                cell.detailTextLabel?.text = "Inbox"
            }
            return cell
        case (1, 0):
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: "AddActionDefaultCell")
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.text = "Defer Until"
            if let tempDeferDate = deferDate {
                cell.detailTextLabel?.text = DateTimeHelper().convertDateToStringMediumStyle(tempDeferDate)
            }
            return cell
        case (1, 1):
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: "AddActionDefaultCell")
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.text = "Due Date"
            if let tempDueDate = dueDate {
                cell.detailTextLabel?.text = DateTimeHelper().convertDateToStringMediumStyle(tempDueDate)
            }
            return cell
        case (2, 0):
            let cell = tableView.dequeueReusableCellWithIdentifier("AddActionPriorityCell") as! AddActionPriorityTableViewCell
            if let currentPriority = priority {
                cell.prioritySegmentedControl.selectedSegmentIndex = currentPriority - 1
            }
            cell.prioritySegmentedControl.addTarget(self, action: Selector("segmentedControlValueChanged:"), forControlEvents: .ValueChanged)
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
    
    func segmentedControlValueChanged(sender: UISegmentedControl!) {
        priority = sender.selectedSegmentIndex + 1
    }
    
    private func setupDate(dateType:String) {
        let datePicker = ActionSheetDatePicker(title: nil, datePickerMode: .Date, selectedDate: NSDate(), doneBlock: { (picker, value, index) -> Void in
            let datetime = value as! NSDate
            self.setDateValue(dateType, date: datetime)
            }, cancelBlock: nil, origin: self.view)
        datePicker.addCustomButtonWithTitle("Today", actionBlock: { () -> Void in
            self.setDateValue(dateType, date: NSDate())
        })
        datePicker.addCustomButtonWithTitle("Tomorrow", actionBlock: { () -> Void in
            self.setDateValue(dateType, date: NSDate().dateByAddingDays(1))
        })
        datePicker.minimumDate = NSDate(timeInterval: 0, sinceDate: NSDate())
        datePicker.minuteInterval = 1440
        datePicker.showActionSheetPicker()
    }
    
    private func setDateValue(dateType: String, date: NSDate) {
        if dateType == "due" {
            dueDate = date
        } else if dateType == "defer" {
            deferDate = date
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
    
    func didSelectProject(projectId: String, projectName: String) {
        self.projectId = projectId
        self.projectName = projectName
        tableView.reloadData()
    }
}
