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
    
    dynamic var actionId: String = ""
    dynamic var username: String = ""
    dynamic var message: String = ""
    dynamic var time: NSDate = NSDate()
    
}


class CommentModelHelper {
    
    let timeNow = NSDate()
    var username: String = ""
    var nickname: String = ""
    
    init() {
        let userInfo: [String: String?] = UserDefaultsHelper().getUserInfo()
        username = userInfo["username"]!!
        nickname = userInfo["nickname"]!!
        PerformMigrations().setDefaultRealmForUser()
    }
    
    func addComment(actionId: String, message: String) {
        let comment = CommentModel()
        comment.actionId = actionId
        comment.username = username
        comment.message = message
        comment.time = timeNow
        do {
            let realm = try Realm()
            try realm.write({ () -> Void in
                realm.add(comment)
            })
        } catch {
            print(error)
        }
    }
    
    func getCommentListByActionId(actionId: String) -> [[String: String]] {
        var commentList: [[String: String]] = []
        var keyList: [Int] = []
        var tempDict = [String: [String: String]]()
        do {
            let realm = try Realm()
            for item in realm.objects(CommentModel).filter("actionId = '\(actionId)'") {
                let time: NSDate = item.time
                let timeInt = Int(time.timeIntervalSince1970)
                let timeString = String(timeInt)
                keyList.append(timeInt)
                let commentDict = [
                    "actionId": item.actionId,
                    "username": item.username,
                    "nickname": item.username,
                    "message": item.message,
                    "time": timeString
                ]
                tempDict[timeString] = commentDict
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