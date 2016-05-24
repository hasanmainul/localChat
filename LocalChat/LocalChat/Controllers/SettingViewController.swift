//
//  SettingViewController.swift
//  LocalChat
//
//  Created by Md Mainul Haque on 5/10/16.
//  Copyright © 2016 Md Mainul Haque. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var checked = [Bool](count: Constants.maxUser, repeatedValue: false)
    var checkedNumber: Int = 0
    var backButtonPressedClosure: (Int -> ())!
    var userList = [[String: AnyObject]]()
    var editButtonStartPress = true
    
    let settingCellIdentifier = "settingCell"
    let customCellIdentifier = "customSettingCell"
    
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var backBarButton: UIBarButtonItem!
    @IBOutlet weak var editBarButton: UIBarButtonItem!

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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if editButtonStartPress {
            return userList.count
        }
        return userList.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if editButtonStartPress {
            let cell = tableView.dequeueReusableCellWithIdentifier(settingCellIdentifier, forIndexPath: indexPath)
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
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(customCellIdentifier, forIndexPath: indexPath) as! EditUserCell
            if indexPath.row == userList.count {
                cell.editableUserNameTextField.placeholder = Constants.namePlaceholder
                cell.deleteButton.hidden = true
                return cell
            }
            var dict = userList[indexPath.row]
            let userName = dict[Constants.userManagerDictionary.keyName] as? String
            let avatarURL = dict[Constants.userManagerDictionary.keyAvatar] as? String
            
            cell.deleteButton.hidden = false
            cell.editableUserNameTextField.delegate = self
            cell.editableUserNameTextField.returnKeyType = UIReturnKeyType.Done
            cell.editableUserNameTextField.text = userName
            cell.editableUserAvatar?.image = UIImage(named: avatarURL!)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if editButtonStartPress {
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
        let alert = UIAlertController(title: Constants.alertMessages.titleForWarning, message: Constants.alertMessages.selectUserMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: Constants.alertMessages.titleOk, style: UIAlertActionStyle.Default, handler:
            {action in self.viewWillAppear(true)}))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func updateUsers() {
        var userListTemp = [[String: AnyObject]]()
        for i in 0..<userList.count {
            var dict = userList[i]
            let cell = settingTableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! EditUserCell
            dict[Constants.userManagerDictionary.keyName] = cell.editableUserNameTextField.text
            userListTemp.append(dict)
        }
        
        let cell = settingTableView.cellForRowAtIndexPath(NSIndexPath(forRow: userList.count, inSection: 0)) as! EditUserCell
        if cell.editableUserNameTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).characters.count != 0 {
            var dict = [String: AnyObject]()
            dict[Constants.userManagerDictionary.keyName] = cell.editableUserNameTextField.text
            dict[Constants.userManagerDictionary.keyAvatar] = "map_setting" // For time being, dummy avatar
            userListTemp.append(dict)
        }
        UsersManager.sharedInstance.updateUserSelectedForChat(userListTemp)
    }
    
    // MARK: - IBActions
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        if editButtonStartPress {
            let countCheck = numberOfCheckedUser()
            if countCheck < 2 || countCheck > 4 {
                showAlert()
            } else {
                backButtonPressedClosure?(countCheck)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        } else {
            editButtonStartPress = true
            backBarButton.title = Constants.backTitle
            editBarButton.title = Constants.editTitle
            settingTableView.reloadData()
        }
    }
    
    @IBAction func editButtonPressed(sender: AnyObject) {
        if editButtonStartPress {
            editBarButton?.title = Constants.saveTitle
            backBarButton.title = Constants.cancelTitle
            editButtonStartPress = false
            settingTableView.beginUpdates()
            settingTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: userList.count, inSection: 0)], withRowAnimation: .Automatic)
            settingTableView.endUpdates()
            settingTableView.reloadData()
        } else {
            editBarButton?.title = Constants.editTitle
            backBarButton.title = Constants.backTitle
            editButtonStartPress = true
            updateUsers()
            userList = UsersManager.sharedInstance.getUsers()
            settingTableView.reloadData()
        }
    }
    
}
