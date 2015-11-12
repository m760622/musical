//
//  PlayerViewController.swift
//  Musical
//
//  Created by Sebastian on 10/24/15.
//  Copyright © 2015 Sebastian. All rights reserved.
//

import UIKit
import LNPopupController
import XCDYouTubeKit
import AVKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    var videoTitle: String!
    var channelTitle: String!
    var videoId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for backround audio
        try! AVAudioSession.sharedInstance().setActive(true)
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        
        popupItem.title = videoTitle
        popupItem.subtitle = channelTitle
        
        XCDYouTubeClient.defaultClient().getVideoWithIdentifier(videoId) { (video, error) -> Void in
            
            let url = video!.streamURLs[18] as! NSURL
            
            var items = [AVPlayerItem]()
            
            items.append(AVPlayerItem(URL: url))

            player = AVQueuePlayer(items: items)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.view.bounds
            self.view.layer.addSublayer(playerLayer)
            player.play()
            
            //mayb thre a shorter way to doewnload thumb, alas ..
            let tempImageView = UIImageView()
            
            tempImageView.kf_setImageWithURL(video!.largeThumbnailURL ?? video!.mediumThumbnailURL!, placeholderImage: nil, optionsInfo: .None, completionHandler: { (image, error, cacheType, imageURL) -> () in

                let itemArtwork = MPMediaItemArtwork(image: tempImageView.image!)
                
                let songInfo: Dictionary = [
                    MPMediaItemPropertyTitle: self.videoTitle,
                    MPMediaItemPropertyArtist: self.channelTitle,
                    MPMediaItemPropertyArtwork: itemArtwork,
                    MPMediaItemPropertyPlaybackDuration : CMTimeGetSeconds(player.currentItem!.asset.duration)
                ]
                
                MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = songInfo
            })
            
            
        }
        
    }
    

    
    deinit {
        UIApplication.sharedApplication().endReceivingRemoteControlEvents()
    }

}
