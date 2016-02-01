//
//  LoginViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/23/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import MBProgressHUD
import RealmSwift

protocol LoginVCDelegate {
    func didLoginToSwitchRootVC()
}

class LoginViewController: UIViewController, CallAPIHelperDelegate, SignupVCDelegate {
    
    let apiURL_Login = "\(const_APIEndpoint)auth/login/"

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var delegate: LoginVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.secureTextEntry = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonOnClick(sender: AnyObject) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        let data: [String: AnyObject] = ["username": username!, "password": password!]
        CallAPIHelper(url: apiURL_Login, data: data, delegate: self).POST("login")
    }
    
    @IBAction func signupButtonOnClick(sender: AnyObject) {
        let signupVC = self.storyboard?.instantiateViewControllerWithIdentifier("SignupViewController") as! SignupViewController
        signupVC.delegate = self
        signupVC.modalTransitionStyle = .FlipHorizontal
        self.presentViewController(signupVC, animated: true) { () -> Void in
            
        }
    }
    
    func beforeSendRequest(index: String?) {
        if index == "login" {
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        }
    }
    
    func afterReceiveResponse(responseData: AnyObject, index: String?) {
        if index == "login" {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            let data = responseData as! [String: AnyObject]
            let token = data["token"] as! String
            let userInfo = data["user_info"] as! [String: String]
            let username = userInfo["username"]
            let profileImageURL = userInfo["profile_image_url"]
            let nickname = userInfo["nickname"]
            UserDefaultsHelper().createOrUpdateUserInfo(username, profileImageURL: profileImageURL, nickname: nickname, token: token)
            self.setDefaultRealmForUser(username!)
            delegate?.didLoginToSwitchRootVC()
        }
    }
    
    func apiReceiveError(error: ErrorType) {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
    func setDefaultRealmForUser(username: String) {
        var config = Realm.Configuration()
        // Use the default directory, but replace the filename with the username
        config.path = NSURL.fileURLWithPath(config.path!)
            .URLByDeletingLastPathComponent?
            .URLByAppendingPathComponent("\(username).realm")
            .path
        
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }

    func didSignupSucceed(username: String) {
        self.setDefaultRealmForUser(username)
        delegate?.didLoginToSwitchRootVC()
    }
}
