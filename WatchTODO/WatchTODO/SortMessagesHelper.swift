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
    
    func getTimeSortedMessages() -> [[String: AnyObject]] {
        let unsortedMessages: [[String: AnyObject]] = self.getCommentMessages() + self.getFriendMessages()
        let resultMessageList: [[String: AnyObject]] = unsortedMessages.sort { (element1, element2) -> Bool in
            let timestamp1: String = element1["timestamp"] as! String
            let timestamp2: String = element2["timestamp"] as! String
            let result: Bool = Int(timestamp1)! > Int(timestamp2)!
            return result
        }
        return resultMessageList
    }
    
    private func getCommentMessages() -> [[String: AnyObject]] {
        let actionIdList: [String] = ActionItemModelHelper(me: false).getAllPendingActionIdList()
        let messages = CommentModelHelper().getLatestCommentsByActions(actionIdList)
        return messages
    }
    
    private func getFriendMessages() -> [[String: AnyObject]] {
        var tempTime: Int = 0
        for friend in FriendModelHelper().getPendingFriendList() {
            let timestampInt: Int = Int(friend["timestamp"]!)!
            if timestampInt > tempTime {
                tempTime = timestampInt
            }
        }
        if tempTime != 0 {
            let friendMessage: [String: AnyObject] = ["type": "friend", "message": "Friend Invitation Updated", "timestamp": String(tempTime)]
            return [friendMessage]
        } else {
            return []
        }
        
    }
    
}