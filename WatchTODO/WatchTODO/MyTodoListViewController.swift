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
    
    var data: [[String: AnyObject]]!
    var dataDictArray: [String: [[String: AnyObject]]]!
    
    let actionItemCellIdentifier = "TodoActionItemCell"
    
    let actionItemModelHelper = ActionItemModelHelper()
    let sortActionItemListHelper = SortActionItemListHelper()
    
    var sectionKeyList: [String]!
    var sectionKeyTitleMapDict: [String: String]!
    
    var popupController: CNPPopupController = CNPPopupController()
    
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
        actionItemModelHelper.completeActionItem(uuid)
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
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TodoActionItemCell") as! TodoActionItemTableViewCell
        let sectionKey = sectionKeyList[indexPath.section]
        let dataArray: [[String: AnyObject]] = dataDictArray[sectionKey]!
        let rowDict = dataArray[indexPath.row]
        let content = rowDict["content"] as! String
        var project = rowDict["project"] as! String
        if project == "" {
            project = "Inbox"
        }
        cell.actionContentLabel.text = content
        cell.projectLabel.text = project
        cell.completeButton.addTarget(self, action: Selector("cellCompleteButtonOnClick:"), forControlEvents: .TouchUpInside)
        cell.flagButton.addTarget(self, action: Selector("cellFlagButtonOnClick:"), forControlEvents: .TouchUpInside)
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
    
    func didAddAction(actionContent: String?, project: String?, dueDate: String?, deferDate: String?) {
        if let content = actionContent {
            print("Add Action into db")
            actionItemModelHelper.addActionItem(content, project: project, dueDate: dueDate, deferDate: deferDate)
            data = actionItemModelHelper.getAllPendingItems()
            dataDictArray = sortActionItemListHelper.divideByDate(data)
            tableView.reloadData()
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
