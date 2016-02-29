//
//  DropdownActionInfoViewHelper.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 2/28/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit

class DropdownActionInfoViewHelper {
    
    var navigationItem: UINavigationItem!
    
    init(navigationItem: UINavigationItem) {
        self.navigationItem = navigationItem
        let titleButton = self.titleViewButton("Info")
        self.navigationItem.titleView = titleButton
    }
    
    private func titleViewButton(title: String) -> UIButton {
        let titleButton = UIButton()
        titleButton.setTitle(title, forState: UIControlState.Normal)
        titleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        titleButton.setImage(UIImage(named: "arrow_up"), forState: UIControlState.Normal)
        titleButton.setImage(UIImage(named: "arrow_down"), forState: UIControlState.Selected)
        titleButton.backgroundColor = UIColor.redColor()
        return titleButton
    }
}