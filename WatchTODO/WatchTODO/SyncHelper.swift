//
//  SyncHelper.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 2/5/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation

class SyncHelper {
    init() {
        
    }
    
    func syncAfterLogin() {
        FriendAPIHelper().getFriendList()
        TodoListAPIHelper().getTodoList()
    }
}