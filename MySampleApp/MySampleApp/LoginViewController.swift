//
//  LoginViewController.swift
//  Hype-2
//
//  Created by max payson on 4/8/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController{

    @IBOutlet var userNameTextEdit: UITextField!
    @IBOutlet var passwordTextEdit: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var logInButton: UIButton!

    var userUID: String!
    
    var firebaseRef: Firebase!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseRef = Firebase(url: "https://enas400hype.firebaseio.com/")
    }
    
    @IBAction func logInClicked(sender: AnyObject){
        firebaseRef.authUser(userNameTextEdit.text, password: passwordTextEdit.text, withCompletionBlock: { (error, authData) -> Void in
            if error != nil{
                print(error)
            } else {
                self.userUID = authData.uid
                print("Successfully created user account with uid: \(self.userUID)")
                self.performSegueWithIdentifier("onLogInSegue", sender: nil)
            }
        })
    
    }
    
    @IBAction func signUpClicked(sender: AnyObject){
        firebaseRef.createUser(userNameTextEdit.text, password: passwordTextEdit.text,
            withValueCompletionBlock: { (error, result) -> Void in
            if error != nil{
                print(error)
            } else {
                //fix the optional?
                self.userUID = (result["uid"] as? String)!
                print("Successfully created user account with uid: \(self.userUID)")
                self.performSegueWithIdentifier("onLogInSegue", sender: nil)
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "onLogInSegue" {
            let mainViewController = segue.destinationViewController as! MainViewController
            mainViewController.userUID = userUID
        }
    }
    
}