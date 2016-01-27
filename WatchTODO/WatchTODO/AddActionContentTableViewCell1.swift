//
//  AddActionContentTableViewCell.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/16/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class AddActionContentTableViewCell1: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var textView: UITextView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textView?.scrollEnabled = false
        textView?.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            textView?.becomeFirstResponder()
        } else {
            textView?.resignFirstResponder()
        }

    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var textString: String {
        get {
            return textView?.text ?? ""
        }
        set {
            if let textView = textView {
                textView.text = newValue
                
                textViewDidChange(textView)
            }
        }
    }
}

extension AddActionContentTableViewCell1: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.max))
        
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView?.beginUpdates()
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
        
        if let thisIndexPath = tableView?.indexPathForCell(self) {
            tableView?.scrollToRowAtIndexPath(thisIndexPath, atScrollPosition: .Bottom, animated: false)
        }
    }
}

extension AddActionContentTableViewCell1 {
    var tableView: UITableView? {
        get {
            var table: UIView? = superview
            while !(table is UITableView) && table != nil {
                table = table?.superview
            }
            return table as? UITableView
        }
    }
}
