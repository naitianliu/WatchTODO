//
//  MyTodoListViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/16/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import ENSwiftSideMenu
import Toast
import CNPPopupController

class MyTodoListViewController: UIViewController, ENSideMenuDelegate, UITableViewDelegate, UITableViewDataSource, AddActionVCDelegate {
    
    let colorP1: UIColor = UIColor.redColor()
    let colorP2: UIColor = UIColor.orangeColor()
    let colorP3: UIColor = UIColor.yellowColor()
    let colorP4: UIColor = UIColor.grayColor()
    
    var data: [[String: AnyObject]]!
    var dataDictArray: [String: [[String: AnyObject]]]!
    
    let actionItemCellIdentifier = "TodoActionItemCell"
    let unfoldCellIdentifier = "TodoUnfoldCell"
    
    let actionItemModelHelper = ActionItemModelHelper()
    let sortActionItemListHelper = SortActionItemListHelper()
    
    var sectionKeyList: [String]!
    var sectionKeyTitleMapDict: [String: String]!
    
    var popupController: CNPPopupController = CNPPopupController()
    
    var selectedCellIndexPath: NSIndexPath?
    
    var comments = [
        ["content": "In addition to supporting rich text, TTTAttributedLabel can automatically detect links for dates, addresses, URLs, phone numbers, transit information, and allows you to embed your own links."],
        ["content": "test test"]
    ]
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = actionItemModelHelper.getAllPendingItems()
        dataDictArray = sortActionItemListHelper.divideByDate(data)
        sectionKeyList = sortActionItemListHelper.getSectionKeyList()
        sectionKeyTitleMapDict = sortActionItemListHelper.getSectionKeyTitleMappingDict()

        self.sideMenuController()?.sideMenu?.delegate = self
        
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showSideMenuButtonOnClick(sender: AnyObject) {
        toggleSideMenuView()
    }

