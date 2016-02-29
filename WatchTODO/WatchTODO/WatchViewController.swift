//
//  WatchViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/16/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import SDWebImage
import CNPPopupController
import SVPullToRefresh

class WatchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WatchAPIHelperDelegate {
    
    let cellIdentifier_WatchUpdate = "WatchUpdateCell"
    let cellIdentifier_WatchByFriend = "WatchByFriendCell"

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var popupController: CNPPopupController = CNPPopupController()
    
    var data: [[String: AnyObject]] = []
    var dataDictArray: [String: [[String: AnyObject]]]!
    var usernameList: [String] = []
    
    var data0: [[String: AnyObject]] = []
    
    let actionItemModelHelper = ActionItemModelHelper(me: false)
    let updateModelHelper = UpdateModelHelper()
    let watchAPIHelper = WatchAPIHelper()
    
    var selectedActionId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.watchAPIHelper.delegate = self
        
        self.segmentedControl.selectedSegmentIndex = 0
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        self.tableView.addPullToRefreshWithActionHandler { () -> Void in
            self.watchAPIHelper.getUpdatedWatchList()
        }
        self.reloadTable()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedControlValueChanged(sender: AnyObject) {
        self.reloadTable()
    }
    
    func reloadTable() {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            data0 = self.updateModelHelper.getUpdateList()
        } else {
            data = self.actionItemModelHelper.getFriendsPendingItems()
            let resultTup = SortActionItemListHelper().dividedByFriend(data)
            dataDictArray = resultTup.0
            usernameList = resultTup.1
        }
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            return 1
        } else {
            return self.usernameList.count
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            return data0.count
        } else {
            let username = self.usernameList[section]
            let itemArray: [[String: AnyObject]] = self.dataDictArray[username]!
            return itemArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            let rowDict: [String: AnyObject] = self.data0[indexPath.row]
            let actionId: String = rowDict["actionId"] as! String
            let timestamp: String = rowDict["timestamp"] as! String
            let code: String = rowDict["code"] as! String
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier_WatchUpdate) as! WatchUpdateTableViewCell
            if let actionInfo = self.actionItemModelHelper.getActionInfoByActionId(actionId) {
                cell.actionContentLabel.text = actionInfo["content"] as? String
                cell.creatorLabel.text = actionInfo["nickname"] as? String
                let priority: Int = actionInfo["priority"] as! Int
                cell.priority = priority
            }
            cell.nameLabel.text = rowDict["updatedBy"] as? String
            cell.updateLabel.text = rowDict["message"] as? String
            cell.code = code
            cell.timeLabel.text = DateTimeHelper().convertEpochToHumanFriendlyTime(timestamp)
            return cell
        } else {
            let username = self.usernameList[indexPath.section]
            let itemArray: [[String: AnyObject]] = self.dataDictArray[username]!
            let rowDict = itemArray[indexPath.row]
            let content = rowDict["content"] as! String
            let status = rowDict["status"] as! Int
            let priority = rowDict["priority"] as! Int
            let dueDate = rowDict["dueDate"] as! String
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier_WatchByFriend) as! WatchByFriendTableViewCell
            cell.actionContentLabel.text = content
            cell.dateLabel.text = DateTimeHelper().convertEpochToHumanFriendlyDay(dueDate)
            cell.status = status
            cell.priority = priority
            return cell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            return nil
        } else {
            return self.usernameList[section]
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if self.segmentedControl.selectedSegmentIndex == 0 {
            let rowDict: [String: AnyObject] = self.data0[indexPath.row]
            let actionId: String = rowDict["actionId"] as! String
            selectedActionId = actionId
        } else {
            let username = self.usernameList[indexPath.section]
            let itemArray: [[String: AnyObject]] = self.dataDictArray[username]!
            let rowDict = itemArray[indexPath.row]
            let actionId = rowDict["uuid"] as! String
            selectedActionId = actionId
        }
        let todoListStoryboard = UIStoryboard(name: "MyTodoList", bundle: nil)
        let commentsVC = todoListStoryboard.instantiateViewControllerWithIdentifier("CommentsViewController") as! CommentsViewController
        commentsVC.actionId = selectedActionId!
        self.navigationController?.pushViewController(commentsVC, animated: true)
    }
    
    func didUpdateWatchItemList() {
        self.reloadTable()
        self.tableView.pullToRefreshView.stopAnimating()
    }

}
