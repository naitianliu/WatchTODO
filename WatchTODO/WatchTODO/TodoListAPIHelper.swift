//
//  TodoListAPIHelper.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/28/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation

class TodoListAPIHelper: CallAPIHelperDelegate {
    
    let apiURL_GetTodoList = "\(const_APIEndpoint)todo/get_todo_list/"
    let apiURL_AddAction = "\(const_APIEndpoint)todo/add_action/"
    let apiURL_UpdateAction = "\(const_APIEndpoint)todo/update_action/"
    let apiURL_RemoveAction = "\(const_APIEndpoint)todo/remove_action/"
    let apiURL_UpdateStatus = "\(const_APIEndpoint)todo/update_status/"
    let apiURL_Complete = "\(const_APIEndpoint)todo/complete/"
    
    let index_GetTodoList = "GetTodoList"
    let index_AddAction = "AddAction"
    let index_UpdateAction = "UpdateAction"
    let index_RemoveAction = "RemoveAction"
    let index_UpdateStatus = "UpdateStatus"
    let index_Complete = "Complete"
    
    let actionItemModelHelper = ActionItemModelHelper()
    
    init() {
        
    }
    
    func syncTodoList() {
        
    }
    
    func addAction(content: String, projectId: String?, projectName:String?, dueDate:String?, deferDate: String?, priority: Int?) {
        let actionId = actionItemModelHelper.addActionItem(content, projectId: projectId, projectName: projectName, dueDate: dueDate, deferDate: deferDate, priority: priority)
        var actionInfo: [String: String] = ["content": content]
        if let projectId = projectId {
            actionInfo["project_id"] = projectId
        }
        if let projectName = projectName {
            actionInfo["project_name"] = projectName
        }
        if let dueDate = dueDate {
            actionInfo["due_date"] = dueDate
        }
        if let deferDate = deferDate {
            actionInfo["defer_date"] = deferDate
        }
        if let priority = priority {
            actionInfo["priority"] = String(priority)
        }
        let data: [String: AnyObject] = [
            "action_id": actionId,
            "action_info": actionInfo
        ]
        CallAPIHelper(url: apiURL_AddAction, data: data, delegate: self).POST(index_AddAction)
    }
    
    func updateAction() {
        
    }
    
    func removeAction() {
        
    }
    
    func updateStatus(actionId: String, status: Int) {
        actionItemModelHelper.updateActionStatus(actionId, status: status)
        let data: [String: AnyObject] = [
            "action_id": actionId,
            "status": String(status)
        ]
        CallAPIHelper(url: apiURL_UpdateStatus, data: data, delegate: self).POST(index_UpdateStatus)
    }
    
    func complete() {
        
    }
    
    func beforeSendRequest(index: String?) {
        
    }
    
    func afterReceiveResponse(responseData: AnyObject, index: String?) {
        if index == index_AddAction {
            
        }
    }
    
    func apiReceiveError(error: ErrorType) {
        
    }
}