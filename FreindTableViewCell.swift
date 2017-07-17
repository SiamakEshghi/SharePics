//
//  FreindTableViewCell.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-07-12.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseDatabase

class FreindTableViewCell: UITableViewCell {

   
    //MARK: -OUTLETS
    
    @IBOutlet weak var friendImage: UIImageView!
    
    
    @IBOutlet weak var labelFriendName: UILabel!
    
    //MARK: -PROPERTIES
    var friendId: String?{
        didSet{
            let refFriend = Database.database().reference().child("users").child(friendId!)
            refFriend.observe(.value, with: { (snapshot) in
                //create user list and add to users
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    let name = dictionary["name"] as! String
                    let profilImageUrl = dictionary["profileImageUrl"] as! String
                    
                   self.labelFriendName.text = name 
                    self.friendImage?.kf.setImage(with: URL(string: profilImageUrl))
                    }
                
            }, withCancel: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
