//
//  EditUserCell.swift
//  LocalChat
//
//  Created by Md Mainul Haque on 5/19/16.
//  Copyright © 2016 Md Mainul Haque. All rights reserved.
//

import UIKit

class EditUserCell: UITableViewCell {

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editableUserNameTextField: UITextField!
    @IBOutlet weak var editableUserAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
