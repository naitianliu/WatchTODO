//
//  FriendAPIHelper.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 2/5/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation

@objc protocol FriendAPIHelperDelegate {
    optional func didGetUserListByKeyword(userList: [[String: String]])
    optional func didSendFriendRequest()
    optional func didFailCallFriendAPI()
}

class FriendAPIHelper: CallAPIHelperDelegate {
    
    let apiURL_GetFriendList = "\(const_APIEndpoint)friends/get_friend_list/"
    let apiURL_GetUserListByKeyword = "\(const_APIEndpoint)friends/get_user_list_by_keyword/"
    let apiURL_SendFriendRequest = "\(const_APIEndpoint)friends/send_friend_request/"
    let apiURL_AcceptFriendRequest = "\(const_APIEndpoint)friends/accept_friend_request/"
    let apiURL_GetPendingFriendRequestList = "\(const_APIEndpoint)friends/get_pending_friend_request_list/"
    
    let index_GetFriendList = "GetFriendList"
    let index_GetUserListByKeyword = "GetUserListByKeyword"
    let index_SendFriendRequest = "SendFriendRequest"
    let index_AcceptFriendRequest = "AcceptFriendRequest"
    let index_GetPendingFriendRequestList = "GetPendingFriendRequestList"
    
    let friendModelHelper = FriendModelHelper()
    
    var delegate: FriendAPIHelperDelegate?
    
    init() {
        
    }
    
    func getFriendList() {
        CallAPIHelper(url: apiURL_GetFriendList, data: nil, delegate: self).GET(index_GetFriendList)
    }
    
    func getUserListByKeyword(keyword: String) {
        let data: [String: AnyObject] = ["keyword": keyword]
        CallAPIHelper(url: apiURL_GetUserListByKeyword, data: data, delegate: self).GET(index_GetUserListByKeyword)
    }
    
    func sendFriendRequest(username: String, nickname: String) {
        let userInfo = ["username": username, "nickname": nickname]
        friendModelHelper.sendRequest(userInfo)
        let data: [String: AnyObject] = ["friend_username": username]
        CallAPIHelper(url: apiURL_SendFriendRequest, data: data, delegate: self).GET(index_SendFriendRequest)
    }
    
    func acceptFriendRequest(username: String) {
        friendModelHelper.updateStatus(username)
        let data: [String: AnyObject] = ["friend_username": username]
        CallAPIHelper(url: apiURL_AcceptFriendRequest, data: data, delegate: self).GET(index_AcceptFriendRequest)
    }
    
    func beforeSendRequest(index: String?) {
        
    }
    
    func afterReceiveResponse(responseData: AnyObject, index: String?) {
        if index == index_GetFriendList {
            let resDict = responseData as! [String: [[String: String]]]
            for userInfo in resDict["friend_list"]! {
                self.friendModelHelper.addFriend(userInfo)
            }
        } else if index == index_GetUserListByKeyword {
            let result = responseData as! [String: AnyObject]
            let userListByNickname = result["user_list_by_nickname"] as! [[String: String]]
            let userListByUsername = result["user_list_by_username"] as! [[String: String]]
            let userList: [[String: String]] = userListByNickname + userListByUsername
            self.delegate?.didGetUserListByKeyword!(userList)
        } else if index == index_SendFriendRequest {
            self.delegate?.didSendFriendRequest!()
        }
    }
    
    func apiReceiveError(error: ErrorType) {
        delegate?.didFailCallFriendAPI!()
    }
    
}