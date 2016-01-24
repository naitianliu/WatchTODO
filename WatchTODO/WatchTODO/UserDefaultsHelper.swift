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
    static let userId = DefaultsKey<String?>("userId")
    static let username = DefaultsKey<String?>("username")
    static let profileImageURL = DefaultsKey<String?>("profileImageURL")
    static let nickname = DefaultsKey<String?>("nickname")
    static let token = DefaultsKey<String?>("token")
}

class UserDefaultsHelper {
    init() {
        
    }
    
    func createOrUpdateUserInfo(userId:String?, username:String?, profileImageURL:String?, nickname:String?, token:String?) {
        if let userId = userId {
            Defaults[.userId] = userId
        }
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
    
    func getUserInfo() -> [String: String?] {
        var userInfo = Dictionary<String, String?>()
        userInfo["userId"] = Defaults[.userId]
        userInfo["username"] = Defaults[.username]
        userInfo["profileImageURL"] = Defaults[.profileImageURL]
        userInfo["nickname"] = Defaults[.nickname]
        userInfo["token"] = Defaults[.token]
        return userInfo
    }
    
    func checkIfLogin() -> Bool {
        var result = false
        let token: String? = Defaults[.token]
        let userId: String? = Defaults[.userId]
        if token != nil && userId != nil {
            result = true
        }
        return result
    }
}