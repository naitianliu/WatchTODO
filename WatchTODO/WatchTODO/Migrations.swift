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
    init() {
        
    }
    
    func migrate() {
        let config = Realm.Configuration(
            schemaVersion: 7,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                    migration.enumerate(ActionItemModel.className(), { (oldObject, newObject) -> Void in
                        newObject!["priority"] = 4
                    })
                } else if (oldSchemaVersion < 2) {
                    migration.enumerate(ActionItemModel.className(), { (oldObject, newObject) -> Void in
                        newObject!["status"] = 0
                    })
                } else if (oldSchemaVersion < 3) {
                    migration.enumerate(ActionItemModel.className(), { (oldObject, newObject) -> Void in
                        
                    })
                } else if (oldSchemaVersion < 4) {
                    migration.enumerate(ProjectModel.className(), { (oldObject, newObject) -> Void in
                        newObject!["projectName"] = oldObject!["project"]
                    })
                } else if (oldSchemaVersion < 5) {
                    migration.enumerate(ProjectModel.className(), { (oldObject, newObject) -> Void in
                        
                    })
                } else if (oldSchemaVersion < 6) {
                    migration.enumerate(WatcherModel.className(), { (oldObject, newObject) -> Void in
                        newObject!["username"] = oldObject!["userId"]
                        newObject!["actionId"] = ""
                    })
                } else if (oldSchemaVersion < 7) {
                    migration.enumerate(WatcherModel.className(), { (oldObject, newObject) -> Void in
                        newObject!["username"] = ""
                        newObject!["actionId"] = ""
                    })
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
    }
}