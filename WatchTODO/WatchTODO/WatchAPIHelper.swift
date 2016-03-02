//
//  WatcherAPIHelper.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 2/6/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation

@objc protocol WatchAPIHelperDelegate {
    optional func didUpdateWatchItemList()
    optional func didGetUpdateList()
}

class WatchAPIHelper: CallAPIHelperDelegate {
    
    let apiURL_AddWatchers = "\(const_APIEndpoint)watch/add_watchers/"
    let apiURL_GetUpdatedWatchList = "\(const_APIEndpoint)watch/get_updated_watch_list/"
    let apiURL_GetUpdateList = "\(const_APIEndpoint)watch/get_update_list/"
    let apiURL_UpdateDeviceToken = "\(const_APIEndpoint)watch/update_device_token/"
    
    let index_AddWatchers = "AddWatchers"
    let index_GetUpdatedWatchList = "GetUpdatedWatchList"
    let index_GetUpdateList = "GetUpdateList"
    let index_UpdateDeviceToken = "UpdateDeviceToken"
    
    let watcherModelHelper = WatcherModelHelper()
    let actionItemModelHelper = ActionItemModelHelper(me: false)
    
    var delegate: WatchAPIHelperDelegate?
    
    init() {
        
    }
    
    func addWatchers(actionId: String, watchers: [String]) {
        self.watcherModelHelper.addUpdateWatchers(actionId, watchers: watchers)
        let data: [String: AnyObject] = ["action_id": actionId, "watchers": watchers]
        CallAPIHelper(url: apiURL_AddWatchers, data: data, delegate: self).POST(index_AddWatchers)
    }
    
    func getUpdatedWatchList() {
        let data: [String: AnyObject] = ["timestamp": "0"]
        CallAPIHelper(url: apiURL_GetUpdatedWatchList, data: data, delegate: self).GET(index_GetUpdatedWatchList)
    }
    
    func getUpdateList() {
        let data: [String: AnyObject] = ["timestamp": "0"]
        CallAPIHelper(url: apiURL_GetUpdateList, data: data, delegate: self).GET(index_GetUpdateList)
    }
    
    func updateDeviceToken() {
        let deviceToken = UserDefaultsHelper().getDeviceToken()
        if let deviceToken = deviceToken {
            let data: [String: AnyObject] = ["device_token": deviceToken]
            CallAPIHelper(url: apiURL_UpdateDeviceToken, data: data, delegate: self).POST(index_UpdateDeviceToken)
        }
    }
    
    func beforeSendRequest(index: String?) {
        
    }
    
    func afterReceiveResponse(responseData: AnyObject, index: String?) {
        print(responseData)
        if index == index_GetUpdatedWatchList {
            // add action item
            let resDict = responseData as! [String: AnyObject]
            let watchInfo = resDict["watch_updated_info"] as! [String: AnyObject]
            let actionList = watchInfo["updated_actions_watch"] as! [[String: AnyObject]]
            for action in actionList {
                let actionId = action["action_id"] as! String
                let actionInfo = action["info"] as! [String: String]
                var content: String?
                var dueDate: String?
                var deferDate: String?
                var priority: Int?
                if let tempContent = actionInfo["content"] {
                    content = tempContent
                }
                if let tempDueDate = actionInfo["due_date"] {
                    dueDate = tempDueDate
                }
                if let tempDeferDate = actionInfo["defer_date"] {
                    deferDate = tempDeferDate
                }
                if let tempPriority = actionInfo["priority"] {
                    priority = Int(tempPriority)
                }
                let pending = action["pending"] as! Bool
                let projectId = action["project_id"] as? String
                let status = action["status"] as! Int
                let username = action["username"] as? String
                let projectName = action["project_name"] as? String
                self.actionItemModelHelper.addActionItem(actionId, username: username, content: content!, projectId: projectId, projectName: projectName, dueDate: dueDate, deferDate: deferDate, priority: priority)
            }
            // add update model
            let updateModelHelper = UpdateModelHelper()
            let updateList = resDict["update_list"] as! [[String: AnyObject]]
            for updateItem in updateList {
                let uuid: String = updateItem["uuid"] as! String
                let actionId: String = updateItem["action_id"] as! String
                let code: String = updateItem["code"] as! String
                let message: String = updateItem["message"] as! String
                let updatedBy: String = updateItem["updated_by"] as! String
                let timestamp: String = updateItem["timestamp"] as! String
                updateModelHelper.addUpdateItem(uuid, actionId: actionId, code: code, message: message, updatedBy: updatedBy, timestamp: timestamp)
            }
            delegate?.didUpdateWatchItemList!()
        } else if index == index_GetUpdateList {
            let resDict = responseData as! [String: AnyObject]
            let updateModelHelper = UpdateModelHelper()
            let updateList = resDict["update_list"] as! [[String: AnyObject]]
            for updateItem in updateList {
                let uuid: String = updateItem["uuid"] as! String
                let actionId: String = updateItem["action_id"] as! String
                let code: String = updateItem["code"] as! String
                let message: String = updateItem["message"] as! String
                let updatedBy: String = updateItem["updated_by"] as! String
                let timestamp: String = updateItem["timestamp"] as! String
                updateModelHelper.addUpdateItem(uuid, actionId: actionId, code: code, message: message, updatedBy: updatedBy, timestamp: timestamp)
            }
            delegate?.didGetUpdateList!()
        }
    }
    
    func apiReceiveError(error: ErrorType) {
        print(error)
    }
}