//
//  PassiveChatCell.swift
//  LocalChat
//
//  Created by Md Mainul Haque on 5/9/16.
//  Copyright © 2016 Md Mainul Haque. All rights reserved.
//

import UIKit

class PassiveChatCell: UITableViewCell {

    @IBOutlet weak var passiveChatLabel: PaddingUILabel!
    @IBOutlet weak var passiveNameLabel: UILabel!
    @IBOutlet weak var passiveTimeLabel: UILabel!
    @IBOutlet weak var passiveImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        passiveImageView.hidden = false
        passiveChatLabel.layer.borderColor = UIColor.blueColor().CGColor
        passiveChatLabel.layer.borderWidth = 1.0

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
