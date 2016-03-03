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
    dynamic var timestamp: Int = 0
    dynamic var read: Bool = false

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
    
    func addComment(uuid: String?, actionId: String, message: String, username: String?, timestamp: Int?, read: Bool) -> String {
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
        comment.read = read
        do {
            let realm = try Realm()
            if realm.objectForPrimaryKey(CommentModel.self, key: commentUUID) == nil {
                try realm.write({ () -> Void in
                    realm.add(comment, update: true)
                })
            }
        } catch {
            print(error)
        }
        return commentUUID
    }
    
    func setReadByActionId(actionId: String) {
        do {
            let realm = try Realm()
            for comment in realm.objects(CommentModel).filter("actionId = '\(actionId)'") {
                if !comment.read {
                    try realm.write({ () -> Void in
                        comment.setValue(true, forKeyPath: "read")
                    })
                }
            }
        } catch {
            print(error)
        }
    }
    
    func getCommentListByActionId(actionId: String) -> [[String: AnyObject]] {
        var commentList: [[String: AnyObject]] = []
        var keyList: [Int] = []
        var tempDict = [String: [String: AnyObject]]()
        do {
            let realm = try Realm()
            for item in realm.objects(CommentModel).filter("actionId = '\(actionId)'") {
                let timestamp = item.timestamp
                keyList.append(timestamp)
                let commentDict: [String: AnyObject] = [
                    "commentId": item.uuid,
                    "actionId": item.actionId,
                    "username": item.username,
                    "nickname": item.username,
                    "message": item.message,
                    "timestamp": item.timestamp
                ]
                tempDict[String(timestamp)] = commentDict
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
    
    func getLatestCommentsByActions(actionIdList: [String]) -> [[String: AnyObject]] {
        var latestComments: [[String: AnyObject]] = []
        do {
            let realm = try Realm()
            for actionId in actionIdList {
                var unreadCount = 0
                var tempTime: Int = 0
                var latestComment: [String: AnyObject]?
                for comment in realm.objects(CommentModel).filter("actionId = '\(actionId)'") {
                    if !comment.read {
                        unreadCount += 1
                    }
                    let timestamp: Int = comment.timestamp
                    if timestamp > tempTime {
                        tempTime = timestamp
                        latestComment = [
                            "commentId": comment.uuid,
                            "actionId": comment.actionId,
                            "username": comment.username,
                            "nickname": comment.username,
                            "message": comment.message,
                            "timestamp": comment.timestamp,
                            "unreadCount": String(unreadCount)
                        ]
                    }
                    
                }
                if let comment = latestComment {
                    let itemDict: [String: AnyObject] = [
                        "type": "comment",
                        "latestComment": comment,
                        "timestamp": tempTime,
                        "actionId": actionId
                    ]
                    latestComments.append(itemDict)
                }
            }
            
        } catch {
            print(error)
        }
        return latestComments
    }
}