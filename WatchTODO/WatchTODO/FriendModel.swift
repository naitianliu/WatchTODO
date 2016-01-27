//
//  FriendModel.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/24/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import RealmSwift

class FriendModel: Object {
    
    dynamic var username: String = ""
    dynamic var nickname: String = ""
    dynamic var profileImageURL: String = ""
    
    override static func primaryKey() -> String {
        return "username"
    }
}

class FriendModelHelper {
    init() {
        
    }
    
    func getAllFriendList() -> [[String: String]] {
        var friendList: [[String: String]] = []
        do {
            let realm = try Realm()
            for item in realm.objects(FriendModel) {
                let itemDict = [
                    "username": item.username,
                    "nickname": item.nickname,
                    "profile_img_url": item.profileImageURL
                ]
                friendList.append(itemDict)
            }
        } catch {
            print(error)
        }
        return friendList
    }
    
    func addFriend(userInfo: [String: String]) {
        let username: String = userInfo["username"]!
        let nickname: String = userInfo["nickname"]!
        let profileImageURL: String = userInfo["profile_img_url"]!
        let friend = FriendModel()
        friend.username = username
        friend.nickname = nickname
        friend.profileImageURL = profileImageURL
        do {
            let realm = try Realm()
            try realm.write({ () -> Void in
                realm.add(friend)
            })
        } catch {
            print(error)
        }
    }
    
    func syncFriends(userList: [[String: String]]) {
        
    }
}
