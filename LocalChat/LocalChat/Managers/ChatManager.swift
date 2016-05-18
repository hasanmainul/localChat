//
//  ChatManager.swift
//  LocalChat
//
//  Created by Md Mainul Haque on 5/12/16.
//  Copyright © 2016 Md Mainul Haque. All rights reserved.
//

import UIKit

class ChatManager: NSObject {
    static let sharedInstance = ChatManager()
    
    private var chatInfo = [[String: AnyObject]]()
    let defaults = NSUserDefaults.standardUserDefaults()
  
    override init() {
        super.init()
    }
    
    func getChatDictionary() -> [[String: AnyObject]] {
        chatInfo = defaults.objectForKey(Constants.keyChats) as? [[String: AnyObject]] ?? [[String: AnyObject]]()
        return chatInfo
    }
    
    func sendChatMessage(message: String, withUserName userName: String?, sentTime: NSDate) -> [[String: AnyObject]] {
        let timeFormatter: NSDateFormatter = NSDateFormatter()
        timeFormatter.dateFormat = Constants.dateFormat.dateFormatStyle2
        let timeString = timeFormatter.stringFromDate(sentTime)
        
        var dict = [String: AnyObject]()
        dict[Constants.chatManagerDictionary.keyMessage] = message
        dict[Constants.chatManagerDictionary.keyName] = userName
        dict[Constants.chatManagerDictionary.keyTime] = timeString
        chatInfo.append(dict)
        defaults.setObject(chatInfo, forKey: Constants.keyChats)
        defaults.synchronize()
        return chatInfo
    }
}
