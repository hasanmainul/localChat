//
//  ActiveChatCell.swift
//  LocalChat
//
//  Created by Md Mainul Haque on 5/9/16.
//  Copyright © 2016 Md Mainul Haque. All rights reserved.
//

import UIKit

class ActiveChatCell: UITableViewCell {

    @IBOutlet weak var activeChatLabel: PaddingUILabel!
    @IBOutlet weak var activeNameLabel: UILabel!
    @IBOutlet weak var activeTimeLabel: UILabel!
    @IBOutlet weak var activeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activeImageView.hidden = false
        activeChatLabel.layer.borderColor = (UIColor.greenColor()).CGColor
        activeChatLabel.layer.borderWidth = 1.0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
