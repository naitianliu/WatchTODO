//
//  CommentAPIHelper.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/30/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation

protocol CommentAPIHelperDelegate {
    func didGetCommentList()
}

class CommentAPIHelper: CallAPIHelperDelegate {
    
    let apiURL_AddComment = "\(const_APIEndpoint)comment/add_comment/"
    let apiURL_GetCommentList = "\(const_APIEndpoint)comment/get_comment_list/"
    
    let index_AddComment = "AddComment"
    let index_GetCommentList = "GetCommentList"
    
    var delegate: CommentAPIHelperDelegate?
    
    init() {
        
    }
    
    func addComment(uuid: String?, actionId: String, message: String) {
        let commentModelHelper = CommentModelHelper()
        let commentId = commentModelHelper.addComment(uuid, actionId: actionId, message: message, username: nil, timestamp: nil, read: true)
        let data: [String: AnyObject] = [
            "comment_id": commentId,
            "action_id": actionId,
            "message": message,
            "timestamp": commentModelHelper.timeNow
        ]
        CallAPIHelper(url: apiURL_AddComment, data: data, delegate: self).POST(index_AddComment)
    }
    
    func getCommentList(actionId: String) {
        let data: [String: AnyObject] = ["action_id": actionId]
        CallAPIHelper(url: apiURL_GetCommentList, data: data, delegate: self).GET(index_GetCommentList)
    }
    
    func beforeSendRequest(index: String?) {
        
    }
    
    func afterReceiveResponse(responseData: AnyObject, index: String?) {
        print(responseData)
        if index == index_AddComment {
            
        } else if index == index_GetCommentList {
            let commentModelHelper = CommentModelHelper()
            let resDict = responseData as! [String: [[String: String]]]
            for commentDict in resDict["comments"]! {
                let commentId: String = commentDict["comment_id"]!
                let actionId: String = commentDict["action_id"]!
                let username: String = commentDict["username"]!
                let message: String = commentDict["message"]!
                let timestamp: String = commentDict["timestamp"]!
                commentModelHelper.addComment(commentId, actionId: actionId, message: message, username: username, timestamp: timestamp, read: false)
            }
            self.delegate?.didGetCommentList()
        }
    }
    
    func apiReceiveError(error: ErrorType) {
        
    }
}
