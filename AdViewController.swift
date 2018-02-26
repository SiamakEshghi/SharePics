//
//  AdViewController.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2018-02-25.
//  Copyright © 2018 Joopooli. All rights reserved.
//

import UIKit
import GoogleMobileAds
class AdViewController: UIViewController, GADBannerViewDelegate {

    
    var adMobBannerView = GADBannerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       initAdMobBanner()
    }

    // MARK: -  ADMOB BANNER
    func initAdMobBanner() {
      
        if UIDevice.current.userInterfaceIdiom == .phone {
            // iPhone
            
           
            adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 320 , height: 50))
            adMobBannerView.frame = CGRect(x: 0, y: view.frame.size.height, width: 320, height: 50)
            
        } else  {
            // iPad
            adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 468, height: 60))
            adMobBannerView.frame = CGRect(x: 0, y: view.frame.size.height, width: 468, height: 60)
        }
        
        adMobBannerView.adUnitID = NSLocalizedString(Constants.BANNER_ADS_UNIT_ID, comment: "")
        adMobBannerView.rootViewController = self
        adMobBannerView.delegate = self
        view.addSubview(adMobBannerView)
        
        let request = GADRequest()
        adMobBannerView.load(request)
    }
    

  // Hide the banner
    func hideBanner(_ banner: UIView) {
        UIView.beginAnimations("hideBanner", context: nil)
        banner.frame = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2, y: view.frame.size.height - banner.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
        UIView.commitAnimations()
        banner.isHidden = true
    }
    
    // Show the banner
    func showBanner(_ banner: UIView) {
          UIView.beginAnimations("showBanner", context: nil)

        if self is AddNewFriendsViewController{
            banner.frame = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2, y: view.frame.size.height - banner.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
        }else{

             //If the view has tab bar like EventsViewController or FriendsViewController show adbar 50 cm higher
            banner.frame = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2, y: view.frame.size.height - banner.frame.size.height - 50, width: banner.frame.size.width, height: banner.frame.size.height)
        }

        UIView.commitAnimations()
        banner.isHidden = false
    }
    
    // AdMob banner available
    func adViewDidReceiveAd(_ view: GADBannerView!) {
        
        showBanner(adMobBannerView)
    }
    
    // NO AdMob banner available
    func adView(_ view: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        hideBanner(adMobBannerView)
    }
    

}
