//
//  Migrations.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/28/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import RealmSwift

class PerformMigrations {
    
    var path: String?
    
    init() {
        self.setDefaultRealmForUser()
    }
    
    func migrate() {
        let config = Realm.Configuration(
            path: self.path,
            schemaVersion: const_RealmSchemaVersion,
            migrationBlock: { migration, oldSchemaVersion in
                print(oldSchemaVersion)
                if (oldSchemaVersion < 1) {
                    migration.enumerate(ActionItemModel.className(), { (oldObject, newObject) -> Void in
                        newObject!["me"] = true
                    })
                }
                if (oldSchemaVersion < 5) {
                    migration.enumerate(CommentModel.className(), { (oldObject, newObject) -> Void in
                        newObject!["uuid"] = NSUUID().UUIDString
                    })
                }
                if (oldSchemaVersion < 7) {
                    migration.enumerate(FriendModel.className(), { (oldObject, newObject) -> Void in
                        newObject!["timestamp"] = DateTimeHelper().convertDateToEpoch(NSDate())!
                    })
                }
                if (oldSchemaVersion < 9) {
                    migration.enumerate(ActionItemModel.className(), { (oldObject, newObject) -> Void in
                        newObject!["deferDate"] = oldObject!["deferDate"] as! Int
                        newObject!["dueDate"] = oldObject!["dueDate"] as! Int
                    })
                    migration.enumerate(FriendModel.className(), { (oldObject, newObject) -> Void in
                        newObject!["timestamp"] = oldObject!["timestamp"] as! Int
                    })
                    migration.enumerate(CommentModel.className(), { (oldObject, newObject) -> Void in
                        newObject!["timestamp"] = oldObject!["timestamp"] as! Int
                    })
                    migration.enumerate(UpdateModel.className(), { (oldObject, newObject) -> Void in
                        newObject!["timestamp"] = oldObject!["timestamp"] as! Int
                    })
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
    }
    
    func setDefaultRealmForUser() {
        if let username = UserDefaultsHelper().getUsername() {
            var config = Realm.Configuration()
            // Use the default directory, but replace the filename with the username
            config.path = NSURL.fileURLWithPath(config.path!)
                .URLByDeletingLastPathComponent?
                .URLByAppendingPathComponent("\(username).realm")
                .path
            
            // Set this as the configuration used for the default Realm
            config.schemaVersion = const_RealmSchemaVersion
            self.path = config.path
            Realm.Configuration.defaultConfiguration = config
        }
    }
}