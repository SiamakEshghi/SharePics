//
//  UIImageViewExtension.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-10-05.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import Foundation
import SVProgressHUD



//MARK:ImageView Extension


let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    // Download image and save in cach and  display in imageView,
    //for next didload fetch from cash
    public func imageFromUrl(urlString: String)  {
       if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = cachedImage
            SVProgressHUD.dismiss()
            
        }else{
           if let url = NSURL(string: urlString){
                    URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, response, error) in
                        if error != nil {
                            print(error!.localizedDescription)
                            DispatchQueue.main.async {
                                SVProgressHUD.dismiss()
                                return
                            }
                            
                        }
          if let downloadedImage = UIImage(data: data!){
          DispatchQueue.main.async{
                   self.image = downloadedImage
                   imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
            
                   SVProgressHUD.dismiss()
                            }
                        }
                        
                    }).resume()
                }
        }
        
    }
    
    //set image in circle
    func setRounded(radius: CGFloat) {
        let radius = radius
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    
}


