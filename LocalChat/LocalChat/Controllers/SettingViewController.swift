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
    
    @IBOutlet weak var settingTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: -TableView delegate and datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("settingCell", forIndexPath: indexPath)
        if !checked[indexPath.row] {
            cell.accessoryType = .None
        } else if checked[indexPath.row] {
            cell.accessoryType = .Checkmark
        }
        cell.textLabel!.text = "BOT \(indexPath.row + 1)"
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
    
    func countNumberOfCheckemark() -> Int {
        for i in 0...4 {
            let cell = self.settingTableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0))
            if cell?.accessoryType == .Checkmark {
                checkedNumber += 1
            }
        }
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
        let countCheck = countNumberOfCheckemark()
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
