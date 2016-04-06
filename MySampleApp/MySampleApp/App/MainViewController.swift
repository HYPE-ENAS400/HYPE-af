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

class MainViewController: UIViewController, ImageStoreDelegate {
    
    var kolodaView: KolodaView!
    var imageStore: ImageStore!

    override func viewDidLoad() {
        super.viewDidLoad()
        let viewRect = CGRectMake(24,90,270, 300)
        kolodaView = KolodaView(frame: viewRect)
        kolodaView.dataSource = self
        kolodaView.delegate = self
        self.view.addSubview(kolodaView)
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        
    }
    
    func reloadData(){
        kolodaView.reloadData()
    }
    func resetCurrentCardNumber(){
        kolodaView.resetCurrentCardNumber()
    }
    


}

extension MainViewController: KolodaViewDataSource{
    func koloda(kolodaNumberOfCards koloda:KolodaView) -> UInt {
        let test = UInt(imageStore.getNumAvailCards())
        return test
    }
    
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

extension MainViewController: KolodaViewDelegate {
    func koloda(koloda: KolodaView, didSwipedCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
        imageStore.clearCacheAtCardIndex(Int(index))
    }
}





