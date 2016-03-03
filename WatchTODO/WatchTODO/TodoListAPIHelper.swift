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
    
    let actionItemModelHelper = ActionItemModelHelper(me: true)
    
    init() {
        
    }
    
    func getTodoList() {
        let data: [String: AnyObject] = ["timestamp": "0"]
        CallAPIHelper(url: apiURL_GetTodoList, data: data, delegate: self).GET(index_GetTodoList)
    }
    
    func addAction(actionId: String?, content: String, projectId: String?, projectName:String?, dueDate:String?, deferDate: String?, priority: Int?, watchers: [String]) {
        let actionId = actionItemModelHelper.addActionItem(actionId, username: nil, content: content, projectId: projectId, projectName: projectName, dueDate: dueDate, deferDate: deferDate, priority: priority)
        WatcherModelHelper().addUpdateWatchers(actionId, watchers: watchers)
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
            "action_info": actionInfo,
            "watchers": watchers
        ]
        CallAPIHelper(url: apiURL_AddAction, data: data, delegate: self).POST(index_AddAction)
    }
    
    func updateAction() {
        
    }
    
    func removeAction(actionId: String) {
        actionItemModelHelper.updateActionStatus(actionId, status: 3)
        let data: [String: AnyObject] = ["action_id": actionId]
        CallAPIHelper(url: apiURL_RemoveAction, data: data, delegate: self).POST(index_RemoveAction)
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
            
        } else if index == index_GetTodoList {
            let resDict = responseData as! [String: [[String: AnyObject]]]
            for item in resDict["todo_list"]! {
                print(item)
                let actionId = item["action_id"] as! String
                let actionInfo = item["info"] as! [String: String]
                let content = actionInfo["content"]
                var projectId: String?
                if let tempProjectId = actionInfo["project_id"] {
                    projectId = tempProjectId
                }
                var projectName: String?
                if let tempProjectName = actionInfo["project_name"] {
                    projectName = tempProjectName
                }
                var dueDate: String?
                if let tempDueDate = actionInfo["due_date"] {
                    dueDate = tempDueDate
                }
                var deferDate: String?
                if let tempDeferDate = actionInfo["defer_date"] {
                    deferDate = tempDeferDate
                }
                var priority = 4
                if let tempPriority = actionInfo["priority"] {
                    if tempPriority != NSNull() {
                        priority = Int(tempPriority)!
                    }
                }
                self.actionItemModelHelper.addActionItem(actionId, username: nil, content: content!, projectId: projectId, projectName: projectName, dueDate: dueDate, deferDate: deferDate, priority: priority)
            }
        }
    }
    
    func apiReceiveError(error: ErrorType) {
        
    }
}