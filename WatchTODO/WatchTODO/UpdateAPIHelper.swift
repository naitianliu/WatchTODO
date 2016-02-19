//
//  UpdateAPIHelper.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 2/4/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation

protocol UpdateAPIHelperDelegate {
    func didFriendsUpdated()
}

class UpdateAPIHelper: CallAPIHelperDelegate {
    
    let apiURL_GetUpdatedInfo = "\(const_APIEndpoint)todo/get_updated_info/"
    
    var delegate: UpdateAPIHelperDelegate?
    
    let myUsername: String = UserDefaultsHelper().getUsername()!
    
    let friendModelHelper = FriendModelHelper()
    let commentModelHelper = CommentModelHelper()
    
    init() {
        
    }
    
    func getUpdatedInfo() {
        let data: [String: AnyObject] = ["timestamp": "0"]
        CallAPIHelper(url: apiURL_GetUpdatedInfo, data: data, delegate: self).GET(nil)
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
            delegate?.didFriendsUpdated()
        }
    }
    
    private func handleUpdatedComments(updatedCommentsList: [[String: AnyObject]]) {
        if updatedCommentsList.count != 0 {
            for rowDict in updatedCommentsList {
                let commentId = rowDict["comment_id"] as! String
                let actionId = rowDict["action_id"] as! String
                let message = rowDict["message"] as! String
                let timestamp = rowDict["timestamp"] as! String
                let username = rowDict["username"] as! String
                self.commentModelHelper.addComment(commentId, actionId: actionId, message: message, username: username, timestamp: timestamp, read: false)
            }
        }
    }
    
    func beforeSendRequest(index: String?) {
        
    }
    
    func afterReceiveResponse(responseData: AnyObject, index: String?) {
        let resDict = responseData as! [String: AnyObject]
        let updatedFriendList = resDict["updated_friends"] as! [[String: AnyObject]]
        self.handleUpdatedFriends(updatedFriendList)
        let updatedCommentsListMe = resDict["updated_comments_me"] as! [[String: AnyObject]]
        let updatedCommentsListWatch = resDict["updated_comments_watch"] as! [[String: AnyObject]]
        self.handleUpdatedComments(updatedCommentsListMe)
        self.handleUpdatedComments(updatedCommentsListWatch)
    }
    
    func apiReceiveError(error: ErrorType) {
        
    }
    
}