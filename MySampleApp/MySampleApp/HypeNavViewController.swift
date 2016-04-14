//
//  HypeNavViewController.swift
//  Hype-2
//
//  Created by max payson on 4/13/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

import UIKit

class HypeNavViewController: UIViewController, SettingsViewControllerDelegate {
    @IBOutlet var gridButton: UIButton!
    @IBOutlet var hypeButton: UIButton!
    @IBOutlet var settingsButton: UIButton!
    var userName: String? {
        didSet{
            settingsViewController?.userName = userName
        }
    }
    var password: String?
    var userUID: String!{
        didSet{
            mainViewController?.userUID = userUID
        }
    }
    
    var mainViewController: MainViewController?
    var settingsViewController: SettingsViewController?
    
    @IBOutlet var hypeBarView: UIView!
    
    @IBOutlet var containerView: UIView!
    
    var isLoggedIn: Bool = false {
        didSet{
            if isLoggedIn == true {
                hypeBarView.hidden = false
                mainViewController?.initImageStore()
                activeViewController = mainViewController
                settingsButton.alpha = 0.7
                hypeButton.alpha = 1
                gridButton.alpha = 0.7
            }
            else {
                self.performSegueWithIdentifier("logInSegue", sender: nil)
            }
            
        }
    }
    
    private var activeViewController: UIViewController?{
        didSet{
            removeInactiveViewController(oldValue)
            updateActiveViewController()
        }
    }
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?){
        if let inActiveVC = inactiveViewController {
            inActiveVC.willMoveToParentViewController(nil)
            inActiveVC.view.removeFromSuperview()
            inActiveVC.removeFromParentViewController()
        }
    }
    
    private func updateActiveViewController(){
        if let activeVC = activeViewController {
            addChildViewController(activeVC)
            activeVC.view.frame = containerView.bounds
            containerView.addSubview(activeVC.view)
            activeVC.didMoveToParentViewController(self)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if !isLoggedIn{
            tryLogin()
        }
    }
    
    @IBAction func onSettingButtonClicked(sender: AnyObject){
        activeViewController = settingsViewController
        settingsButton.alpha = 1
        hypeButton.alpha = 0.7
        gridButton.alpha = 0.7
    }
    @IBAction func onHypeButtonClicked(sender: AnyObject){
        activeViewController = mainViewController
        settingsButton.alpha = 0.7
        hypeButton.alpha = 1
        gridButton.alpha = 0.7
    }
    @IBAction func onGridButtonClicked(sender: AnyObject){
//        activeViewController = gridViewController
        settingsButton.alpha = 0.7
        hypeButton.alpha = 0.7
        gridButton.alpha = 1
    }
    
    private func tryLogin() {
        let firebaseRef = Firebase(url: "https://enas400hype.firebaseio.com/")
        
        if let uN = userName, pW = password{
            firebaseRef.authUser(uN, password: pW, withCompletionBlock:
                { (error, authData) -> Void in
                    if error != nil{
                        print(error)
                        self.isLoggedIn = false
                    } else {
                        self.userUID = authData.uid
                        self.isLoggedIn = true
                    }
            })
            
        } else {
            isLoggedIn = false
        }
    }
    
    @IBAction func unwindFromLogInSegue(segue: UIStoryboardSegue){
        
    }
    
    func onSignOut() {
        isLoggedIn = false
    }
    
}
