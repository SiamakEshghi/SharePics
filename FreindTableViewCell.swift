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
            let refFriend = Database.database().reference().child("users").child(friendId!)
            
            DispatchQueue.global(qos: .userInitiated).async {
                refFriend.observe(.value, with: { (snapshot) in
                    //create user list and add to users
                    if let dictionary = snapshot.value as? [String:AnyObject]{
                        let name = dictionary["name"] as! String
                        let profilImageUrl = dictionary["profileImageUrl"] as! String
                        
                        DispatchQueue.main.async {
                            self.labelFriendName.text = name
                            self.friendImage?.imageFromUrl(urlString: profilImageUrl)
                            SVProgressHUD.dismiss()
                        }
                        
                    }
                    
                }, withCancel: nil)
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
