//
//  AppDelegate.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/16/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import MMDrawerController
import RealmSwift

protocol APNSNotificationDelegate {
    func didReceiveCommentNotification(actionId: String)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LoginVCDelegate {

    var window: UIWindow?
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let todoStoryboard = UIStoryboard(name: "MyTodoList", bundle: nil)
    var drawerController: MMDrawerController!
    
    var apnsDelegate: APNSNotificationDelegate?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let mainTabBarController = mainStoryboard.instantiateViewControllerWithIdentifier("MainTabBarController") as! MainTabBarController
        let projectsNavigationController = todoStoryboard.instantiateViewControllerWithIdentifier("ProjectsNavigationController") as! UINavigationController
        drawerController = MMDrawerController(centerViewController: mainTabBarController, leftDrawerViewController: projectsNavigationController)
        drawerController.showsShadow = false
        drawerController.maximumLeftDrawerWidth = UIScreen.mainScreen().bounds.width / 2
        // login view controller
        let isLogin = UserDefaultsHelper().checkIfLogin()
        if !isLogin {
            self.switchToLoginVC()
        } else {
            
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Badge, .Alert, .Sound], categories: nil))
            UIApplication.sharedApplication().registerForRemoteNotifications()
            self.window?.rootViewController = drawerController
            // perform database migrations
            PerformMigrations().migrate()
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let deviceTokenString = self.dataToHex(deviceToken)
        print(deviceTokenString)
        UserDefaultsHelper().updateDeviceToken(deviceTokenString)
        WatchAPIHelper().updateDeviceToken()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print(userInfo)
        let actionId: String = userInfo["action_id"] as! String
        self.apnsDelegate?.didReceiveCommentNotification(actionId)
    }
    
    func didLoginToSwitchRootVC(username: String) {
        self.window?.rootViewController = drawerController
        ProjectAPIHelper().initiateDefaultProjects()
        SyncHelper().syncAfterLogin()
    }

    func switchToLoginVC() {
        let loginViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        loginViewController.delegate = self
        self.window?.rootViewController = loginViewController
    }
    
    private func dataToHex(data: NSData) -> String {
        var str: String = String()
        let p = UnsafePointer<UInt8>(data.bytes)
        let len = data.length
        for var i=0; i<len; ++i {
            str += String(format: "%02.2X", p[i])
        }
        return str
    }
}

