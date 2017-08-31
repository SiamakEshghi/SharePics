//
//  VideoManager.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-08-31.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import UIKit
import AVFoundation


extension UIViewController {
    
    
    
    
    //Mark: -VIDEO IN BACKGROUN
     func setupVideoBackground()  {
        let URL = Bundle.main.url(forResource: "bluefire", withExtension: "mp4")
        
        Player = AVPlayer.init(url:URL!)
        PlayerLayer = AVPlayerLayer(player: Player)
        PlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        PlayerLayer.frame = view.layer.frame
        
        Player.actionAtItemEnd = AVPlayerActionAtItemEnd.none
        Player.play()
        
        view.layer.insertSublayer(PlayerLayer, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemReachEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: Player.currentItem)
    }
    
    func playerItemReachEnd(notification:NSNotification) {
        Player.seek(to: kCMTimeZero)
    }
}
