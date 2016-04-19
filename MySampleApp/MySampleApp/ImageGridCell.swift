//
//  ImageGridCell.swift
//  Hype-2
//
//  Created by max payson on 4/18/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

import UIKit

class ImageGridCell: UICollectionViewCell{
    
    @IBOutlet var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setRandomView(){
//        let newView = UIView(frame: self.frame)
        let colorArray = [UIColor.blueColor(), UIColor.redColor(), UIColor.greenColor()]
        let index = arc4random_uniform(3)
        self.backgroundColor = colorArray[Int(index)]
//        newView.backgroundColor = colorArray[Int(index)]
//        self.addSubview(newView)
    }
    
    func updateWithImage(image: UIImage?) {
        if let imageToDisplay = image {
//            spinner.stopAnimating()

//            let superFrame = self.frame
//            let newContainerView = UIView(frame: superFrame)
//            newContainerView.layer.cornerRadius = 20
            
            view.layer.cornerRadius = 5
            view.backgroundColor = UIColor.whiteColor()
            view.layer.shadowOpacity = 0.7
            view.layer.shadowOffset = CGSizeZero
            view.layer.shadowRadius = 2
            
            let childFrame = CGRectInset(view.bounds, 2, 2)
            let newChildView = UIImageView(frame: childFrame)
            newChildView.image = resizeImage(imageToDisplay, newScale: 0.2)
            newChildView.layer.masksToBounds = true
            newChildView.layer.cornerRadius = 5
            
            view.addSubview(newChildView)
            
//            self.addSubview(newContainerView)
            
        }
        else {
//            spinner.startAnimating()
            
        }
    }
}
