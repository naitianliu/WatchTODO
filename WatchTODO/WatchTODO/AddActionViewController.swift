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
import CZPicker
import Toast

protocol AddActionVCDelegate {
    func didAddAction(actionId:String?, actionContent:String?, projectId:String?, projectName:String?, dueDate:String?, deferDate:String?, priority: Int?, watchers: [String])
}

class AddActionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SelectProjectVCDelegate, UITextViewDelegate, CZPickerViewDelegate, CZPickerViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var actionId: String?
    
    var actionContent: String?
    var projectId: String?
    var projectName: String?
    var dueDate: NSDate?
    var deferDate: NSDate?
    var priority: Int?
    var watchers: [String] = []
    var delegate: AddActionVCDelegate?
    
    var friends: [[String: String]] = []
    let friendsMapDict = FriendModelHelper().getFriendsMapDict()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tempActionId = actionId {
            self.navigationItem.title = "Edit Action"
            self.initiateActionInfo(tempActionId)
        } else {
            self.navigationItem.title = "Add Action"
        }
        
        friends = FriendModelHelper().getAllFriendList()
        
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
        if actionContent != nil && actionContent != "" {
            let dueDateEpoch: String? = DateTimeHelper().convertDateToEpoch(dueDate)
            let deferDateEpoch: String? = DateTimeHelper().convertDateToEpoch(deferDate)
            delegate?.didAddAction(actionId, actionContent: actionContent, projectId: projectId, projectName: projectName, dueDate: dueDateEpoch, deferDate: deferDateEpoch, priority: priority, watchers: watchers)
            self.dismissViewControllerAnimated(true) { () -> Void in
                
            }
        } else {
            let message = "Empty content is not allowed."
            self.view.makeToast(message, duration: 2.0, position: CSToastPositionCenter)
        }
        
    }
    
    private func initiateActionInfo(actionId: String) {
        let actionInfo: [String: AnyObject] = ActionItemModelHelper(me: true).getActionInfoByActionId(actionId)!
        self.actionContent = actionInfo["content"] as? String
        self.projectId = actionInfo["projectId"] as? String
        self.projectName = actionInfo["projectName"] as? String
        let dueDateEpoch: String = actionInfo["dueDate"] as! String
        let deferDateEpoch: String = actionInfo["deferDate"] as! String
        self.dueDate = DateTimeHelper().convertEpochToDate(dueDateEpoch)
        self.deferDate = DateTimeHelper().convertEpochToDate(deferDateEpoch)
        self.priority = actionInfo["priority"] as? Int
        let watchers = WatcherModelHelper().getWatchers(actionId)
        self.watchers = watchers
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        case 2:
            return 1
        case 3:
            return 1
        case 4:
            return self.watchers.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        } else if section == 4 {
            return 20
        } else {
            return 2
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 4 {
            let title = "Watchers Added"
            return title
        } else {
            return nil
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
            cell.imageView?.image = UIImage(named: "opened_folder")
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
            cell.imageView?.image = UIImage(named: "calendar")
            if let tempDeferDate = deferDate {
                cell.detailTextLabel?.text = DateTimeHelper().convertDateToStringMediumStyle(tempDeferDate)
            }
            return cell
        case (1, 1):
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: "AddActionDefaultCell")
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.text = "Due Date"
            cell.imageView?.image = UIImage(named: "calendar")
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
        case (3, 0):
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: "AddActionAddWatchersCell")
            cell.accessoryType = .DisclosureIndicator
            cell.imageView?.image = UIImage(named: "update-add_watcher")
            cell.textLabel?.text = "Add Watchers"
            cell.detailTextLabel?.text = String(self.watchers.count)
            return cell
        default:
            if indexPath.section == 4 {
                let username = self.watchers[indexPath.row]
                let nickname = self.friendsMapDict[username]
                let cell = UITableViewCell(style: .Default, reuseIdentifier: "AddActionWatcherCell")
                cell.selectionStyle = .None
                cell.imageView?.image = UIImage(named: "watcher")
                cell.textLabel?.text = nickname
                return cell
            } else {
                let cell = UITableViewCell(style: .Value1, reuseIdentifier: "AddActionDefaultCell")
                return cell
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.reloadData()
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
        case (3, 0):
            self.showAddWatchersPickerView()
        default:
            break
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SelectProjectSegue" {
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
        tableView.reloadData()
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            actionContent = textView.text
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        actionContent = textView.text
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        actionContent = textView.text
    }
    
    func didSelectProject(projectId: String, projectName: String, watchers: [String]) {
        self.projectId = projectId
        self.projectName = projectName
        for username in watchers {
            if !self.watchers.contains(username) {
                self.watchers.append(username)
            }
        }
        tableView.reloadData()
    }
    
    private func showAddWatchersPickerView() {
        let picker: CZPickerView = CZPickerView(headerTitle: "Select friends to watch", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        picker.delegate = self
        picker.dataSource = self
        picker.allowMultipleSelection = true
        picker.headerBackgroundColor = const_ThemeColor
        picker.confirmButtonBackgroundColor = const_ThemeColor
        var selectedRows: [Int] = []
        for (var i=0; i<self.friends.count; i++) {
            let username = friends[i]["username"]!
            if self.watchers.contains(username) {
                selectedRows.append(i)
            }
        }
        picker.setSelectedRows(selectedRows)
        picker.show()
    }
    
    func numberOfRowsInPickerView(pickerView: CZPickerView!) -> Int {
        return self.friends.count
    }
    
    func czpickerView(pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        let rowDict = friends[row]
        let nickname = rowDict["nickname"]
        return nickname
    }
    
    func czpickerView(pickerView: CZPickerView!, didConfirmWithItemsAtRows rows: [AnyObject]!) {
        var watcherArray: [String] = []
        for row in rows {
            watcherArray.append(friends[row as! Int]["username"]!)
        }
        self.watchers = watcherArray
        tableView.reloadData()
    }
    
}
