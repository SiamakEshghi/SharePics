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

      
    //MARK: -OUTLETS AND ACTIONS
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBAction func btncCloseTapped(_ sender: UIButton) {
       removeAnimate(vc: self)
       
        self.view.removeFromSuperview()
    }
    
    @IBAction func btnAddFriendTapped(_ sender: UIButton) {
        perform(#selector(handleAddFriend), with: nil, afterDelay: 0)
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
       hideKeyboardWhenTappedAround()
       showAnimate(vc: self)
       self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
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
                        for (friendId,_) in dictionary{
                           
                            //save new friend in database
                            let friendRef = Database.database().reference().child("users").child(uid!).child("friends")
                            friendRef.updateChildValues([friendId:email!])
                            
                            showAlert(text: "New friend is added successfully!", title: "Success", vc: self)
                            self.txtEmail.text = ""
                        }
                    }
                    
            }else{
                showAlert(text: "The email is not existed!", title: "Not Found", vc: self)
            }
        }, withCancel: nil)
    }
   
   

}
