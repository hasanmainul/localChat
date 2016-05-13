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
    
    var chatInfo = [[String: AnyObject]]()
  
    override init() {
        super.init()
    }
    
//    func getChatInfo(completionHandler: (messageInfo: [[String: AnyObject]]) -> Void) {
//        completionHandler(messageInfo: chatInfo)
//    }
    
    func sendChatMessage(message: String, withUserName userName: String?) -> [[String: AnyObject]] {
        var dict = [String: AnyObject]()
        dict[Constants.chatManagerDictionary.keyMessage] = message
        dict[Constants.chatManagerDictionary.keyName] = userName
        chatInfo.append(dict)
        return chatInfo
    }
}
