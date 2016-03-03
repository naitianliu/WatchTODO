//
//  MyTodoListViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/16/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import Toast
import CZPicker
import DZNEmptyDataSet

class MyTodoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CZPickerViewDelegate, CZPickerViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, AddActionVCDelegate {
    
    let colorP1: UIColor = UIColor.redColor()
    let colorP2: UIColor = UIColor.orangeColor()
    let colorP3: UIColor = UIColor.yellowColor()
    let colorP4: UIColor = UIColor.grayColor()
    
    var data: [[String: AnyObject]]!
    var dataDictArray: [String: [[String: AnyObject]]]!
    
    let actionItemCellIdentifier = "TodoActionItemCell"
    let unfoldCellIdentifier = "TodoUnfoldCell"
    
    let actionItemModelHelper = ActionItemModelHelper(me: true)
    let sortActionItemListHelper = SortActionItemListHelper()
    
    var sectionKeyList: [String]!
    var sectionKeyTitleMapDict: [String: String]!
    
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var selectedCellIndexPath: NSIndexPath?
    var selectedActionId: String?
    
    var selectedProjectId: String?
    var selectedCategory: String?
    
    var toDeleteCellIndexPath: NSIndexPath?
    
    var friends: [[String: String]] = []
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        friends = FriendModelHelper().getAllFriendList()
        
        selectedCategory = "today"
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        
        self.setupDisplayItems()
        
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        UpdateAPIHelper().getUpdatedInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupDisplayItems() {
        selectedCellIndexPath = nil
        if let projectId = selectedProjectId {
            data = actionItemModelHelper.getMyPendingItems(projectId)
            selectedCategory = nil
        } else {
            data = actionItemModelHelper.getMyPendingItems(nil)
        }
        let dataTup = sortActionItemListHelper.divideByDate(data, category: selectedCategory)
        dataDictArray = dataTup.0
        sectionKeyList = dataTup.1
        sectionKeyTitleMapDict = sortActionItemListHelper.getSectionKeyTitleMappingDict(selectedCategory)
        tableView.reloadData()
    }
    
    @IBAction func showSideMenuButtonOnClick(sender: AnyObject) {
        appDelegate.drawerController.toggleDrawerSide(.Left, animated: true) { (complete) -> Void in
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CommentSegue" {
            let commentVC = segue.destinationViewController as! CommentsViewController
            let sectionKey = sectionKeyList[selectedCellIndexPath!.section]
            let dataArray: [[String: AnyObject]] = dataDictArray[sectionKey]!
            let uuid: String = dataArray[selectedCellIndexPath!.row]["uuid"] as! String
            commentVC.actionId = uuid
        }
    }
    
    func cellCompleteButtonOnClick(sender: UIButton) {
        let cell = sender.superview?.superview as! TodoActionItemTableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        let sectionKey = sectionKeyList[indexPath.section]
        let dataArray: [[String: AnyObject]] = dataDictArray[sectionKey]!
        // update db
        let uuid: String = dataArray[indexPath.row]["uuid"] as! String
        actionItemModelHelper.updateActionStatus(uuid, status: 2)
        // show toast
        let content = dataArray[indexPath.row]["content"] as! String
        let toastStyle = CSToastStyle(defaultStyle: ())
        toastStyle.titleColor = UIColor.greenColor()
        self.tableView.makeToast(content, duration: 3.0, position: CSToastPositionBottom, title: "Action Completed", image: UIImage(named: "checked"), style: toastStyle) { (didTap) -> Void in
            
        }
        // remove cell with animation
        dataDictArray[sectionKey]?.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionKeyList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionKey = sectionKeyList[section]
        let dataArray: [[String: AnyObject]] = dataDictArray[sectionKey]!
        var number = dataArray.count
        if let selectedIndexPath = selectedCellIndexPath {
            if selectedIndexPath.section == section {
                number += 1
            }
        }
        return number
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let selectedIndexPath = selectedCellIndexPath {
            if selectedIndexPath.section == indexPath.section && indexPath.row == selectedIndexPath.row + 1 {
                return self.renderUnfoldCell(tableView, indexPath: indexPath)
            } else {
                return self.renderActionItemCell(tableView, indexPath: indexPath)
            }
        } else {
            return self.renderActionItemCell(tableView, indexPath: indexPath)
        }
    }
    
