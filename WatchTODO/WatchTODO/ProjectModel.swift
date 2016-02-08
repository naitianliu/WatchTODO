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

class ProjectModelHelper {
    
    let defaultProjectNames = ["Personal", "Family", "Work", "Shopping", "Books to read", "Movies to watch"]
    
    init() {
        PerformMigrations().setDefaultRealmForUser()
    }
    
    func addProject(projectName:String) -> String {
        let uuid = NSUUID().UUIDString
        let project = ProjectModel()
        project.uuid = uuid
        project.name = projectName
        do {
            let realm = try Realm()
            try realm.write({ () -> Void in
                realm.add(project)
            })
        } catch {
            print(error)
        }
        return uuid
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
    
    func initiateDefaultProjects() -> [[String: String]] {
        var defaultProjects: [[String: String]] = []
        var projectCount = 0
        do {
            let realm = try Realm()
            projectCount = realm.objects(ProjectModel).count
        } catch {
            print(error)
        }
        if projectCount == 0 {
            for projectName in defaultProjectNames {
                let projectId = self.addProject(projectName)
                let projectDict = [
                    "project_id": projectId,
                    "project_name": projectName
                ]
                defaultProjects.append(projectDict)
            }
        }
        return defaultProjects
    }
}
