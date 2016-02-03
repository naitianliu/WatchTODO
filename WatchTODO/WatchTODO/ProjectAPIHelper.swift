//
//  ProjectAPIHelper.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 2/2/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation

class ProjectAPIHelper: CallAPIHelperDelegate {
    
    let apiURL_AddProject = "\(const_APIEndpoint)todo/add_project/"
    let apiURL_InitiateDefaultProjects = "\(const_APIEndpoint)todo/initiate_default_projects/"
    let apiURL_GetAllProjects = ""
    let apiURL_RemoveProject = ""
    
    let index_AddProject = "AddProject"
    let index_InitiateDefaultProjects = "InitiateDefaultProjects"
    let index_GetAllProjects = "GetAllProjects"
    let index_RemoveProject = "RemoveProject"
    
    let projectModelHelper = ProjectModelHelper()
    
    init() {
        
    }
    
    func addProject(projectName: String) {
        let projectId = projectModelHelper.addProject(projectName)
        let data: [String: AnyObject] = [
            "project_id": projectId,
            "project_name": projectName
        ]
        CallAPIHelper(url: apiURL_AddProject, data: data, delegate: self).POST(index_AddProject)
    }
    
    func initiateDefaultProjects() {
        let defaultProjects = projectModelHelper.initiateDefaultProjects()
        let data: [String: AnyObject] = ["default_projects": defaultProjects]
        CallAPIHelper(url: apiURL_InitiateDefaultProjects, data: data, delegate: self).POST(index_InitiateDefaultProjects)
    }
    
    func beforeSendRequest(index: String?) {
        
    }
    
    func afterReceiveResponse(responseData: AnyObject, index: String?) {
        if index == index_AddProject {
            
        } else if index == index_InitiateDefaultProjects {
            
        }
    }
    
    func apiReceiveError(error: ErrorType) {
        
    }
    
}