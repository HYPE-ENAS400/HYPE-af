//
//  GridViewController.swift
//  Hype-2
//
//  Created by max payson on 4/18/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

import UIKit
import AWSMobileHubHelper

class GridViewController: UICollectionViewController, ImageStoreDelegate{
    
    var imageStore: ImageStore!
    var firebaseRef: Firebase!
    var userUID: String!{
        didSet{
            let tempRef = Firebase(url: "https://enas400hype.firebaseio.com/")
            firebaseRef = tempRef.childByAppendingPath("users").childByAppendingPath(userUID).childByAppendingPath("cardsLiked")
        }
    }
    var manager: AWSContentManager!
    
    func initImageStore(){
        
        imageStore = ImageStore(delegate: self, awsManager: manager)
        
        firebaseRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let contentKey = snapshot.value as? String
            if let key = contentKey{
                self.imageStore.addContentByKey(key, shouldDownload: false)
//                self.collectionView?.reloadData()
            }
        })
        
    }
    
    override func viewDidLoad() {
        self.collectionView?.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath){
        print("indexpath.row: \(indexPath.row)")
        imageStore.downloadContentAtCardIndex(indexPath.row)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageStore.getNumAvailCards()
//        return 10
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = "UICollectionViewCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! ImageGridCell
        
        let image = imageStore.getContentImageAtCardIndex(indexPath.row)
        cell.updateWithImage(image)
        
        return cell
    }
    
    func newCardImageLoaded(cardIndex: Int) {
//        self.collectionView?.reloadData()
        let photoIndexPath = NSIndexPath(forRow: cardIndex, inSection:0)
        print(photoIndexPath)
        let collectionView = self.collectionView
        print(collectionView)
        let cell = collectionView?.cellForItemAtIndexPath(photoIndexPath)
        print(cell)
        if let cell = self.collectionView?.cellForItemAtIndexPath(photoIndexPath) as? ImageGridCell {
            let image = imageStore.getContentImageAtCardIndex(cardIndex)
            cell.updateWithImage(image)
        }
    }
    
}
