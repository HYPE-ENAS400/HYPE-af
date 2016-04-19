//
//  UsersTableViewController.swift
//  Hype-2
//
//  Created by max payson on 4/19/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

import UIKit

class UsersTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var cancelButton: UIButton!
    
    var userDictionary: [String: String]!
    var userNames: [String] = []
    var ownUID: String!
    var keyForFriend: String!
    var ref: Firebase!
//    var height: CGFloat!
    
    override func viewDidLoad() {
//        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
//        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
//        tableView.contentInset = insets
//        tableView.scrollIndicatorInsets = insets
        
        tableView.dataSource = self
        tableView.delegate = self
        
        userDictionary = [String:String]()
        
        ref = Firebase(url: "https://enas400hype.firebaseio.com/").childByAppendingPath("users")
        
        ref.queryOrderedByChild("username").observeEventType(.ChildAdded, withBlock: { snapshot in
            if snapshot.key != self.ownUID{
                if let name = snapshot.value["username"] as? String {
                    self.userDictionary[name] = snapshot.key
                    self.userNames.append(name)
            }
            }
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        cell.textLabel?.text = userNames[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let uid = userDictionary[userNames[indexPath.row]]
        ref.childByAppendingPath(uid).childByAppendingPath("adsFromFriends").childByAutoId().setValue(keyForFriend)
        self.performSegueWithIdentifier("unwindFromUsersSegue", sender: nil)
        print(uid)
    }
    
    @IBAction func onCancelButtonClicked(sender: AnyObject){
        self.performSegueWithIdentifier("unwindFromUsersSegue", sender: nil)
    }
    
    
}
