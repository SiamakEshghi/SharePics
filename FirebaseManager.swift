//
//  UsefullFunctions.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-07-10.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SVProgressHUD



//MARK: -PUBLIC PROPERTIES
public var friendsId = [String]()
   

//MARK: -FETCH FRIENDS FROM DATABASE
public func fetchFriends(completionHandler:@escaping ([String]) -> Void) {
    
    var ids = [String]()
    
    let uid = Auth.auth().currentUser?.uid
    let refFriendList = Database.database().reference().child("users").child(uid!).child("friends")
    
    
    DispatchQueue.global(qos: .userInitiated).async {
        refFriendList.observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                
                for (key, _ ) in dictionary {
                    ids.append(key)
                }
            }
           
            if ids.count > 0 {
                DispatchQueue.main.async {
                     completionHandler(ids)
                }
            }else{
                SVProgressHUD.dismiss()
            }
         }, withCancel: nil)
    }
}



//MARK: -FETCH EVENTS ID FROM DATABASE
func fetchEvents(id:String , completionHandler :@escaping ([String]) -> Void)  {
    
    var ids = [String]()
   
    let ref = Database.database().reference().child("user-events").child(id)
    
    
    DispatchQueue.global(qos: .userInitiated).async {
        ref.observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                
                for (key, _ ) in dictionary {
                    ids.append(key)
                }
            }
            if ids.count > 0 {
                DispatchQueue.main.async{
                    completionHandler(ids)
                }
                
            }else{
                SVProgressHUD.dismiss()
            }
        }, withCancel: nil)
    }
    
    
}

//MARK: Register New User Into firebase Database
func saveNewUserInFirebase(profileImageUrl:String,uid : String,name: String,email:String,completionHandler :@escaping (Bool) -> Void) -> Void {
    let values = ["name":name,"email":email,"profileImageUrl":profileImageUrl]
    let ref = Database.database().reference()
    
    let userRef = ref.child("users").child(uid)
    userRef.updateChildValues(values) { (error, ref) in
        if error != nil{
            completionHandler(true)
            return
        }
        completionHandler(false)
    }
    
}


//MARK: -Save Profile Image
func saveProfileImage(profileImage:UIImage,completionHandler : @escaping (String) -> Void)  {
    
    //create a unic name for image
    let imageName = NSUUID().uuidString
    let storgaeRef = Storage.storage().reference().child("Profile_Images").child("\(imageName).jpg")
    
    //Save image in storage
    if  let uploadedData = UIImageJPEGRepresentation(profileImage, 0.1){
        storgaeRef.putData(uploadedData, metadata: nil){ (metadata, error) in
            if error != nil {
                return
            }
            if let profileImageUrl = metadata?.downloadURL()?.absoluteString{
                completionHandler(profileImageUrl)
            }
        }
    }
}


