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
    dynamic var pending: Bool = true
    dynamic var role: String = ""
    dynamic var timestamp: String = ""
    
    override static func primaryKey() -> String {
        return "username"
    }
}

class FriendModelHelper {
    
    let timestampNow: String = DateTimeHelper().convertDateToEpoch(NSDate())!
    
    init() {
        PerformMigrations().setDefaultRealmForUser()
    }
    
    func addFriend(userInfo: [String: String]) {
        let username = userInfo["username"]!
        let nickname = userInfo["nickname"]!
        let friend = FriendModel()
        friend.username = username
        friend.nickname = nickname
        friend.pending = false
        friend.timestamp = self.timestampNow
        do {
            let realm = try Realm()
            try realm.write({ () -> Void in
                realm.add(friend, update: true)
            })
        } catch {
            print(error)
        }
    }
    
    func getAllFriendList() -> [[String: String]] {
        var friendList: [[String: String]] = []
        do {
            let realm = try Realm()
            for item in realm.objects(FriendModel).filter("pending = false") {
                let itemDict = [
                    "username": item.username,
                    "nickname": item.nickname,
                ]
                friendList.append(itemDict)
            }
        } catch {
            print(error)
        }
        return friendList
    }
    
    func getPendingFriendList() -> [[String: String]] {
        var friendList: [[String: String]] = []
        do {
            let realm = try Realm()
            for item in realm.objects(FriendModel).filter("pending = true") {
                let itemDict = [
                    "username": item.username,
                    "nickname": item.nickname,
                    "role": item.role,
                    "timestamp": item.timestamp
                ]
                friendList.append(itemDict)
            }
        } catch {
            print(error)
        }
        return friendList
    }
    
    func addPendingFriend(userInfo: [String: String], role: String) {
        let username: String = userInfo["username"]!
        let nickname: String = userInfo["nickname"]!
        let friend = FriendModel()
        friend.username = username
        friend.nickname = nickname
        friend.pending = true
        friend.role = role
        friend.timestamp = self.timestampNow
        do {
            let realm = try Realm()
            try realm.write({ () -> Void in
                realm.add(friend, update: true)
            })
        } catch {
            print(error)
        }
    }
    
    func sendRequest(userInfo: [String: String]) {
        let username: String = userInfo["username"]!
        let nickname: String = userInfo["nickname"]!
        let friend = FriendModel()
        friend.username = username
        friend.nickname = nickname
        friend.role = "accepter"
        friend.pending = true
        friend.timestamp = self.timestampNow
        do {
            let realm = try Realm()
            try realm.write({ () -> Void in
                realm.add(friend)
            })
        } catch {
            print(error)
        }
    }
    
    // need to be modified. use updateStatu() instead
    func acceptRequest(userInfo: [String: String]) {
        let username: String = userInfo["username"]!
        let nickname: String = userInfo["nickname"]!
        let friend = FriendModel()
        friend.username = username
        friend.nickname = nickname
        friend.role = "requester"
        friend.pending = false
        friend.timestamp = self.timestampNow
        do {
            let realm = try Realm()
            try realm.write({ () -> Void in
                realm.add(friend)
            })
        } catch {
            print(error)
        }
    }
    
    func updateStatus(username: String) {
        do {
            let realm = try Realm()
            let friendItem = realm.objectForPrimaryKey(FriendModel.self, key: username)
            try realm.write({ () -> Void in
                friendItem?.setValue(false, forKeyPath: "pending")
                friendItem?.setValue(self.timestampNow, forKeyPath: "timestamp")
            })
        } catch {
            print(error)
        }
    }
    
    func getFriendsMapDict() -> [String: String] {
        let friendList = self.getAllFriendList()
        var mapDict = [String: String]()
        for item in friendList {
            mapDict[item["username"]!] = item["nickname"]
        }
        return mapDict
    }
    
}
