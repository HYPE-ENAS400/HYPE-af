//
//  ImageStore.swift
//  Hype-2
//
//  Created by max payson on 4/5/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

import UIKit
import MediaPlayer
import AWSMobileHubHelper

class ImageStore {
    
    private var contents: [AWSContent]?
    private var prefix: String!
    private var marker: String?
    private var didLoadAllContents: Bool!
    private var delegate: ImageStoreDelegate
    
    private var manager: AWSContentManager!
    
    init(delegate: ImageStoreDelegate, awsManager: AWSContentManager) {
        self.delegate = delegate
        manager = awsManager
    }
    
    func initializeCardsFromAWS(){
        didLoadAllContents = false
        loadMoreContents()
    }
    
    func getNumAvailCards() -> Int{
        if let c = contents{
            return c.count
        } else {
            return 0
        }
    }
    
    func getContentAtIndex(index: Int) -> AWSContent? {
        if let currentContents = contents {
            return currentContents[index]
        } else {
            return nil
        }
    }
    
    func getContentKeyAtIndex(index: Int) -> String?{
        if let currentContents = contents {
            return currentContents[index].key
        } else {
            return nil
        }
    }
    
    func getContentImageAtCardIndex(index: Int) -> UIImage? {
        if let currentContents = contents {
            return UIImage(data: currentContents[index].cachedData)
        } else {
            return nil
        }
    }
    
    func downloadContentAtCardIndex(index: Int) {
        if let currentContents = contents {
            downloadContent(currentContents[index], pinOnCompletion: false, index: index)
        }
    }
    
    func pushImageKeyAtCardIndex(index: Int, fbRef: Firebase){
        if let currentContents = contents {
            fbRef.childByAutoId().setValue(currentContents[index].key)
        }
    }
    
    func addContentByKey(key: String, shouldDownload: Bool){
        print("adding key: \(key)")
        if (contents?.append(manager.contentWithKey(key)) == nil){
            contents = [manager.contentWithKey(key)]
        }
        if shouldDownload{
            downloadContentAtCardIndex(contents!.count - 1)
        }
        
    }
    
    func clearCacheAtCardIndex(index: Int) {
        contents?[index].removeLocal()
    }
    
    //load available items from database, when all are loaded begin downloading them
    private func loadMoreContents() {
        manager.listAvailableContentsWithPrefix(prefix, marker: marker, completionHandler: {[weak self](contents: [AWSContent]?, nextMarker: String?, error: NSError?) -> Void in
            guard let strongSelf = self else { return }
            if let error = error {
                print("Failed to load the list of contents. \(error)")
            }
            if let contents = contents where contents.count > 0 {
                for c in contents{
                    if (strongSelf.contents?.append(c) == nil) {
                        strongSelf.contents = [c]
                    }
                    strongSelf.downloadContentAtCardIndex(strongSelf.contents!.count-1)
                    
                }
                
                if let nextMarker = nextMarker where !nextMarker.isEmpty{
                    strongSelf.didLoadAllContents = false
                } else {
                    strongSelf.didLoadAllContents = true
                }

            }
            })
    }
    
    //run through available items from database and download them all
    private func downloadCards(){
        if let downloadContents = contents {
            for (index, content) in downloadContents.enumerate(){
                downloadContent(content, pinOnCompletion: false, index: index)
            }
        }
        
    }
    
    //download a given item, reload the cards each time a new item is downloaded
    private func downloadContent(content: AWSContent, pinOnCompletion: Bool, index: Int) {
        if !content.cached{
            
        content.downloadWithDownloadType( AWSContentDownloadType.IfNotCached, pinOnCompletion: pinOnCompletion, progressBlock: {(content: AWSContent?, progress: NSProgress?) -> Void in
            // Handle progress feedback
            }, completionHandler: {(content: AWSContent?, data: NSData?, error: NSError?) -> Void in
                if let error = error {
                    print("Failed to download a content from a server.) + \(error)")
                    return
                } else {
                    self.delegate.newCardImageLoaded(index)
                }
            
        })
        } else {
            self.delegate.newCardImageLoaded(index)
        }
    }
    
}

//Delegate protocol so that can alter cards once downloaded
protocol ImageStoreDelegate {
    func newCardImageLoaded(cardIndex: Int)
}