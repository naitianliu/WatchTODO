//
//  WatcherModel.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/17/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import RealmSwift

class WatcherModel: Object {
    
    dynamic var userId: String = ""
    dynamic var username: String = ""
    dynamic var imgUrl: String = ""
    
    override static func primaryKey() -> String {
        return "userId"
    }
}
