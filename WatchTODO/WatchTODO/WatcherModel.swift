//
//  WatcherModel.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/17/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import RealmSwift

class WatcherModel: Object {
    
    dynamic var actionId: String = ""
    dynamic var username: String = ""
    dynamic var nickname: String = ""
    
}

class WatcherModelHelper {
    init() {
        
    }
    
    func addUpdateWatchers(actionId: String, watchers: [[String: String]]) {
        do {
            var mapDict = [String: String]()
            var watcherUsernames: [String] = []
            for watcherDict in watchers {
                let username = watcherDict["username"]!
                let nickname = watcherDict["nickname"]!
                watcherUsernames.append(username)
                mapDict[username] = nickname
            }
            var duplicatedWatcherUsernames: [String] = []
            let realm = try Realm()
            for item in realm.objects(WatcherModel).filter("actionId = '\(actionId)'") {
                let username = item.username
                if watcherUsernames.contains(username) {
                    duplicatedWatcherUsernames.append(username)
                } else {
                    try realm.write({ () -> Void in
                        realm.delete(item)
                    })
                }
            }
            let newWatcherUsernames: [String] = Array(Set(watcherUsernames).subtract(Set(duplicatedWatcherUsernames)))
            for username in newWatcherUsernames {
                let newWatcher = WatcherModel()
                newWatcher.actionId = actionId
                newWatcher.username = username
                newWatcher.nickname = mapDict[username]!
                try realm.write({ () -> Void in
                    realm.add(newWatcher)
                })
            }
        } catch {
            print(error)
        }
    }
    
    func getWatchers(actionId: String) -> [[String: String]] {
        var watchers: [[String: String]] = []
        do {
            let realm = try Realm()
            for item in realm.objects(WatcherModel).filter("actionId = '\(actionId)'") {
                let itemDict = [
                    "username": item.username,
                    "nickname": item.nickname
                ]
                watchers.append(itemDict)
            }
        } catch {
            print(error)
        }
        return watchers
    }
}