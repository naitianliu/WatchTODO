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
    dynamic var actionUUID: String = ""
    dynamic var content: String = ""
    dynamic var time: String = ""
    dynamic var author: String = ""
    dynamic var replyTo: String = ""
    
    override static func primaryKey() -> String {
        return "uuid"
    }
    
}
