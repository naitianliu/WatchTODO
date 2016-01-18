//
//  ProjectModel.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/17/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import RealmSwift

class ProjectModel: Object {
    
    dynamic var name = ""
    
    override static func primaryKey() -> String {
        return "name"
    }
}

class ProjectModelHelper {
    init() {
        
    }
    
    func addProject(projectName:String) {
        let project = ProjectModel()
        project.name = projectName
        do {
            let realm = try Realm()
            try realm.write({ () -> Void in
                realm.add(project)
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
                    "name": project.name
                ]
                projects.append(projectDict)
            }
        } catch {
            print(error)
        }
        return projects
    }
}
