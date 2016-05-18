//
//  PaddingUILabel.swift
//  LocalChat
//
//  Created by Md Mainul Haque on 5/18/16.
//  Copyright © 2016 Md Mainul Haque. All rights reserved.
//

import UIKit

class PaddingUILabel: UILabel {
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, padding))
    }
    
    // Override -intrinsicContentSize: for Auto layout code
    override func intrinsicContentSize() -> CGSize {
        let superContentSize = super.intrinsicContentSize()
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }

}
