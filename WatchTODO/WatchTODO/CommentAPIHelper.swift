//
//  CommentAPIHelper.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/30/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation

class CommentAPIHelper: CallAPIHelperDelegate {
    
    let apiURL_AddComment = "\(const_APIEndpoint)comment/add_comment/"
    
    let index_AddComment = "AddComment"
    
    
    
    init() {
        
    }
    
    func addComment(uuid: String?, actionId: String, message: String) {
        print(message)
        let commentModelHelper = CommentModelHelper()
        let commentId = commentModelHelper.addComment(uuid, actionId: actionId, message: message, username: nil, timestamp: nil)
        let data: [String: AnyObject] = [
            "comment_id": commentId,
            "action_id": actionId,
            "message": message,
            "timestamp": commentModelHelper.timeNow
        ]
        CallAPIHelper(url: apiURL_AddComment, data: data, delegate: self).POST(index_AddComment)
    }
    
    func getCommentList() {
        
    }
    
    func beforeSendRequest(index: String?) {
        
    }
    
    func afterReceiveResponse(responseData: AnyObject, index: String?) {
        print(responseData)
        if index == index_AddComment {
            
        }
    }
    
    func apiReceiveError(error: ErrorType) {
        
    }
}
