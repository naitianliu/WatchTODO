//
//  SideMenuViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/16/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    var menuItems = [UIView]()
    
    let statusBarHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
    let screenHeight:CGFloat = UIScreen.mainScreen().bounds.height
    var viewHeight: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewHeight = screenHeight - statusBarHeight
        
        self.preferredContentSize = CGSize(width: 80, height: viewHeight)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
