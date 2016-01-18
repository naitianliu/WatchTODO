//
//  ActionItem.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/17/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import RealmSwift

class ActionItemModel: Object {
    
    dynamic var uuid: String = ""
    dynamic var content: String = ""
    dynamic var dueDate: String = ""
    dynamic var project: String = ""
    dynamic var deferDate: String = ""
    dynamic var completed: Bool = false
    dynamic var everyday: Bool = false
    let watchers = List<WatcherModel>()
    
    override static func primaryKey() -> String {
        return "uuid"
    }
}

class ActionItemModelHelper {
    init() {
        
    }
    
    func addActionItem(content:String, project:String?, dueDate:String?, deferDate:String?) -> String {
        let uuid = NSUUID().UUIDString
        let actionItem = ActionItemModel()
        actionItem.uuid = uuid
        actionItem.content = content
        if let project = project {
            actionItem.project = project
        }
        if let dueDate = dueDate {
            if dueDate == "everyday" {
                actionItem.everyday = true
            }
            actionItem.dueDate = dueDate
        }
        if let deferDate = deferDate {
            actionItem.deferDate = deferDate
        }
        do {
            let realm = try Realm()
            try realm.write({ () -> Void in
                realm.add(actionItem)
            })
        } catch {
            print(error)
        }
        return uuid
    }
    
    func completeActionItem(uuid:String) {
        do {
            let realm = try Realm()
            let actionItem = realm.objectForPrimaryKey(ActionItemModel.self, key: uuid)
            try realm.write({ () -> Void in
                actionItem?.setValue(true, forKeyPath: "completed")
            })
        } catch {
            print(error)
        }
    }
}