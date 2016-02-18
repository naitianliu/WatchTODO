//
//  MainTabBarController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/16/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let myTodoListStoryboard = UIStoryboard(name: "MyTodoList", bundle: nil)
    let messageStoryboard = UIStoryboard(name: "Message", bundle: nil)
    let watchStoryboard = UIStoryboard(name: "Watch", bundle: nil)
    let settingsStoryboard = UIStoryboard(name: "Settings", bundle: nil)
    
    var myTodoListNC: MyTodoListNavigationController!
    var messageNC: UINavigationController!
    var watchNC: UINavigationController!
    var settingsNC: UINavigationController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tabBar.tintColor = const_ThemeColor
        
        myTodoListNC = myTodoListStoryboard.instantiateViewControllerWithIdentifier("MyTodoListNavigationController") as! MyTodoListNavigationController
        myTodoListNC.tabBarItem.title = "My Todo List"
        myTodoListNC.tabBarItem.image = UIImage(named: "tab_todo_list")
        
        messageNC = messageStoryboard.instantiateViewControllerWithIdentifier("MessageNavigationController") as! UINavigationController
        messageNC.tabBarItem.title = "Message"
        messageNC.tabBarItem.image = UIImage(named: "tab_message")
        messageNC.tabBarItem.badgeValue = "1"
        
        watchNC = watchStoryboard.instantiateViewControllerWithIdentifier("WatchNavigationController") as! UINavigationController
        watchNC.tabBarItem.title = "Watch"
        watchNC.tabBarItem.image = UIImage(named: "tab_watch")
        
        settingsNC = settingsStoryboard.instantiateViewControllerWithIdentifier("SettingsNavigationController") as! UINavigationController
        settingsNC.tabBarItem.title = "Settings"
        settingsNC.tabBarItem.image = UIImage(named: "tab_settings")
        
        self.viewControllers = [myTodoListNC, messageNC, watchNC, settingsNC]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
