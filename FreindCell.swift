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
    var friendId: String?{
        didSet{
           
           self.friendImage.setRounded(radius: (self.friendImage.frame.width) / 2)
           setCellInfo()
           fetchProfileImageUrl(friendId: friendId!) { (url) in
                if let profileImageUrl = url {
                    self.friendImage.imageFromUrl(urlString: profileImageUrl)
                }
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func  setCellInfo(){
         let refFriend = Database.database().reference().child("users").child(friendId!)
        DispatchQueue.global(qos: .userInitiated).async {
            refFriend.observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    let name = dictionary["name"] as! String
                    DispatchQueue.main.async {
                        self.labelFriendName.text = name
                        }
                }
            }, withCancel: nil)
        }
    }
    
   

}
