//
//  RenderTodoCellHelper.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/26/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit


class RenderTodoCellHelper: NSObject {
    
    let actionItemCellIdentifier = "TodoActionItemCell"
    let unfoldCell = "TodoUnfoldCell"
    
    var tableView: UITableView!
    var indexPath: NSIndexPath!
    
    init(tableView: UITableView, indexPath: NSIndexPath) {
        self.tableView = tableView
        self.indexPath = indexPath
    }
}