    func renderActionItemCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(actionItemCellIdentifier) as! TodoActionItemTableViewCell
        let sectionKey = sectionKeyList[indexPath.section]
        let dataArray: [[String: AnyObject]] = dataDictArray[sectionKey]!
        var rowDict: [String: AnyObject]!
        if let selectedIndexPath = selectedCellIndexPath {
            if selectedIndexPath.row < indexPath.row {
                rowDict = dataArray[indexPath.row - 1]
            } else {
                rowDict = dataArray[indexPath.row]
            }
        } else {
            rowDict = dataArray[indexPath.row]
        }
        let content = rowDict["content"] as! String
        var project = rowDict["projectName"] as! String
        let priority = rowDict["priority"] as! Int
        let status = rowDict["status"] as! Int
        if project == "" {
            project = "Inbox"
        }
        cell.actionContentLabel.text = content
        cell.projectLabel.text = project
        switch priority {
        case 1:
            cell.priorityView.backgroundColor = colorP1
            break
        case 2:
            cell.priorityView.backgroundColor = colorP2
            break
        case 3:
            cell.priorityView.backgroundColor = colorP3
            break
        case 4:
            cell.priorityView.backgroundColor = colorP4
            break
        default:
            break
        }
        switch status {
        case 0:
            cell.updateButton.setBackgroundImage(UIImage(named: "unchecked"), forState: .Normal)
            break
        case 1:
            cell.updateButton.setBackgroundImage(UIImage(named: "update-progress"), forState: .Normal)
            break
        case 2:
            cell.updateButton.setBackgroundImage(UIImage(named: "update-complete"), forState: .Normal)
            break
        default:
            break
        }
        cell.updateButton.addTarget(self, action: Selector("updateButtonOnClick:"), forControlEvents: .TouchUpInside)
        cell.commentImageView.hidden = true
        return cell
    }
    
    func renderUnfoldCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        // let cell = tableView.dequeueReusableCellWithIdentifier(unfoldCellIdentifier) as! TodoUnfoldTableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier(unfoldCellIdentifier, forIndexPath: indexPath) as! TodoUnfoldTableViewCell
        cell.addWatcherButton.action = Selector("addWatcherButtonOnClick:")
        cell.editButton.action = Selector("editActionButtonOnClick:")
        cell.completeButton.action = Selector("completeButtonOnClick:")
        cell.deleteButton.action = Selector("deleteButtonOnClick:")
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionKey = sectionKeyList[section]
        let sectionTitle = sectionKeyTitleMapDict[sectionKey]
        return sectionTitle
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if let selectedIndexPath = selectedCellIndexPath {
            if selectedIndexPath.section == indexPath.section && indexPath.row == selectedIndexPath.row + 1 {
                return false
            } else {
                return true
            }
        } else {
            return true
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if let selectedIndexPath = selectedCellIndexPath {
                if selectedIndexPath == indexPath {
                    self.performDidSelectRow(tableView, didSelectRowAtIndexPath: indexPath)
                }
            }
            toDeleteCellIndexPath = indexPath
            self.showConfirmDeleteActionItemActionSheet()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performDidSelectRow(tableView, didSelectRowAtIndexPath: indexPath)
    }
    
    private func performDidSelectRow(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if selectedCellIndexPath == nil {
            selectedCellIndexPath = indexPath
            let targetIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
            tableView.insertRowsAtIndexPaths([targetIndexPath], withRowAnimation: .Top)
        } else if selectedCellIndexPath == indexPath {
            selectedCellIndexPath = nil
            let targetIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
            tableView.deleteRowsAtIndexPaths([targetIndexPath], withRowAnimation: .Top)
        } else if selectedCellIndexPath == NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section) {
            
        } else {
            let indexPath0 = selectedCellIndexPath!
            if indexPath0.section != indexPath.section {
                let targetIndexPath0 = NSIndexPath(forRow: indexPath0.row + 1, inSection: indexPath0.section)
                let targetIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
                tableView.beginUpdates()
                selectedCellIndexPath = nil
                tableView.deleteRowsAtIndexPaths([targetIndexPath0], withRowAnimation: .Top)
                selectedCellIndexPath = indexPath
                tableView.insertRowsAtIndexPaths([targetIndexPath], withRowAnimation: .Top)
                tableView.endUpdates()
            } else if indexPath0.row < indexPath.row {
                let targetIndexPath0 = NSIndexPath(forRow: indexPath0.row + 1, inSection: indexPath0.section)
                let targetIndexPath = NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)
                tableView.beginUpdates()
                selectedCellIndexPath = nil
                tableView.deleteRowsAtIndexPaths([targetIndexPath0], withRowAnimation: .Top)
                selectedCellIndexPath = NSIndexPath(forRow: targetIndexPath.row - 1, inSection: targetIndexPath.section)
                tableView.insertRowsAtIndexPaths([targetIndexPath], withRowAnimation: .Top)
                tableView.endUpdates()
            } else if indexPath0.row > indexPath.row {
                let targetIndexPath0 = NSIndexPath(forRow: indexPath0.row + 1, inSection: indexPath0.section)
                let targetIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
                tableView.beginUpdates()
                selectedCellIndexPath = nil
                tableView.deleteRowsAtIndexPaths([targetIndexPath0], withRowAnimation: .Top)
                selectedCellIndexPath = indexPath
                tableView.insertRowsAtIndexPaths([targetIndexPath], withRowAnimation: .Top)
                tableView.endUpdates()
            }
        }
    }
    
    private func showConfirmDeleteActionItemActionSheet() {
        let alertController = UIAlertController(title: "Delete Action", message: "Are you sure you want to delete this action?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive) { (action) -> Void in
            if let indexPath = self.toDeleteCellIndexPath {
                let sectionKey = self.sectionKeyList[indexPath.section]
                let dataArray: [[String: AnyObject]] = self.dataDictArray[sectionKey]!
                let rowDict = dataArray[indexPath.row]
                let actionId: String = rowDict["uuid"] as! String
                TodoListAPIHelper().removeAction(actionId)
                self.dataDictArray[sectionKey]!.removeAtIndex(indexPath.row)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            
        }
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func updateButtonOnClick(sender: UIButton!) {
        let cell = sender.superview?.superview as! TodoActionItemTableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        let sectionKey = sectionKeyList[indexPath.section]
        let dataArray: [[String: AnyObject]] = dataDictArray[sectionKey]!
        var row: Int = indexPath.row
        if let selectedIndexPath = selectedCellIndexPath {
            if selectedIndexPath.section == indexPath.section && selectedIndexPath.row < indexPath.row {
                row = indexPath.row - 1
            }
        }
        // update db
        let uuid: String = dataArray[row]["uuid"] as! String
        let status: Int = dataArray[row]["status"] as! Int
        var newStatus: Int = 0
        if status == 0 {
            newStatus = 1
        } else if status == 1 {
            newStatus = 2
        } else {
            newStatus = 2
        }
        dataDictArray[sectionKey]![row]["status"] = newStatus
        tableView.reloadData()
        TodoListAPIHelper().updateStatus(uuid, status: newStatus)
        selectedActionId = uuid
    }
    
    func addWatcherButtonOnClick(sender: UIBarButtonItem!) {
        friends = FriendModelHelper().getAllFriendList()
        let picker: CZPickerView = CZPickerView(headerTitle: "Select friends to watch", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        picker.delegate = self
        picker.dataSource = self
        picker.allowMultipleSelection = true
        picker.headerBackgroundColor = const_ThemeColor
        picker.confirmButtonBackgroundColor = const_ThemeColor
        let sectionKey = sectionKeyList[selectedCellIndexPath!.section]
        let dataArray: [[String: AnyObject]] = dataDictArray[sectionKey]!
        let actionId: String = dataArray[selectedCellIndexPath!.row]["uuid"] as! String
        let watcherUsernames: [String] = WatcherModelHelper().getWatchers(actionId)
        selectedActionId = actionId
        var selectedRows: [Int] = []
        for (var i=0; i<self.friends.count; i++) {
            let username = friends[i]["username"]!
            if watcherUsernames.contains(username) {
                selectedRows.append(i)
            }
        }
        picker.setSelectedRows(selectedRows)
        picker.show()
        
    }
    
    func editActionButtonOnClick(sender: UIBarButtonItem!) {
        let sectionKey = sectionKeyList[selectedCellIndexPath!.section]
        let dataArray: [[String: AnyObject]] = dataDictArray[sectionKey]!
        let actionId: String = dataArray[selectedCellIndexPath!.row]["uuid"] as! String
        let AddActionNC = self.storyboard!.instantiateViewControllerWithIdentifier("AddActionNavigationController") as! UINavigationController
        AddActionNC.modalTransitionStyle = .CoverVertical
        let AddActionVC = AddActionNC.viewControllers[0] as! AddActionViewController
        AddActionVC.delegate = self
        AddActionVC.actionId = actionId
        self.presentViewController(AddActionNC, animated: true) { () -> Void in
            
        }
    }
    
    func completeButtonOnClick(sender: UIBarButtonItem!) {
        if let indexPath = self.selectedCellIndexPath {
            let sectionKey = sectionKeyList[indexPath.section]
            let dataArray: [[String: AnyObject]] = dataDictArray[sectionKey]!
            var row: Int = indexPath.row
            if let selectedIndexPath = selectedCellIndexPath {
                if selectedIndexPath.section == indexPath.section && selectedIndexPath.row < indexPath.row {
                    row = indexPath.row - 1
                }
            }
            // update db
            let uuid: String = dataArray[row]["uuid"] as! String
            let status: Int = dataArray[row]["status"] as! Int
            var newStatus: Int = 0
            if status == 0 || status == 1{
                newStatus = 2
                dataDictArray[sectionKey]![row]["status"] = newStatus
                tableView.reloadData()
                TodoListAPIHelper().updateStatus(uuid, status: newStatus)
                selectedActionId = uuid
            }
            self.performDidSelectRow(self.tableView, didSelectRowAtIndexPath: indexPath)
        }
    }
    
    func deleteButtonOnClick(sender: UIBarButtonItem!) {
        if let indexPath = self.selectedCellIndexPath {
            self.performDidSelectRow(self.tableView, didSelectRowAtIndexPath: indexPath)
            toDeleteCellIndexPath = indexPath
            self.showConfirmDeleteActionItemActionSheet()
        }
    }
    
    func numberOfRowsInPickerView(pickerView: CZPickerView!) -> Int {
        return friends.count
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
        WatchAPIHelper().addWatchers(selectedActionId!, watchers: watcherArray)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "empty-check")
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text: String = "No Pending Action"
        let attributes: [String: AnyObject] = [NSFontAttributeName: UIFont.boldSystemFontOfSize(18), NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func didAddAction(actionId: String?, actionContent: String?, projectId: String?, projectName: String?, dueDate: String?, deferDate: String?, priority: Int?, watchers: [String]) {
        if let content = actionContent {
            TodoListAPIHelper().addAction(actionId, content: content, projectId: projectId, projectName: projectName, dueDate: dueDate, deferDate: deferDate, priority: priority, watchers: watchers)
            self.setupDisplayItems()
        }
    }
}
