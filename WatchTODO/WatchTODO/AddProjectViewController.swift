//
//  AddProjectViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/17/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

protocol AddProjectVCDelegate {
    func didAddNewProject(projectName:String)
}

class AddProjectViewController: UIViewController {

    @IBOutlet weak var projectNameTextField: UITextField!
    
    var delegate: AddProjectVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        projectNameTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func doneButtonOnClick(sender: AnyObject) {
        let projectName = projectNameTextField.text
        if let projectName = projectName {
            delegate?.didAddNewProject(projectName)
        }
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    @IBAction func cancelButtonOnClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
}