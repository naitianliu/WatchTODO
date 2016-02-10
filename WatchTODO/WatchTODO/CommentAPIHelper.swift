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
    
    let commentModelHelper = CommentModelHelper()
    
    init() {
        
    }
    
    func addComment(actionId: String, message: String) {
        print(message)
        commentModelHelper.addComment(actionId, message: message, username: nil, time: nil)
        let data: [String: AnyObject] = [
            "action_id": actionId,
            "message": message
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
