//
//  MainTabBarController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/16/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, MessageVCDelegate, AddActionVCDelegate {
    
    let myTodoListStoryboard = UIStoryboard(name: "MyTodoList", bundle: nil)
    let messageStoryboard = UIStoryboard(name: "Message", bundle: nil)
    let watchStoryboard = UIStoryboard(name: "Watch", bundle: nil)
    let settingsStoryboard = UIStoryboard(name: "Settings", bundle: nil)
    
    var myTodoListNC: MyTodoListNavigationController!
    var messageNC: UINavigationController!
    var watchNC: UINavigationController!
    var settingsNC: UINavigationController!
    
    var myTodoListVC: MyTodoListViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tabBar.tintColor = const_ThemeColor
        
        myTodoListNC = myTodoListStoryboard.instantiateViewControllerWithIdentifier("MyTodoListNavigationController") as! MyTodoListNavigationController
        myTodoListNC.tabBarItem.title = "My Todo List"
        myTodoListNC.tabBarItem.image = UIImage(named: "tab_todo_list")
        self.myTodoListVC = myTodoListNC.viewControllers[0] as! MyTodoListViewController
        
        messageNC = messageStoryboard.instantiateViewControllerWithIdentifier("MessageNavigationController") as! UINavigationController
        messageNC.tabBarItem.title = "Message"
        messageNC.tabBarItem.image = UIImage(named: "tab_message")
        messageNC.tabBarItem.selectedImage = UIImage(named: "tab_message_selected")
        let messageVC = messageNC.viewControllers[0] as! MessageViewController
        messageVC.delegate = self
        messageVC.appDelegate.apnsDelegate = messageVC.self
        
        watchNC = watchStoryboard.instantiateViewControllerWithIdentifier("WatchNavigationController") as! UINavigationController
        watchNC.tabBarItem.title = "Watch"
        watchNC.tabBarItem.image = UIImage(named: "tab_eye")
        watchNC.tabBarItem.selectedImage = UIImage(named: "tab_eye_selected")
        
        settingsNC = settingsStoryboard.instantiateViewControllerWithIdentifier("SettingsNavigationController") as! UINavigationController
        settingsNC.tabBarItem.title = "Me"
        settingsNC.tabBarItem.image = UIImage(named: "tab_profile")
        settingsNC.tabBarItem.selectedImage = UIImage(named: "tab_profile_selected")
        
        let emptyVC = UIViewController()
        emptyVC.tabBarItem.enabled = false
        
        self.viewControllers = [myTodoListNC, messageNC, emptyVC, watchNC, settingsNC]
        
        self.addCenterButton(btnimage: UIImage(named: "plus-1")!, selectedbtnimg: UIImage(named: "plus-1")!, selector: "addOrderView", view: self.tabBar)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toSetTabBage() {
        if let badgeString = messageNC.tabBarItem.badgeValue {
            messageNC.tabBarItem.badgeValue = String(Int(badgeString)! + 1)
        } else {
            messageNC.tabBarItem.badgeValue = "1"
        }
        
    }
    
    func toCleanTabBadge() {
        messageNC.tabBarItem.badgeValue = nil
    }
    
    func addCenterButton(btnimage buttonImage:UIImage,selectedbtnimg selectedimg:UIImage,selector:String,view:UIView) {
        //创建一个自定义按钮
        let button:UIButton = UIButton(type: UIButtonType.Custom)
        //btn.autoresizingMask
        //button大小为适应图片
        button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
        button.setImage(buttonImage, forState: UIControlState.Normal)
        button.setImage(selectedimg, forState: UIControlState.Selected)
        //去掉阴影
        button.adjustsImageWhenDisabled = true;
        //按钮的代理方法
        button.addTarget( self, action: Selector(selector), forControlEvents:UIControlEvents.TouchUpInside )
        //高度差
        let heightDifference:CGFloat = buttonImage.size.height - self.tabBar.frame.size.height
        if (heightDifference < 0){
            button.center = self.tabBar.center;
        }
        else
        {
            var center:CGPoint = self.tabBar.center;
            // center.y = center.y - heightDifference/2.0;
            center.y = self.tabBar.frame.height / 2 - heightDifference/2.0;
            button.center = center;
        }
        view.addSubview(button);
    }
    
    
    //按钮方法
    func addOrderView() {
        let AddActionNC = self.myTodoListStoryboard.instantiateViewControllerWithIdentifier("AddActionNavigationController") as! UINavigationController
        AddActionNC.modalTransitionStyle = .CoverVertical
        let AddActionVC = AddActionNC.viewControllers[0] as! AddActionViewController
        AddActionVC.delegate = self
        self.presentViewController(AddActionNC, animated: true) { () -> Void in
            
        }
    }
    
    func didAddAction(actionContent: String?, projectId: String?, projectName: String?, dueDate: String?, deferDate: String?, priority: Int?) {
        if let content = actionContent {
            print("Add Action into db")
            self.myTodoListVC.selectedCellIndexPath = nil
            TodoListAPIHelper().addAction(content, projectId: projectId, projectName: projectName, dueDate: dueDate, deferDate: deferDate, priority: priority)
            self.myTodoListVC.setupDisplayItems()
        }
    }

}
