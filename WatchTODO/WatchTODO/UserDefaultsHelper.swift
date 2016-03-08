//
//  UserDefaultsHelper.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/23/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let username = DefaultsKey<String?>("username")
    static let profileImageURL = DefaultsKey<String?>("profileImageURL")
    static let nickname = DefaultsKey<String?>("nickname")
    static let token = DefaultsKey<String?>("token")
    static let deviceToken = DefaultsKey<String?>("deviceToken")
    static let timestamp = DefaultsKey<String?>("timestamp")
}

class UserDefaultsHelper {
    init() {
        
    }
    
    func getLastUpdatedTimestamp() -> String {
        if let timestamp = Defaults[.timestamp] {
            return timestamp
        } else {
            return "0"
        }
    }
    
    func updateLastUpdatedTimestamp(timestamp: String) {
        Defaults[.timestamp] = timestamp
    }
    
    func createOrUpdateUserInfo(username:String?, profileImageURL:String?, nickname:String?, token:String?) {
        if let username = username {
            Defaults[.username] = username
        }
        if let profileImageURL = profileImageURL {
            Defaults[.profileImageURL] = profileImageURL
        }
        if let nickname = nickname {
            Defaults[.nickname] = nickname
        }
        if let token = token {
            Defaults[.token] = token
        }
    }
    
    func updateDeviceToken(deviceToken: String?) {
        if let deviceTokenStr = deviceToken {
            Defaults[.deviceToken] = deviceTokenStr
        }
    }
    
    func getDeviceToken() -> String? {
        return Defaults[.deviceToken]
    }
    
    func getUserInfo() -> [String: String?] {
        var userInfo = Dictionary<String, String?>()
        userInfo["username"] = Defaults[.username]
        userInfo["profileImageURL"] = Defaults[.profileImageURL]
        userInfo["nickname"] = Defaults[.nickname]
        userInfo["token"] = Defaults[.token]
        return userInfo
    }
    
    func getUsername() -> String? {
        let username = Defaults[.username]
        return username
    }
    
    func getToken() -> String {
        let token: String = Defaults[.token]!
        return token
    }
    
    func removeUserInfo() {
        Defaults[.username] = nil
        Defaults[.profileImageURL] = nil
        Defaults[.nickname] = nil
        Defaults[.token] = nil
    }
    
    func checkIfLogin() -> Bool {
        var result = false
        let token: String? = Defaults[.token]
        let username: String? = Defaults[.username]
        if token != nil && username != nil {
            result = true
        }
        return result
    }
}