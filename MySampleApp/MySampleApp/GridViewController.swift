//
//  GridViewController.swift
//  Hype-2
//
//  Created by max payson on 4/18/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

import UIKit
import AWSMobileHubHelper
import SafariServices

class GridViewController: UICollectionViewController, HypeAdStoreDelegate{
    
    var adStore: HypeAdStore!
    var firebaseRef: Firebase!
    var userUID: String!{
        didSet{
            let tempRef = Firebase(url: "https://enas400hype.firebaseio.com/")
            firebaseRef = tempRef.childByAppendingPath("users").childByAppendingPath(userUID).childByAppendingPath("cardsLiked")
        }
    }
    var manager: AWSContentManager!
    
    func initImageStore(){
        
        adStore = HypeAdStore(delegate: self, awsManager: manager)
        
        firebaseRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let contentKey = snapshot.value as? String
            if let key = contentKey{
                self.adStore.addContentByKey(key, shouldDownload: false)
//                self.collectionView?.reloadData()
            }
        })
        
    }
    
    override func viewDidLoad() {
        self.collectionView?.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath){
        print("indexpath.row: \(indexPath.row)")
        adStore.downloadContentAtCardIndex(indexPath.row)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ImageGridCell
//        cell.highlightCell()
        
        if let url = NSURL(string: "http://www.githyped.com/"){
            if #available(iOS 9.0, *) {
                let vc = SFSafariViewController(URL: url, entersReaderIfAvailable: false)
                presentViewController(vc, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
            }
            
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return adStore.getNumAvailCards()
//        return 10
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = "UICollectionViewCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! ImageGridCell
        
        let image = adStore.getContentImageAtCardIndex(indexPath.row)
        cell.updateWithImage(image)
        
        return cell
    }
    
    func newCardImageLoaded(cardIndex: Int) {
//        self.collectionView?.reloadData()
        let photoIndexPath = NSIndexPath(forRow: cardIndex, inSection:0)
        print("new Card Image Loaded \(cardIndex)")
//        let collectionView = self.collectionView
//        let cell = collectionView?.cellForItemAtIndexPath(photoIndexPath)
        if let cell = self.collectionView?.cellForItemAtIndexPath(photoIndexPath) as? ImageGridCell {
            let image = adStore.getContentImageAtCardIndex(cardIndex)
            cell.updateWithImage(image)
        }
    }
    
}
