//
//  SettingViewController.swift
//  LocalChat
//
//  Created by Md Mainul Haque on 5/10/16.
//  Copyright © 2016 Md Mainul Haque. All rights reserved.
//

import UIKit

protocol NumberOfSegmentRequiredDelegate: class {
    func numberOfSegment(checked: Int)
}

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: NumberOfSegmentRequiredDelegate?
    var checked : [Bool] = [false, false, false, false]
    var checkedName : Int = 0
    
    @IBOutlet weak var settingTableView: UITableView!
    
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        if (self.delegate != nil) {
            self.delegate?.numberOfSegment(checkedName)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -TableView
    
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
                checkedName += 1
            }
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