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
    @IBOutlet var errorLabel: UILabel!

    var userUID: String!
    
    var firebaseRef: Firebase!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseRef = Firebase(url: "https://enas400hype.firebaseio.com/")
    }
    
    @IBAction func logInClicked(sender: AnyObject){
        firebaseRef.authUser(userNameTextEdit.text, password: passwordTextEdit.text, withCompletionBlock: { (error, authData) -> Void in
            if error != nil{
                if let errorCode = FAuthenticationError(rawValue: error.code){
                    self.errorLabel.hidden = false
                    switch (errorCode) {
                    case .UserDoesNotExist:
                        self.errorLabel.text = "Sorry, we could not find this user"
                    case .InvalidEmail:
                        self.errorLabel.text = "Please enter a valid e-mail"
                    case .InvalidPassword:
                        self.errorLabel.text = "Password does not match user account"
                    default:
                        self.errorLabel.text = "Sorry, we could not log you in"
                    }
                }
                
            } else {
                self.userUID = authData.uid
                print("Successfully logged in user account with uid: \(self.userUID)")
                self.performSegueWithIdentifier("onLoggedInSegue", sender: nil)
            }
        })
    
    }
    
    @IBAction func signUpClicked(sender: AnyObject){
        firebaseRef.createUser(userNameTextEdit.text, password: passwordTextEdit.text,
            withValueCompletionBlock: { (error, result) -> Void in
            if error != nil{
                if let errorCode = FAuthenticationError(rawValue: error.code){
                    self.errorLabel.hidden = false
                    switch (errorCode) {
                    case .EmailTaken:
                        self.errorLabel.text = "An account already exists with this e-mail"
                    case .InvalidEmail:
                        self.errorLabel.text = "Please enter a valid e-mail"
                    case .InvalidPassword:
                        self.errorLabel.text = "Password does not match user account"
                    default:
                        self.errorLabel.text = "Sorry, we could not sign you up"
                    }
                }
            } else {
                //fix the optional?
                self.userUID = (result["uid"] as? String)!
                print("Successfully created user account with uid: \(self.userUID)")
                self.performSegueWithIdentifier("onLoggedInSegue", sender: nil)
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "onLoggedInSegue" {
            let mainViewController = segue.destinationViewController as! MainViewController
            let imageStore = ImageStore(delegate: mainViewController)
            mainViewController.imageStore = imageStore
            mainViewController.userUID = userUID
            
        }
    }
    
}