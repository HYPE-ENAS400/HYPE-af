//
//  LoginViewController.swift
//  Hype-2
//
//  Created by max payson on 4/8/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet var userNameTextEdit: UITextField!
    @IBOutlet var passwordTextEdit: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var logInButton: UIButton!
    @IBOutlet var errorLabel: UILabel!

    var userUID: String!
    var userName: String!
    var password: String!
    
    var firebaseRef: Firebase!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseRef = Firebase(url: "https://enas400hype.firebaseio.com/")
    }
    
    @IBAction func dismissKeyboard(sender: AnyObject){
        passwordTextEdit.resignFirstResponder()
        userNameTextEdit.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func logInClicked(sender: AnyObject){
        
        logInButton.userInteractionEnabled = false
        signUpButton.userInteractionEnabled = false
        
        userName = userNameTextEdit.text
        password = passwordTextEdit.text
        
        firebaseRef.authUser(userNameTextEdit.text, password: passwordTextEdit.text, withCompletionBlock: { (error, authData) -> Void in
            if error != nil{
                
                self.logInButton.userInteractionEnabled = true
                self.signUpButton.userInteractionEnabled = true
                
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
                
                let keychainWrapper = KeychainWrapper.standardKeychainAccess()
                keychainWrapper.setString(self.userName, forKey: Constants.USERKEY)
                keychainWrapper.setString(self.password, forKey: Constants.PASSKEY)
                
                self.userUID = authData.uid
                
                Firebase(url: "https://enas400hype.firebaseio.com/").childByAppendingPath("users").childByAppendingPath(self.userUID).childByAppendingPath("username").setValue(self.userName)
                
                print("Successfully logged in user account with uid: \(self.userUID)")
                self.performSegueWithIdentifier("unwindFromLogInSegue", sender: nil)
            }
        })
    
    }
    
    @IBAction func signUpClicked(sender: AnyObject){
        //TODO Invalidate button
        
        logInButton.userInteractionEnabled = false
        signUpButton.userInteractionEnabled = false
        
        userName = userNameTextEdit.text
        password = passwordTextEdit.text
        
        firebaseRef.createUser(userName, password: password,
            withValueCompletionBlock: { (error, result) -> Void in
            if error != nil{
                
                self.logInButton.userInteractionEnabled = true
                self.signUpButton.userInteractionEnabled = true
                
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
                //TODO fix the optional?
                
                let keychainWrapper = KeychainWrapper.standardKeychainAccess()
                keychainWrapper.setString(self.userName, forKey: Constants.USERKEY)
                keychainWrapper.setString(self.password, forKey: Constants.PASSKEY)

                self.userUID = (result["uid"] as? String)!
                
                Firebase(url: "https://enas400hype.firebaseio.com/").childByAppendingPath("users").childByAppendingPath(self.userUID).childByAppendingPath("username").setValue(self.userName)
                
                print("Successfully created user account with uid: \(self.userUID)")
                self.performSegueWithIdentifier("unwindFromLogInSegue", sender: nil)
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "onLoggedInSegue" {
//            let mainViewController = segue.destinationViewController as! MainViewController
//            let imageStore = ImageStore(delegate: mainViewController)
//            mainViewController.imageStore = imageStore
//            mainViewController.userUID = userUID
//            
//        }
        if segue.identifier == "unwindFromLogInSegue" {
            let navViewController = segue.destinationViewController as! HypeNavViewController
            navViewController.userUID = userUID
            navViewController.userName = userName
            navViewController.password = password
            navViewController.isLoggedIn = true

        }
    }
//
}