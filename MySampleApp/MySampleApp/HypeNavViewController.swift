//
//  HypeNavViewController.swift
//  Hype-2
//
//  Created by max payson on 4/13/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

import UIKit

//enum VCTransition {
//    case SettingsToMain
//    case SettingsToGrid
//    case MainToSettings
//    case MainToGrid
//    case GridToMain
//    case GridToSettings
//}

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
            gridViewController?.userUID = userUID
            settingsViewController?.uid = userUID
        }
    }
    
    var mainViewController: MainViewController?
    var settingsViewController: SettingsViewController?
    var gridViewController: GridViewController?
    
    @IBOutlet var hypeBarView: UIView!
    
    @IBOutlet var containerView: UIView!
    
    var isLoggedIn: Bool = false {
        didSet{
            if isLoggedIn == true {
                hypeBarView.hidden = false
                mainViewController?.initImageStore()
                gridViewController?.initImageStore()
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
    
//    private var vcTransition: VCTransition!
    
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
//            isLoggedIn = false
            tryLogin()
        }
    }
    
    @IBAction func onSettingButtonClicked(sender: AnyObject){
//        if(activeViewController == gridViewController){
//            vcTransition = VCTransition.GridToSettings
//        } else if (activeViewController == mainViewController){
//            vcTransition = VCTransition.MainToSettings
//        }
        activeViewController = settingsViewController
        settingsButton.alpha = 1
        hypeButton.alpha = 0.7
        gridButton.alpha = 0.7
    }
    @IBAction func onHypeButtonClicked(sender: AnyObject){
//        if(activeViewController == gridViewController){
//            vcTransition = VCTransition.GridToMain
//        } else if (activeViewController == settingsViewController){
//            vcTransition = VCTransition.SettingsToMain
//        }
        activeViewController = mainViewController
        settingsButton.alpha = 0.7
        hypeButton.alpha = 1
        gridButton.alpha = 0.7
    }
    @IBAction func onGridButtonClicked(sender: AnyObject){
//        if(activeViewController == mainViewController){
//            vcTransition = VCTransition.MainToGrid
//        } else if (activeViewController == settingsViewController){
//            vcTransition = VCTransition.SettingsToGrid
//        }
        activeViewController = gridViewController
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