    @IBAction func addButtonOnClick(sender: AnyObject) {
        let AddActionNC = self.storyboard?.instantiateViewControllerWithIdentifier("AddActionNavigationController") as! UINavigationController
        AddActionNC.modalTransitionStyle = .CoverVertical
        let AddActionVC = AddActionNC.viewControllers[0] as! AddActionViewController
        AddActionVC.delegate = self
        self.presentViewController(AddActionNC, animated: true) { () -> Void in
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
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
    
    func cellFlagButtonOnClick(sender: UIButton) {
        let cell = sender.superview?.superview as! TodoActionItemTableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        self.showFlagPopupView(indexPath)
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
        let rowDict = dataArray[indexPath.row]
        let content = rowDict["content"] as! String
        var project = rowDict["project"] as! String
        let priority = rowDict["priority"] as! Int
        let dueDate = rowDict["dueDate"] as! String
        let status = rowDict["status"] as! Int
        if project == "" {
            project = "Inbox"
        }
        cell.actionContentLabel.text = content
        cell.projectLabel.text = project
        cell.dueLabel.text = dueDate
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
            cell.updateButton.setBackgroundImage(UIImage(named: "inprogress"), forState: .Normal)
            break
        case 2:
            cell.updateButton.setBackgroundImage(UIImage(named: "checked"), forState: .Normal)
            break
        default:
            break
        }
        cell.updateButton.addTarget(self, action: Selector("updateButtonOnClick:"), forControlEvents: .TouchUpInside)
        return cell
    }
    
    func renderUnfoldCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        // let cell = tableView.dequeueReusableCellWithIdentifier(unfoldCellIdentifier) as! TodoUnfoldTableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier(unfoldCellIdentifier, forIndexPath: indexPath) as! TodoUnfoldTableViewCell
        cell.contentLabel.text = comments[0]["content"]!
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if selectedCellIndexPath == nil {
            selectedCellIndexPath = indexPath
            let targetIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
            tableView.insertRowsAtIndexPaths([targetIndexPath], withRowAnimation: .Bottom)
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
                tableView.insertRowsAtIndexPaths([targetIndexPath], withRowAnimation: .Bottom)
                tableView.endUpdates()
            } else if indexPath0.row < indexPath.row {
                let targetIndexPath0 = NSIndexPath(forRow: indexPath0.row + 1, inSection: indexPath0.section)
                let targetIndexPath = NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)
                tableView.beginUpdates()
                selectedCellIndexPath = nil
                tableView.deleteRowsAtIndexPaths([targetIndexPath0], withRowAnimation: .Top)
                selectedCellIndexPath = NSIndexPath(forRow: targetIndexPath.row - 1, inSection: targetIndexPath.section)
                tableView.insertRowsAtIndexPaths([targetIndexPath], withRowAnimation: .Bottom)
                tableView.endUpdates()
            } else if indexPath0.row > indexPath.row {
                let targetIndexPath0 = NSIndexPath(forRow: indexPath0.row + 1, inSection: indexPath0.section)
                let targetIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
                tableView.beginUpdates()
                selectedCellIndexPath = nil
                tableView.deleteRowsAtIndexPaths([targetIndexPath0], withRowAnimation: .Top)
                selectedCellIndexPath = indexPath
                tableView.insertRowsAtIndexPaths([targetIndexPath], withRowAnimation: .Bottom)
                tableView.endUpdates()
            }
        }
    }
    
    func updateButtonOnClick(sender: UIButton!) {
        let cell = sender.superview?.superview as! TodoActionItemTableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        let sectionKey = sectionKeyList[indexPath.section]
        let dataArray: [[String: AnyObject]] = dataDictArray[sectionKey]!
        // update db
        let uuid: String = dataArray[indexPath.row]["uuid"] as! String
        let status: Int = dataArray[indexPath.row]["status"] as! Int
        var newStatus: Int = 0
        if status == 0 {
            newStatus = 1
        } else if status == 1 {
            newStatus = 2
        } else {
            newStatus = 2
        }
        dataDictArray[sectionKey]![indexPath.row]["status"] = newStatus
        tableView.reloadData()
        TodoListAPIHelper().updateStatus(uuid, status: newStatus)
    }
    
    func didAddAction(actionContent: String?, project: String?, dueDate: String?, deferDate: String?, priority: Int?) {
        if let content = actionContent {
            print("Add Action into db")
            actionItemModelHelper.addActionItem(content, project: project, dueDate: dueDate, deferDate: deferDate, priority: priority)
            data = actionItemModelHelper.getAllPendingItems()
            dataDictArray = sortActionItemListHelper.divideByDate(data)
            tableView.reloadData()
            TodoListAPIHelper().addAction(content, project: project, dueDate: dueDate, deferDate: deferDate, priority: priority)
        }
    }
    
    func showFlagPopupView(selectedIndexPath: NSIndexPath) {
        // title label
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraphStyle.alignment = NSTextAlignment.Center
        let title = NSAttributedString(string: "Ready to start", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(24), NSParagraphStyleAttributeName: paragraphStyle])
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0;
        titleLabel.attributedText = title
        // textfield
        let textField = UITextField.init(frame: CGRectMake(0, 0, 250, 35))
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.placeholder = "Leave a message"
        // button
        let button = CNPPopupButton(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        button.setTitle("FLAG", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        button.backgroundColor = UIColor.init(colorLiteralRed: 0.46, green: 0.8, blue: 1.0, alpha: 1.0)
        button.layer.cornerRadius = 4;
        button.selectionHandler = { (CNPPopupButton button) -> Void in
            self.popupController.dismissPopupControllerAnimated(true)
            print("Block for button: \(button.titleLabel?.text)")
        }
        self.popupController = CNPPopupController(contents: [titleLabel, textField, button])
        self.popupController.theme = CNPPopupTheme.defaultTheme()
        self.popupController.theme.popupStyle = .Centered
        self.popupController.presentPopupControllerAnimated(true)
    }
}
