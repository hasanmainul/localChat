//
//  ChatViewController.swift
//  LocalChat
//
//  Created by Md Mainul Haque on 5/9/16.
//  Copyright © 2016 Md Mainul Haque. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var chatUserNameLabel: UILabel!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var userSegmentControl: UISegmentedControl!
    @IBOutlet weak var chatTextField: UITextField!
    
    var frameView: UIView!
    var numberOfSegment: Int = 2
    var chatText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        chatUserNameLabel?.text = String(numberOfSegment)
        
        self.frameView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        
        // Observer Methods for keyboard to show and hide
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        
        //Segment Control
        userSegmentControl.removeAllSegments()
        for count in 0..<numberOfSegment {
            userSegmentControl.insertSegmentWithTitle("BOT\(count + 1)", atIndex: count, animated: true)
        }
        userSegmentControl.selectedSegmentIndex = 0;
        
        chatTableView.reloadData()
    }
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        // release the observer for keyBoard
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        chatText = chatTextField.text!
        chatTextField?.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return self.view.endEditing(true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("passiveChatCell", forIndexPath: indexPath) as! PassiveChatCell
            print(chatText)
            cell.passiveChatLabel?.text = chatText
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("activeChatCell", forIndexPath: indexPath) as! ActiveChatCell
            print(chatText)
            cell.activeChatLabel?.text = chatText
            return cell
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {        
        if segue.identifier == "showSetting" {
            let nav = segue.destinationViewController as! UINavigationController
            let settingViewController = nav.topViewController as! SettingViewController
            settingViewController.backButtonPressedClosure = {(checkedNumber: Int) -> () in
                self.numberOfSegment = checkedNumber
            }
        }
    }
    
}
