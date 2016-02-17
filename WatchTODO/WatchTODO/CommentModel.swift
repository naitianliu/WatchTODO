//
//  CommentModel.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/28/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import RealmSwift

class CommentModel: Object {
    
    dynamic var uuid: String = ""
    dynamic var actionId: String = ""
    dynamic var username: String = ""
    dynamic var message: String = ""
    dynamic var timestamp: String = ""

    override static func primaryKey() -> String {
        return "uuid"
    }
}


class CommentModelHelper {
    
    let timeNow = DateTimeHelper().convertDateToEpoch(NSDate())!
    var myUsername: String = ""
    var myNickname: String = ""
    
    init() {
        let userInfo: [String: String?] = UserDefaultsHelper().getUserInfo()
        myUsername = userInfo["username"]!!
        myNickname = userInfo["nickname"]!!
        PerformMigrations().setDefaultRealmForUser()
    }
    
    func addComment(uuid: String?, actionId: String, message: String, username: String?, timestamp: String?) -> String {
        let comment = CommentModel()
        var commentUUID = NSUUID().UUIDString
        if let tempUUID = uuid {
            commentUUID = tempUUID
        }
        comment.uuid = commentUUID
        comment.actionId = actionId
        if let tempUsername = username {
            comment.username = tempUsername
        } else {
            comment.username = myUsername
        }
        comment.message = message
        if let tempTime = timestamp {
            comment.timestamp = tempTime
        } else {
            comment.timestamp = timeNow
        }
        do {
            let realm = try Realm()
            try realm.write({ () -> Void in
                realm.add(comment, update: true)
            })
        } catch {
            print(error)
        }
        return commentUUID
    }
    
    func getCommentListByActionId(actionId: String) -> [[String: String]] {
        var commentList: [[String: String]] = []
        var keyList: [Int] = []
        var tempDict = [String: [String: String]]()
        do {
            let realm = try Realm()
            for item in realm.objects(CommentModel).filter("actionId = '\(actionId)'") {
                let timestamp = item.timestamp
                keyList.append(Int(timestamp)!)
                let commentDict = [
                    "actionId": item.actionId,
                    "username": item.username,
                    "nickname": item.username,
                    "message": item.message,
                    "timestamp": item.timestamp
                ]
                tempDict[timestamp] = commentDict
            }
            keyList = keyList.sort()
            for keyInt in keyList {
                commentList.append(tempDict[String(keyInt)]!)
            }
        } catch {
            print(error)
        }
        return commentList
    }
}