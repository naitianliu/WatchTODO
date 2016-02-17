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
    
    var popupController: CNPPopupController = CNPPopupController()
    
    var data: [[String: AnyObject]] = []
    
    let actionItemModelHelper = ActionItemModelHelper(me: false)
    let watchAPIHelper = WatchAPIHelper()
    
    var selectedActionId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.watchAPIHelper.delegate = self

        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        self.reloadTable()
        
        self.tableView.addPullToRefreshWithActionHandler { () -> Void in
            self.watchAPIHelper.getUpdatedWatchList()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTable() {
        data = self.actionItemModelHelper.getFriendsPendingItems()
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let rowDict = data[indexPath.row]
        let name = rowDict["nickname"] as! String
        let content = rowDict["content"] as! String
        let cell = tableView.dequeueReusableCellWithIdentifier("WatchCell") as! WatchTableViewCell
        cell.nameLabel.text = name
        cell.contentLabel.text = content
        return cell
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
