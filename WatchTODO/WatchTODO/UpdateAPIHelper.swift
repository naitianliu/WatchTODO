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
        }
    }
    
    func beforeSendRequest(index: String?) {
        
    }
    
    func afterReceiveResponse(responseData: AnyObject, index: String?) {
        print(responseData)
        let resDict = responseData as! [String: AnyObject]
        let updatedFriendList = resDict["updated_friends"] as! [[String: AnyObject]]
        self.handleUpdatedFriends(updatedFriendList)
    }
    
    func apiReceiveError(error: ErrorType) {
        
    }
    
}