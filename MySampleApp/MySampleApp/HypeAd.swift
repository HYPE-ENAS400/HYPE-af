//
//  HypeAd.swift
//  Hype-2
//
//  Created by max payson on 4/19/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

import UIKit
import AWSMobileHubHelper

enum DownloadResult {
    case Downloaded
    case Error
    case AlreadyDownloaded
}

class HypeAd: Equatable{
    private var content: AWSContent!
    private var isDownloaded: Bool = false
    private var isFromFriend: Bool!
    
    init(content: AWSContent, isFromFriend: Bool){
        self.content = content
        self.isFromFriend = isFromFriend
    }
    
    func getContent() -> AWSContent{
        return content
    }
    func setContent(newContent: AWSContent){
        content = newContent
    }
    
    func getIsDownloaded() -> Bool{
        return isDownloaded
    }
    
    func setIsDownloaded(didDownload: Bool){
        isDownloaded = didDownload
    }
    
    func getIsFromFriend() -> Bool{
        return isFromFriend
    }
    func setIsFromFriend(fromFriend: Bool){
        isFromFriend = fromFriend
    }
    
    func  downloadContent(completion: (result: DownloadResult) -> Void){
        if !content.cached{
            content.downloadWithDownloadType( .Always, pinOnCompletion: false, progressBlock: {(content: AWSContent?, progress: NSProgress?) -> Void in
                // Handle progress feedback
                }, completionHandler: {(content: AWSContent?, data: NSData?, error: NSError?) -> Void in
                    if let error = error {
                        print("Error with key: \(content?.key)")
                        print("Error domain: \(error.domain)\n")
//                        print("Failed to download a content from a server.) + \(error)")
                        completion(result: .Error)
                    } else {
                        completion(result: .Downloaded)
                        self.isDownloaded = true
                    }
                    
            })
        } else {
            completion(result: .AlreadyDownloaded)
        }
    }
    
    func deleteDownload(){
        content.removeLocal()
        isDownloaded = false
    }
    
}

func == (lhs: HypeAd, rhs: HypeAd) -> Bool {
    if lhs.getContent().key == rhs.getContent().key {
        lhs.isFromFriend = true
        rhs.isFromFriend = true
        return true
    } else {
        return false
    }
}
