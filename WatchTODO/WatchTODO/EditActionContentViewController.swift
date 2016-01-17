//
//  EditActionContentViewController.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/16/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

protocol EditActionContentVCDelegate {
    func didEditActionContent(content: String)
}

class EditActionContentViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var actionTableView: UITableView!
    @IBOutlet weak var contentTextView: UITextView!
    
    var contentString: String?
    
    var delegate: EditActionContentVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentTextView.delegate = self
        contentTextView.becomeFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonOnClick(sender: AnyObject) {
        contentString = contentTextView.text
        delegate?.didEditActionContent(contentString!)
        self.navigationController?.popViewControllerAnimated(true)
    }

}
