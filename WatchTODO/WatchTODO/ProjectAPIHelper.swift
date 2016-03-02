//
//  ProjectAPIHelper.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 2/2/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation

protocol ProjectAPIHelperDelegate {
    func didAddProject()
    func failAddProject()
}

class ProjectAPIHelper: CallAPIHelperDelegate {
    
    let apiURL_AddProject = "\(const_APIEndpoint)todo/add_project/"
    let apiURL_GetAllProjects = "\(const_APIEndpoint)todo/get_all_projects/"
    let apiURL_RemoveProject = ""
    
    let index_AddProject = "AddProject"
    let index_GetAllProjects = "GetAllProjects"
    let index_RemoveProject = "RemoveProject"
    
    let projectModelHelper = ProjectModelHelper()
    
    var tempProjectName: String = ""
    var tempWatchers: [String] = []
    
    var delegate: ProjectAPIHelperDelegate?
    
    init() {
        
    }
    
    func addProject(projectName: String, watchers: [String]) {
        tempProjectName = projectName
        tempWatchers = watchers
        
        let data: [String: AnyObject] = [
            "project_name": projectName,
            "watchers": watchers
        ]
        CallAPIHelper(url: apiURL_AddProject, data: data, delegate: self).POST(index_AddProject)
    }
    
    func getAllProjects() {
        CallAPIHelper(url: apiURL_GetAllProjects, data: nil, delegate: self).GET(index_GetAllProjects)
    }
    
    func beforeSendRequest(index: String?) {
        
    }
    
    func afterReceiveResponse(responseData: AnyObject, index: String?) {
        if index == index_AddProject {
            let resDict = responseData as! [String: AnyObject]
            let projectId = resDict["project_id"] as! String
            projectModelHelper.addProject(projectId, projectName: tempProjectName)
            projectModelHelper.addUpdateWatchersIntoProject(projectId, watchers: tempWatchers)
            delegate?.didAddProject()
        } else if index == index_GetAllProjects {
            let resDict = responseData as! [String: AnyObject]
            let projects = resDict["projects"] as! [[String: AnyObject]]
            for project in projects {
                let projectId = project["project_id"] as! String
                let projectName = project["project_name"] as! String
                let watchers = project["watchers"] as! [String]
                projectModelHelper.addProject(projectId, projectName: projectName)
                projectModelHelper.addUpdateWatchersIntoProject(projectId, watchers: watchers)
            }
        }
    }
    
    func apiReceiveError(error: ErrorType) {
        delegate?.failAddProject()
    }
    
}