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

        
    private var downloadContentsIndices: [Int]
        
    private var contents: [AWSContent]?
    private var prefix: String!
    private var marker: String?
    private var didLoadAllContents: Bool!
    private var delegate: ImageStoreDelegate
    
    private var manager: AWSContentManager!
    
    init(delegate: ImageStoreDelegate) {
        self.delegate = delegate
        downloadContentsIndices = [Int]()
        manager = AWSContentManager.defaultContentManager()
        didLoadAllContents = false
        loadMoreContents()
    }
    
    func getNumAvailCards() -> Int {
        return downloadContentsIndices.count
    }
    
    func getContentAtCardIndex(index: Int) -> AWSContent? {
        if let currentContents = contents {
            let contentIndex = downloadContentsIndices[Int(index)]
            return currentContents[contentIndex]
        } else {
            return nil
        }
    }
    
    func getContentImageAtCardIndex(index: Int) -> UIImage? {
        if let content = getContentAtCardIndex(index) {
            return UIImage(data: content.cachedData)
        } else {
            return nil
        }
    }
    
    func pushImageURLAtCardIndex(index: Int, fbRef: Firebase){
        if let content = getContentAtCardIndex(index) {
            content.getRemoteFileURLWithCompletionHandler({ (url, error) in
                if let er = error {
                    print(er)
                }
                if let u = url {
                    fbRef.childByAutoId().setValue(String(u))
                }
            })
        }
    }
    
    func clearCacheAtCardIndex(index: Int) {
        let contentIndex = downloadContentsIndices[index]
        contents?[contentIndex].removeLocal()
//        downloadContentsIndices.removeAtIndex(index)
    }
    
    //load available items from database, when all are loaded begin downloading them
    private func loadMoreContents() {
        manager.listAvailableContentsWithPrefix(prefix, marker: marker, completionHandler: {[weak self](contents: [AWSContent]?, nextMarker: String?, error: NSError?) -> Void in
            guard let strongSelf = self else { return }
            if let error = error {
                print("Failed to load the list of contents. \(error)")
            }
            if let contents = contents where contents.count > 0 {
                strongSelf.contents = contents
                if let nextMarker = nextMarker where !nextMarker.isEmpty{
                    strongSelf.didLoadAllContents = false
                } else {
                    strongSelf.didLoadAllContents = true
                }
                strongSelf.downloadCards()
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
        content.downloadWithDownloadType( .IfNewerExists, pinOnCompletion: pinOnCompletion, progressBlock: {(content: AWSContent?, progress: NSProgress?) -> Void in
            // Handle progress feedback
            }, completionHandler: {(content: AWSContent?, data: NSData?, error: NSError?) -> Void in
                if let error = error {
                    print("Failed to download a content from a server.) + \(error)")
                    return
                }
                self.downloadContentsIndices.append(index)
                if self.getNumAvailCards() == 1{
                    self.delegate.reloadData()
                }
                
        })
    }
    
    
}

//Delegate protocol so that can alter cards once downloaded
protocol ImageStoreDelegate {
    func reloadData()
    func resetCurrentCardNumber()
}
