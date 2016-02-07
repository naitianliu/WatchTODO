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
    
    let index_AddWatchers = "AddWatchers"
    
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
        
    }
    
    func beforeSendRequest(index: String?) {
        
    }
    
    func afterReceiveResponse(responseData: AnyObject, index: String?) {
        print(responseData)
    }
    
    func apiReceiveError(error: ErrorType) {
        print(error)
    }
}