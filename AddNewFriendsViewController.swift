//
//  AddNewFreindsViewController.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-07-10.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AddNewFriendsViewController: UIViewController {

    var delegate : ParentDelegateUpdate?
    
    //MARK: -OUTLETS AND ACTIONS
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBAction func btncCloseTapped(_ sender: UIButton) {
       UsefullFunctions.removeAnimate(vc: self)
        delegate?.parentViewUpdate()
        self.view.removeFromSuperview()
    }
    
    @IBAction func btnAddFriendTapped(_ sender: UIButton) {
        handleAddFriend()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
       UsefullFunctions.showAnimate(vc: self)
       self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }

    
    //MARK: -ADD FRIEND
    func handleAddFriend() {
        
        //query user by email
        let ref = Database.database().reference().child("users")
        let email = txtEmail.text
        let uid = Auth.auth().currentUser?.uid
        
        //query in database by email
        ref.queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.value, with: { (snapshot) in
            if snapshot.exists(){
                
               //access user key in snapshot
                    if let dictionary = snapshot.value as? [String:AnyObject]{
                        for (id,_) in dictionary{
                           
                            //save new friend in database
                            let friendRef = Database.database().reference().child("users").child(uid!).child("friends").child(id)
                            friendRef.setValue(email)
                            
                        }
                    }
                    
            }else{
                UsefullFunctions.showAlert(text: "The email is not existed!", title: "Not Found", vc: self)
            }
        }, withCancel: nil)
    }
   
   

}
