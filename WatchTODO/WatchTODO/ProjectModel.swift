//
//  ProjectModel.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/17/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import RealmSwift

class ProjectModel: Object {
    
    dynamic var uuid = ""
    dynamic var name = ""
    
    override static func primaryKey() -> String {
        return "uuid"
    }
}

class WatcherProjectModel: Object {
    dynamic var projectId: String = ""
    dynamic var username: String = ""
}

class ProjectModelHelper {
    
    init() {
        PerformMigrations().setDefaultRealmForUser()
    }
    
    func addProject(projectId: String, projectName: String) {
        let project = ProjectModel()
        project.uuid = projectId
        project.name = projectName
        do {
            let realm = try Realm()
            try realm.write({ () -> Void in
                realm.add(project, update: true)
            })
        } catch {
            print(error)
        }
    }
    
    func getAllProjects() -> [[String:String]] {
        var projects: [[String:String]] = []
        do {
            let realm = try Realm()
            for project in realm.objects(ProjectModel) {
                let projectDict = [
                    "uuid": project.uuid,
                    "name": project.name
                ]
                projects.append(projectDict)
            }
        } catch {
            print("getAllProjects\(error)")
        }
        return projects
    }
    
    func removeProject(uuid:String) {
        do {
            let realm = try Realm()
            let project = realm.objectForPrimaryKey(ProjectModel.self, key: uuid)
            try realm.write({ () -> Void in
                realm.delete(project!)
            })
        } catch {
            print(error)
        }
    }
    
    func addUpdateWatchersIntoProject(projectId: String, watchers: [String]) {
        do {
            var duplicatedWatchers: [String] = []
            let realm = try Realm()
            for item in realm.objects(WatcherProjectModel).filter("projectId = '\(projectId)'") {
                let username = item.username
                if watchers.contains(username) {
                    duplicatedWatchers.append(username)
                } else {
                    try realm.write({ () -> Void in
                        realm.delete(item)
                    })
                }
            }
            let newWatchers: [String] = Array(Set(watchers).subtract(Set(duplicatedWatchers)))
            for username in newWatchers {
                let newWatcher = WatcherProjectModel()
                newWatcher.username = username
                newWatcher.projectId = projectId
                try realm.write({ () -> Void in
                    realm.add(newWatcher)
                })
            }
        } catch {
            print(error)
        }
    }
    
    func getWatchersByProjectId(projectId: String) -> [String] {
        var watchers: [String] = []
        do {
            let realm = try Realm()
            for item in realm.objects(WatcherProjectModel).filter("projectId = '\(projectId)'") {
                let username = item.username
                watchers.append(username)
            }
        } catch {
            print(error)
        }
        return watchers
    }
}
