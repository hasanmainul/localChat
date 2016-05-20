//
//  UsersManager.swift
//  LocalChat
//
//  Created by Md Mainul Haque on 5/17/16.
//  Copyright © 2016 Md Mainul Haque. All rights reserved.
//

import UIKit

class UsersManager: NSObject {
    static let sharedInstance = UsersManager()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    private var users = [[String: AnyObject]]()
    
    override init() {
        super.init()
        users = [["userName": "BOT1", "avatar": "map_setting", "selectedForChat": true],
                 ["userName": "BOT2", "avatar": "map_setting", "selectedForChat": false],
                 ["userName": "HASAN", "avatar": "map_setting", "selectedForChat": true],
                 ["userName": "HASAN1", "avatar": "map_setting", "selectedForChat": false],
                 ["userName": "TANI", "avatar": "map_setting", "selectedForChat": false]]
        defaults.setObject(users, forKey: Constants.keyUsers)
    }
    
    func getUsers() -> [[String: AnyObject]] {
        users = defaults.objectForKey(Constants.keyUsers) as? [[String: AnyObject]] ?? [[String: AnyObject]]()
        return users
    }
    
    func setUser(userName: String, avatarURL: String, selectedForChat: Bool) {
        var dict = [String: AnyObject]()
        dict[Constants.userManagerDictionary.keyName] = userName
        dict[Constants.userManagerDictionary.keyAvatar] = avatarURL
        dict[Constants.userManagerDictionary.keySeleceted] = selectedForChat
        users.append(dict)
        defaults.setObject(users, forKey: Constants.keyUsers)
        defaults.synchronize()
    }
    
    func updateUserSelectedForChat(userObject: [[String: AnyObject]]) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(userObject, forKey: Constants.keyUsers)
        defaults.synchronize()
    }
}
