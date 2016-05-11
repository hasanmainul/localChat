//
//  ChatViewController.swift
//  LocalChat
//
//  Created by Md Mainul Haque on 5/9/16.
//  Copyright © 2016 Md Mainul Haque. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, NumberOfSegmentRequiredDelegate {

    @IBOutlet weak var chatUserNameLabel: UILabel!

    @IBOutlet weak var userSegmentControl: UISegmentedControl!
    
    var numberOfSegment : Int = 2
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        userSegmentControl.removeAllSegments()
        for count in 0..<numberOfSegment {
            userSegmentControl.insertSegmentWithTitle("BOT\(count + 1)", atIndex: count, animated: true)
        }
        userSegmentControl.selectedSegmentIndex = 0;
    }
    
    func numberOfSegment(checked: Int) {
        numberOfSegment = checked
        chatUserNameLabel.text = String(checked) // Just for testing delegate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {        
        if segue.identifier == "showSetting" {
            let nav = segue.destinationViewController as! UINavigationController
            let settingViewController = nav.topViewController as! SettingViewController
            settingViewController.delegate = self
        }
    }
    

}
