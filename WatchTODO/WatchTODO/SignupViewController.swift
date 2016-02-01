//
//  SignupViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/23/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import Toast
import MBProgressHUD

protocol SignupVCDelegate {
    func didSignupSucceed(username: String)
}

class SignupViewController: UIViewController, CallAPIHelperDelegate {
    
    let apiURL_Signup = "\(const_APIEndpoint)auth/register/"

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    
    var delegate: SignupVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    @IBAction func signupButtonOnClick(sender: AnyObject) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        let confirmPassword = confirmPasswordTextField.text
        let nickname = nicknameTextField.text
        if password != confirmPassword {
            self.view.makeToast("Inconsistent password input, please try again")
            passwordTextField.text = nil
            confirmPasswordTextField.text = nil
        } else {
            let data: [String: AnyObject] = [
                "username": username!,
                "password": password!,
                "nickname": nickname!
            ]
            CallAPIHelper(url: apiURL_Signup, data: data, delegate: self).POST(nil)
        }
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        nicknameTextField.resignFirstResponder()
    }
    
    @IBAction func switchToLoginButtonOnClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    func beforeSendRequest(index: String?) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    
    func afterReceiveResponse(responseData: AnyObject, index: String?) {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        let data = responseData as! [String: AnyObject]
        let token = data["token"] as! String
        let userInfo = data["user_info"] as! [String: String]
        let username = userInfo["username"]
        let profileImageURL = userInfo["profile_image_url"]
        let nickname = userInfo["nickname"]
        UserDefaultsHelper().createOrUpdateUserInfo(username, profileImageURL: profileImageURL, nickname: nickname, token: token)
        delegate?.didSignupSucceed(username!)
    }
    
    func apiReceiveError(error: ErrorType) {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
}
