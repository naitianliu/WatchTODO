//
//  AddProjectViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/17/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import CZPicker
import MBProgressHUD

protocol AddProjectVCDelegate {
    func didAddNewProject()
}

class AddProjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CZPickerViewDelegate, CZPickerViewDataSource, ProjectAPIHelperDelegate {
    
    let cellIdentifier1 = "NewProjectNameCell"
    let cellIdentifier2 = "AddProjectAddWatchersCell"
    let cellIdentifier3 = "AddProjectWatcherCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: AddProjectVCDelegate?
    
    var projectName: String = ""
    var watchers: [String] = []
    
    var friends: [[String: String]] = []
    
    let friendsMapDict = FriendModelHelper().getFriendsMapDict()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friends = FriendModelHelper().getAllFriendList()
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func doneButtonOnClick(sender: AnyObject) {
        if projectName != "" {
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            let projectAPIHelper = ProjectAPIHelper()
            projectAPIHelper.delegate = self
            projectAPIHelper.addProject(projectName, watchers: watchers)
        }
    }
    
    @IBAction func cancelButtonOnClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        projectName = textField.text!
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        projectName = textField.text!
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        projectName = textField.text!
        return true
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else {
            return self.watchers.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier1) as! NewProjectTableViewCell
            cell.projectNameTextField.delegate = self
            cell.projectNameTextField.becomeFirstResponder()
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier2)!
            cell.imageView?.image = UIImage(named: "update-add_watcher")
            cell.textLabel?.text = "Add Watchers"
            cell.detailTextLabel?.text = String(self.watchers.count)
            return cell
        } else {
            let username = self.watchers[indexPath.row]
            let nickname = self.friendsMapDict[username]
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier3)!
            cell.imageView?.image = UIImage(named: "watcher")
            cell.textLabel?.text = nickname
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 1 {
            self.showAddWatchersPickerView()
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 10
        } else {
            return 20
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 {
            let title = "Watchers Added"
            return title
        } else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 1 {
            let title = "Any Action under this project will add the watchers as default"
            return title
        } else {
            return nil
        }
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
    
    func didAddProject() {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.dismissViewControllerAnimated(true) { () -> Void in
            self.delegate?.didAddNewProject()
        }
    }
    
    func failAddProject() {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
}