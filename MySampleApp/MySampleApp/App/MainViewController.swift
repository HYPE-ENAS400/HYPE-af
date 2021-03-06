//
//  MainViewController.swift
//  MySampleApp
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.1
//

import UIKit
import AWSMobileHubHelper
import Firebase

class MainViewController: UIViewController, ImageStoreDelegate {
    
    let ADSPERCONTENT = 2
    
    var kolodaView: KolodaView!
    var imageStore: ImageStore!
    
    @IBOutlet var contentCountLabel: UILabel!
    
    //TODO change this
    var adCount: Int = 0
    var contentCount: Int = 0
    
    var userUID: String!
    
    var userFBRef: Firebase!
    
    //Create subview for kolodaView, add Koloda view, and pass protocols
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewRect = CGRectMake(24,90,270, 300)
        kolodaView = KolodaView(frame: viewRect)
        kolodaView.dataSource = self
        kolodaView.delegate = self
        self.view.addSubview(kolodaView)
        
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        
        let tempRef = Firebase(url: "https://enas400hype.firebaseio.com/")
        userFBRef = tempRef.childByAppendingPath("users").childByAppendingPath(userUID)
        
        userFBRef.observeEventType(.Value, withBlock: { (snapshot) in
            let data = snapshot.value["contentCount"] as? Int
            if let t = data{
                self.contentCount = t
                self.contentCountLabel.text = "\(self.contentCount)"
            }
            //add error handler?

        })
        
        
    }
    
    
    func checkAdCount(){
        if(adCount % ADSPERCONTENT) == 0 {
            contentCount++
            let store = ["contentCount" : contentCount]
            userFBRef.setValue(store)
            adCount = 0
            
        }
    }
    
    
    func reloadData(){
        kolodaView.reloadData()
    }
    func resetCurrentCardNumber(){
        kolodaView.resetCurrentCardNumber()
    }
    


}

// KolodaView protocol that determines what cards to show
extension MainViewController: KolodaViewDataSource{
    func koloda(kolodaNumberOfCards koloda:KolodaView) -> UInt {
        let test = UInt(imageStore.getNumAvailCards())
        return test
    }
    
    //Return a new view (card) to show from ImageStore
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        if let image = imageStore.getContentImageAtCardIndex(Int(index)) {
            let newView = UIImageView(image: image)
            return newView
        } else {
            let newView = UIView()
            let colorArray = [UIColor.blueColor(), UIColor.redColor(), UIColor.greenColor()]
            let index = arc4random_uniform(3)
            newView.backgroundColor = colorArray[Int(index)]
            return newView
        }
    }
        
}

// Own implemenation upon swiping so can clear image cache of given card
extension MainViewController: KolodaViewDelegate {
    func koloda(koloda: KolodaView, didSwipedCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
        imageStore.clearCacheAtCardIndex(Int(index))
        adCount++
        checkAdCount()
    }
}





