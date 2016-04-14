//
//  SettingsViewController.swift
//  Hype-2
//
//  Created by max payson on 4/13/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController{
    @IBOutlet var userNameLabel: UILabel!
    
    var userName: String?
    var settingsDelegate: SettingsViewControllerDelegate!
    
    override func viewDidLoad() {
        userNameLabel.text = userName
    }
    
    @IBAction func onSignOutClicked(sender: AnyObject){
        let keychainWrapper = KeychainWrapper.standardKeychainAccess()
        keychainWrapper.removeObjectForKey(Constants.PASSKEY)
        keychainWrapper.removeObjectForKey(Constants.USERKEY)
        settingsDelegate.onSignOut()
        
    }

}

protocol SettingsViewControllerDelegate {
    func onSignOut()
}


