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

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var popupController: CNPPopupController = CNPPopupController()
    
    var data: [[String: AnyObject]] = []
    var dataDictArray: [String: [[String: AnyObject]]]!
    var usernameList: [String] = []
    
    let actionItemModelHelper = ActionItemModelHelper(me: false)
    let watchAPIHelper = WatchAPIHelper()
    
    var selectedActionId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.watchAPIHelper.delegate = self
        
        self.segmentedControl.selectedSegmentIndex = 1

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
        
    }
    
    func reloadTable() {
        data = self.actionItemModelHelper.getFriendsPendingItems()
        let resultTup = SortActionItemListHelper().dividedByFriend(data)
        dataDictArray = resultTup.0
        usernameList = resultTup.1
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.usernameList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let username = self.usernameList[section]
        let itemArray: [[String: AnyObject]] = self.dataDictArray[username]!
        return itemArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let username = self.usernameList[indexPath.section]
        let itemArray: [[String: AnyObject]] = self.dataDictArray[username]!
        let rowDict = itemArray[indexPath.row]
        let content = rowDict["content"] as! String
        let status = rowDict["status"] as! Int
        
        let cell = tableView.dequeueReusableCellWithIdentifier("WatchByFriendCell")!
        cell.textLabel!.text = content
        switch status {
        case 0:
            cell.imageView?.image = UIImage(named: "dot-gray")
            break
        case 1:
            cell.imageView?.image = UIImage(named: "dot-yellow")
            break
        case 2:
            cell.imageView?.image = UIImage(named: "dot-green")
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.usernameList[section]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let rowDict = data[indexPath.row]
        print(rowDict)
        let actionId = rowDict["uuid"] as! String
        selectedActionId = actionId
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
