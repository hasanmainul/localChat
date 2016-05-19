//
//  SettingViewController.swift
//  LocalChat
//
//  Created by Md Mainul Haque on 5/10/16.
//  Copyright © 2016 Md Mainul Haque. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var checked = [Bool](count: 8, repeatedValue: false)
    var checkedNumber: Int = 0
    var backButtonPressedClosure: (Int -> ())!
    var userList = [[String: AnyObject]]()
    var tableSection: Int = 1
    var editButtonStartPress: Bool = true
    let settingCellIdentifier = "settingCell"
    let customCellIdentifier = "customSettingCell"
    
    @IBOutlet weak var settingTableView: UITableView!
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
    
    @IBAction func editButtonPressed(sender: AnyObject) {      
        if editButtonStartPress {
            editBarButton?.title = Constants.saveTitle
            editButtonStartPress = false
            settingTableView.beginUpdates()
            settingTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: userList.count, inSection: 0)], withRowAnimation: .Automatic)
            settingTableView.endUpdates()
            settingTableView.reloadData()

        } else {
            editBarButton?.title = Constants.editTitle
            editButtonStartPress = true
            settingTableView.reloadData()
        }
    }
}
