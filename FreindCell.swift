//
//  FreindTableViewCell.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-07-12.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SVProgressHUD

class FreindTableViewCell: UITableViewCell {

   
    //MARK: -OUTLETS
    
    @IBOutlet weak var friendImage: UIImageView!
    
    
    @IBOutlet weak var labelFriendName: UILabel!
    
    //MARK: -PROPERTIES
    var friend: User?{
        didSet{
           self.friendImage.setRounded(radius: (self.friendImage.frame.width) / 2)
            labelFriendName.text = friend?.name!
           friendImage.imageFromUrl(urlString: (friend?.profileImageUrl)!)
           }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        }

    }
