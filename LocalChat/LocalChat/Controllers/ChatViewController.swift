//
//  ChatViewController.swift
//  LocalChat
//
//  Created by Md Mainul Haque on 5/9/16.
//  Copyright © 2016 Md Mainul Haque. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var chatUserNameLabel: PaddingUILabel!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var userSegmentControl: UISegmentedControl!
    @IBOutlet weak var chatTextField: UITextField!
    
    var frameView: UIView!
    var chatMessages = [[String: AnyObject]]()
    var users = [[String: AnyObject]]()
    
    let passiveChatCellIdentifier = "passiveChatCell"
    let activeChatCellIdentifier = "activeChatCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        chatMessages = ChatManager.sharedInstance.getChatDictionary()
        users = UsersManager.sharedInstance.getUsers()
        
        self.frameView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        
        // Observer Methods for keyboard to show and hide
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        
        // Segment Control
        setSegmentControl()
        
        let userName = userSegmentControl.titleForSegmentAtIndex(userSegmentControl.selectedSegmentIndex) as String!
        chatUserNameLabel?.text = Constants.userIsChatting(userName)
        chatTextField.returnKeyType = .Send
        chatTableView.reloadData()
        scrollToBottom()
    }
    
    override func viewWillDisappear(animated: Bool) {
        // release the observer for keyBoard
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction func userSegmentControlAction(sender: AnyObject) {
        let userName = userSegmentControl.titleForSegmentAtIndex(userSegmentControl.selectedSegmentIndex) as String!
        chatUserNameLabel?.text = Constants.userIsChatting(userName)
        chatTableView.reloadData()
        scrollToBottom()
    }
    
    // MARK: - Textfield delegates and datasource
    
    func textFieldDidEndEditing(textField: UITextField) {
        let userName = userSegmentControl.titleForSegmentAtIndex(userSegmentControl.selectedSegmentIndex) as String!
        
         if chatTextField?.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).characters.count != 0 {
            ChatManager.sharedInstance.sendChatMessage(chatTextField.text!, withUserName: userName, sentTime: NSDate.init())
            chatMessages = ChatManager.sharedInstance.getChatDictionary()
            chatTextField?.text = ""
            self.chatTableView.reloadData()
            scrollToBottom()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return self.view.endEditing(true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Keyboard Handling
    
    func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let keyboardHeight = keyboardSize.height
        
        UIView.animateWithDuration(0.25, delay: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.view.frame = CGRectMake(0, (self.frameView.frame.origin.y - keyboardHeight), self.view.bounds.width, self.view.bounds.height)
            }, completion: nil)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.25, delay: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.view.frame = CGRectMake(0, (self.frameView.frame.origin.y), self.view.bounds.width, self.view.bounds.height)
            }, completion: nil)
    }
    
    // MARK: - TableView datasource and delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var dict = chatMessages[indexPath.row]
        let message = dict[Constants.chatManagerDictionary.keyMessage] as? String
        let userName = dict[Constants.chatManagerDictionary.keyName] as? String
        let sentTime = dict[Constants.chatManagerDictionary.keyTime] as? String

        if userName != userSegmentControl.titleForSegmentAtIndex(userSegmentControl.selectedSegmentIndex) as String! {
            let cell = tableView.dequeueReusableCellWithIdentifier(passiveChatCellIdentifier, forIndexPath: indexPath) as! PassiveChatCell
            cell.passiveChatLabel?.text = message
            cell.passiveNameLabel?.text = userName
            cell.passiveTimeLabel?.text = sentTime
            cell.passiveImageView.hidden = self.consequetiveChatFromSameUser(indexPath.row)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(activeChatCellIdentifier, forIndexPath: indexPath) as! ActiveChatCell
            cell.activeChatLabel?.text = message
            cell.activeNameLabel?.text = userName
            cell.activeTimeLabel?.text = sentTime
            cell.activeImageView.hidden = self.consequetiveChatFromSameUser(indexPath.row)
            return cell
        }
    }
    
    // MARK: - Custom Methods
    
    func consequetiveChatFromSameUser(index: NSInteger) -> Bool {
        if index == 0 {
            return false
        }
        
        var currentDict = chatMessages[index]
        var previousDict = chatMessages[index - 1]
        
        let currentUser = currentDict[Constants.chatManagerDictionary.keyName] as? String
        let previousUser = previousDict[Constants.chatManagerDictionary.keyName] as? String
        
        if (currentUser == previousUser) {
            return true
        }
        return false
    }
    
    func scrollToBottom() {
        if chatMessages.count > 0 {
            let lastRowIndexPath = NSIndexPath(forRow:chatMessages.count - 1, inSection: 0)
            chatTableView.scrollToRowAtIndexPath(lastRowIndexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated:true)
        }
    }
    
    func setSegmentControl() {
        userSegmentControl.removeAllSegments()
        for i in 0..<users.count {
            var currentUser = users[i]
            let userIsSelected = currentUser[Constants.userManagerDictionary.keySeleceted] as? Bool
            let userName = currentUser[Constants.userManagerDictionary.keyName] as? String
            if (userIsSelected != false) {
            userSegmentControl.insertSegmentWithTitle(userName, atIndex: i, animated: true)
            }
        }
        userSegmentControl.selectedSegmentIndex = 0;
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {        
        if segue.identifier == "showSetting" {
            let nav = segue.destinationViewController as! UINavigationController
            let settingViewController = nav.topViewController as! SettingViewController
            settingViewController.backButtonPressedClosure = {(checkedNumber: Int) -> () in
                
            }
        }
    }
    
}
