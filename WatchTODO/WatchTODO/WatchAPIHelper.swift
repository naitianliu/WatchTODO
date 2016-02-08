//
//  WatcherAPIHelper.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 2/6/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation

class WatchAPIHelper: CallAPIHelperDelegate {
    
    let apiURL_AddWatchers = "\(const_APIEndpoint)watch/add_watchers/"
    let apiURL_GetUpdatedWatchList = "\(const_APIEndpoint)watch/get_updated_watch_list/"
    let apiURL_UpdateDeviceToken = "\(const_APIEndpoint)watch/update_device_token/"
    
    let index_AddWatchers = "AddWatchers"
    let index_GetUpdatedWatchList = "GetUpdatedWatchList"
    let index_UpdateDeviceToken = "UpdateDeviceToken"
    
    let watcherModelHelper = WatcherModelHelper()
    
    init() {
        
    }
    
    func addWatchers(actionId: String, watchers: [[String: String]]) {
        self.watcherModelHelper.addUpdateWatchers(actionId, watchers: watchers)
        var watcherUsernames: [String] = []
        for item in watchers {
            let username = item["username"]!
            watcherUsernames.append(username)
        }
        let data: [String: AnyObject] = ["action_id": actionId, "watchers": watcherUsernames]
        CallAPIHelper(url: apiURL_AddWatchers, data: data, delegate: self).POST(index_AddWatchers)
    }
    
    func getUpdatedWatchList() {
        let data: [String: AnyObject] = ["timestamp": "0"]
        CallAPIHelper(url: apiURL_GetUpdatedWatchList, data: data, delegate: self).GET(index_GetUpdatedWatchList)
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
            
        }
    }
    
    func apiReceiveError(error: ErrorType) {
        print(error)
    }
}