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
    dynamic var projectId: String = ""
    dynamic var projectName: String = ""
    dynamic var deferDate: String = ""
    dynamic var priority: Int = 4
    // status 0: not started, 1: WorkInProgress, 2: complete
    dynamic var status: Int = 0
    dynamic var everyday: Bool = false
    
    override static func primaryKey() -> String {
        return "uuid"
    }
}

class ActionItemModelHelper {
    init() {
        
    }
    
    func addActionItem(content:String, projectId:String?, projectName:String?, dueDate:String?, deferDate:String?, priority:Int?) -> String {
        let uuid = NSUUID().UUIDString
        let actionItem = ActionItemModel()
        actionItem.uuid = uuid
        actionItem.content = content
        if let projectId = projectId {
            actionItem.projectId = projectId
        }
        if let projectName = projectName {
            actionItem.projectName = projectName
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
        if let priority = priority {
            actionItem.priority = priority
        } else {
            actionItem.priority = 4
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
    
    func updateActionStatus(uuid:String, status:Int) {
        do {
            let realm = try Realm()
            let actionItem = realm.objectForPrimaryKey(ActionItemModel.self, key: uuid)
            try realm.write({ () -> Void in
                actionItem?.setValue(status, forKeyPath: "status")
            })
        } catch {
            print(error)
        }
    }
    
    func getAllPendingItems() -> [[String:AnyObject]] {
        var pendingItems: [[String:AnyObject]] = []
        do {
            let realm = try Realm()
            for item in realm.objects(ActionItemModel).filter("status != 2") {
                let itemDict = [
                    "uuid": item.uuid,
                    "content": item.content,
                    "projectId": item.projectId,
                    "projectName": item.projectName,
                    "dueDate": item.dueDate,
                    "deferDate": item.deferDate,
                    "priority": item.priority,
                    "status": item.status,
                    "everyday": item.everyday
                ]
                pendingItems.append(itemDict as! [String : AnyObject])
            }
        } catch {
            print(error)
        }
        return pendingItems
    }
}