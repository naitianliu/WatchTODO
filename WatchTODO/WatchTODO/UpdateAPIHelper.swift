//
//  UpdateAPIHelper.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 2/4/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation

@objc protocol UpdateAPIHelperDelegate {
    optional func didFriendsUpdated()
    optional func didCommentsUpdated(number: Int)
}

class UpdateAPIHelper: CallAPIHelperDelegate {
    
    let apiURL_GetUpdatedInfo = "\(const_APIEndpoint)todo/get_updated_info/"
    
    var delegate: UpdateAPIHelperDelegate?
    
    var myUsername: String = ""
    
    let friendModelHelper = FriendModelHelper()
    let commentModelHelper = CommentModelHelper()
    
    init() {
        
    }
    
    func getUpdatedInfo() {
        if let username = UserDefaultsHelper().getUsername() {
            self.myUsername = username
            let data: [String: AnyObject] = ["timestamp": UserDefaultsHelper().getLastUpdatedTimestamp()]
            CallAPIHelper(url: apiURL_GetUpdatedInfo, data: data, delegate: self).GET(nil)
        }
    }
    
    private func handleUpdatedFriends(updatedFriendList: [[String: AnyObject]]) {
        if updatedFriendList.count != 0 {
            for rowDict in updatedFriendList {
                let accepterUserInfo = rowDict["accepter"] as! [String: String]
                let requesterUserInfo = rowDict["requester"] as! [String: String]
                let pending = rowDict["pending"] as! Bool
                let accepterUsername = accepterUserInfo["username"]
                let requesterUsername = requesterUserInfo["username"]
                if accepterUsername == myUsername && pending {
                    friendModelHelper.addPendingFriend(requesterUserInfo, role: "requester")
                } else if requesterUsername == myUsername && pending {
                    friendModelHelper.addPendingFriend(accepterUserInfo, role: "accepter")
                } else if requesterUsername == myUsername && !pending {
                    friendModelHelper.updateStatus(accepterUsername!)
                }
            }
            delegate?.didFriendsUpdated!()
        }
    }
    
    private func handleUpdatedComments(updatedCommentsList: [[String: AnyObject]]) {
        var actionIdList: [String] = []
        if updatedCommentsList.count != 0 {
            for rowDict in updatedCommentsList {
                let commentId = rowDict["comment_id"] as! String
                let actionId = rowDict["action_id"] as! String
                let message = rowDict["message"] as! String
                let timestampString = rowDict["timestamp"] as! String
                let timestamp = Int(timestampString)
                let username = rowDict["username"] as! String
                if !actionIdList.contains(actionId) {
                    actionIdList.append(actionId)
                }
                self.commentModelHelper.addComment(commentId, actionId: actionId, message: message, username: username, timestamp: timestamp, read: false)
            }
            self.delegate?.didCommentsUpdated!(actionIdList.count)
        }
    }
    
    func beforeSendRequest(index: String?) {
        
    }
    
    func afterReceiveResponse(responseData: AnyObject, index: String?) {
        let resDict = responseData as! [String: AnyObject]
        //
        let updatedFriendList = resDict["updated_friends"] as! [[String: AnyObject]]
        self.handleUpdatedFriends(updatedFriendList)
        //
        let updatedWatchActionList = resDict["updated_actions_watch"] as! [[String: AnyObject]]
        WatchAPIHelper().updateWatchActionList(updatedWatchActionList)
        //
        let updatedCommentsListMe = resDict["updated_comments_me"] as! [[String: AnyObject]]
        let updatedCommentsListWatch = resDict["updated_comments_watch"] as! [[String: AnyObject]]
        self.handleUpdatedComments(updatedCommentsListMe + updatedCommentsListWatch)
        //
        let timestamp = resDict["current_timestamp"] as! String
        UserDefaultsHelper().updateLastUpdatedTimestamp(timestamp)
    }
    
    func apiReceiveError(error: ErrorType) {
        
    }
    
}