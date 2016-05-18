//
//  SettingViewController.swift
//  LocalChat
//
//  Created by Md Mainul Haque on 5/10/16.
//  Copyright © 2016 Md Mainul Haque. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var checked: [Bool] = [false, false, false, false]
    var checkedNumber: Int = 0
    var backButtonPressedClosure: (Int -> ())!
    var userList = [[String: AnyObject]]()
    
    @IBOutlet weak var settingTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)        
        userList = UsersManager.sharedInstance.getUsers()
        
        for i in 0..<userList.count {
            let dict = userList[i]
            checked[i] = (dict[Constants.userManagerDictionary.keySeleceted] as? Bool)!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: -TableView delegate and datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("settingCell", forIndexPath: indexPath)
        if !checked[indexPath.row] {
            cell.accessoryType = .None
        } else if checked[indexPath.row] {
            cell.accessoryType = .Checkmark
        }
        
        var dict = userList[indexPath.row]
        let userName = dict[Constants.userManagerDictionary.keyName] as? String
        let avatarURL = dict[Constants.userManagerDictionary.keyAvatar] as? String
        cell.textLabel!.text = userName
        cell.imageView?.image = UIImage(named: avatarURL!)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .Checkmark {
                cell.accessoryType = .None
                checked[indexPath.row] = false
            } else {
                cell.accessoryType = .Checkmark
                checked[indexPath.row] = true
            }
        }
    }
    
    // MARK: - Custom methods
    
    func numberOfCheckedUser() -> Int {
        var userListTemp = [[String: AnyObject]]()
        for i in 0..<userList.count {
            var dict = userList[i]
            let cell = self.settingTableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0))
            if cell?.accessoryType == .Checkmark {
                checkedNumber += 1
                dict[Constants.userManagerDictionary.keySeleceted] = true
            } else {
                dict[Constants.userManagerDictionary.keySeleceted] = false
            }
            userListTemp.append(dict)
        }
        UsersManager.sharedInstance.updateUserSelectedForChat(userListTemp)
        return checkedNumber
    }
    
    func showAlert() {
        checkedNumber = 0
        let alert = UIAlertController(title: "Naaaaa!", message: "Please select at least two user", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in self.viewWillAppear(true)}))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        let countCheck = numberOfCheckedUser()
        if countCheck < 2 {
            showAlert()
        } else {
            backButtonPressedClosure?(countCheck)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
