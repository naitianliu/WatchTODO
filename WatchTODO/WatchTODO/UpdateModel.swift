//
//  UpdateModel.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 2/27/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import RealmSwift

class UpdateModel: Object {
    
    dynamic var uuid: String = ""
    dynamic var actionId: String = ""
    dynamic var code: String = ""
    dynamic var message: String = ""
    dynamic var updatedBy: String = ""
    dynamic var timestamp: Int = 0
    
    override static func primaryKey() -> String {
        return "uuid"
    }
}

class UpdateModelHelper {
    init() {
        
    }
    
    func addUpdateItem(uuid: String, actionId: String, code: String, message: String, updatedBy: String, timestamp: Int) {
        let updateItem = UpdateModel()
        updateItem.uuid = uuid
        updateItem.actionId = actionId
        updateItem.code = code
        updateItem.message = message
        updateItem.updatedBy = updatedBy
        updateItem.timestamp = timestamp
        do {
            let realm = try Realm()
            try realm.write({ () -> Void in
                realm.add(updateItem, update: true)
            })
        } catch {
            print(error)
        }
    }
    
    func getUpdateList() -> [[String: AnyObject]] {
        let actionItemModelHelper = ActionItemModelHelper(me: false)
        var updateList: [[String: AnyObject]] = []
        do {
            let realm = try Realm()
            for item in realm.objects(UpdateModel) {
                let actionId = item.actionId
                var itemDict: [String: AnyObject] = [
                    "uuid": item.uuid,
                    "actionId": actionId,
                    "code": item.code,
                    "message": item.message,
                    "updatedBy": item.updatedBy,
                    "timestamp": item.timestamp
                ]
                if let actionInfo = actionItemModelHelper.getActionInfoByActionId(actionId) {
                    itemDict["actionInfo"] = actionInfo
                }
                updateList.insert(itemDict, atIndex: 0)
            }
        } catch {
            
        }
        return updateList
    }
}