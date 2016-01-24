//
//  CallAPIHelper.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/23/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import Alamofire

protocol CallAPIHelperDelegate {
    func beforeSendRequest(index:String?)
    func afterReceiveResponse(responseData:AnyObject, index:String?)
    func apiReceiveError(error:ErrorType)
}

class CallAPIHelper: NSObject {
    
    var headers:[String: String] = ["Content-Type": "application/json"]
    
    var delegate:CallAPIHelperDelegate?
    
    var data:[String:AnyObject]?
    
    var url:String!
    
    var manager:Alamofire.Manager?
    
    init(url:String!, data:[String:AnyObject]?, delegate:CallAPIHelperDelegate) {
        super.init()
        
        self.delegate = delegate
        self.url = url
        self.data = data
        if NSUserDefaults.standardUserDefaults().objectForKey("token") != nil {
            let token:String = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("token") as! NSData) as! String
            self.headers["Authorization"] = "Token \(token)"
        }
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 20
        let serverTrustPolicy = ServerTrustPolicy.DisableEvaluation
        self.manager = Alamofire.Manager(configuration: configuration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: ["opsinhand.vip.stratus.ebay.com" : serverTrustPolicy]))
        
    }
    
    func POST(index:String?) {
        self.delegate?.beforeSendRequest(index)
        self.manager!.request(.POST, self.url, parameters: self.data, encoding: .JSON, headers: self.headers).responseJSON(options: NSJSONReadingOptions.AllowFragments) { (response) -> Void in
            let result = response.result
            switch result {
            case .Success(let JSON):
                self.delegate?.afterReceiveResponse(JSON, index:index)
            case .Failure(let error):
                print(error)
                self.delegate?.apiReceiveError(error)
            }
        }
    }
    
    func GET(index:String?) {
        self.delegate?.beforeSendRequest(index)
        self.manager!.request(.GET, self.url, parameters: self.data, headers: self.headers).responseJSON(options: NSJSONReadingOptions.AllowFragments) { (response) -> Void in
            let result = response.result
            switch result {
            case .Success(let JSON):
                self.delegate?.afterReceiveResponse(JSON, index:index)
            case .Failure(let error):
                print(error)
                self.delegate?.apiReceiveError(error)
            }
        }
    }
}