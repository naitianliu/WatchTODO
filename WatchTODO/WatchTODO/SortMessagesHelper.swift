//
//  SortMessagesHelper.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 2/18/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation

class SortMessagesHelper {
    
    init() {
        
    }
    
    func sortByTime() -> [[String: String]] {
        var resultMessageList: [[String: String]] = []
        
        return resultMessageList
    }
    
    func getUnsortedCommentMessages() -> [[String: AnyObject]] {
        let actionIdList: [String] = ActionItemModelHelper(me: false).getAllPendingActionIdList()
        let messages = CommentModelHelper().getLatestCommentsByActions(actionIdList)
        return messages
    }
    
}