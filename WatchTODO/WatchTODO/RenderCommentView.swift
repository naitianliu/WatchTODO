//
//  RenderCommentView.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/27/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit
import TTTAttributedLabel

class RenderCommentViewHelper: NSObject {
    
    let screenWidth: CGFloat = UIScreen.mainScreen().bounds.width
    
    var comments: [[String: String]]!
    
    init(comments: [[String: String]]) {
        self.comments = comments
    }
    
    func renderCommentView(commentView: UIView) {
        var y: CGFloat = 0
        for comment in comments {
            let tuple = self.renderCommentLabel(comment, yAxis: y)
            let commentLabel = tuple.0
            let height = tuple.1
            y += height
            commentView.addSubview(commentLabel)
        }
    }
    
    func getCommentViewHeight() -> CGFloat {
        var y: CGFloat = 0
        for comment in comments {
            let content: String = comment["content"]!
            let height = self.getLabelHeight(content)
            y += height
        }
        return y
    }
    
    private func getLabelHeight(content: String) -> CGFloat {
        let contentString: NSString = content
        let contentSize: CGSize = contentString.boundingRectWithSize(CGSize(width: screenWidth, height: CGFloat.infinity), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(15)], context: nil).size
        let lineNum: Int = Int(contentSize.height / 15)
        let height = CGFloat(lineNum) * 16
        return height
    }
    
    private func renderCommentLabel(comment:[String: String], yAxis: CGFloat) -> (TTTAttributedLabel, CGFloat) {
        let content: String = comment["content"]!
        // nickname of user who writes the comment
        // let author = comment["nickname"]
        // nickname of user who is replied
        // let replyTo = comment["replyTo"]
        let contentString: NSString = content
        let contentSize: CGSize = contentString.boundingRectWithSize(CGSize(width: screenWidth, height: CGFloat.infinity), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(15)], context: nil).size
        let lineNum: Int = Int(contentSize.height / 15)
        let height = CGFloat(lineNum) * 16
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle()
        style.lineSpacing = 1
        let attributedText: NSAttributedString = NSAttributedString(string: content, attributes: [
            NSParagraphStyleAttributeName: style,
            NSFontAttributeName: UIFont.systemFontOfSize(15),
            NSForegroundColorAttributeName: UIColor.grayColor()
            ])
        let commentLabel: TTTAttributedLabel = TTTAttributedLabel(frame: CGRect(x: 0, y: yAxis, width: screenWidth, height: height))
        commentLabel.numberOfLines = 0
        commentLabel.setText(attributedText)

        return (commentLabel, height)
    }
}