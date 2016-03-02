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
    
}

class WatcherModelHelper {
    init() {
        PerformMigrations().setDefaultRealmForUser()
    }
    
    func addUpdateWatchers(actionId: String, watchers: [String]) {
        do {
            var duplicatedWatchers: [String] = []
            let realm = try Realm()
            for item in realm.objects(WatcherModel).filter("actionId = '\(actionId)'") {
                let username = item.username
                if watchers.contains(username) {
                    duplicatedWatchers.append(username)
                } else {
                    try realm.write({ () -> Void in
                        realm.delete(item)
                    })
                }
            }
            let newWatchers: [String] = Array(Set(watchers).subtract(Set(duplicatedWatchers)))
            for username in newWatchers {
                let newWatcher = WatcherModel()
                newWatcher.username = username
                newWatcher.actionId = actionId
                try realm.write({ () -> Void in
                    realm.add(newWatcher)
                })
            }
        } catch {
            print(error)
        }
    }
    
    func getWatchers(actionId: String) -> [String] {
        var watchers: [String] = []
        do {
            let realm = try Realm()
            for item in realm.objects(WatcherModel).filter("actionId = '\(actionId)'") {
                watchers.append(item.username)
            }
        } catch {
            print(error)
        }
        return watchers
    }
}