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



//MARK: -FETCH FRIENDS FROM DATABASE
public func fetchFriends(completionHandler:@escaping ([String]?) -> Void) {
    
    var ids = [String]()
    
    let uid = Auth.auth().currentUser?.uid
    let refFriendList = Database.database().reference().child("users").child(uid!).child("friends")
    
    DispatchQueue.global(qos: .userInitiated).async {
        refFriendList.observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                
                for (key, _ ) in dictionary {
                    ids.append(key)
                }
                completionHandler(ids)
            }else{
                completionHandler(nil)
            }
         }, withCancel: nil)
    }
}



//MARK: -FETCH EVENTS ID FROM DATABASE
func fetchEvents( completionHandler :@escaping ([Event]?) -> Void)  {
    
    let uid = Auth.auth().currentUser?.uid
    var events = [Event]()
   
    let ref = Database.database().reference().child("user-events").child(uid!)
    
    
    DispatchQueue.global(qos: .userInitiated).async {
        ref.observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                
                for (key, _ ) in dictionary {
                    let eventRef = Database.database().reference().child("events").child(key)
                    eventRef.observe(.value, with: { (snapshot) in
                        if let dictionary = snapshot.value as? [String:AnyObject]{
                            let name = dictionary["name"] as? String
                            let interval = dictionary["interval"] as? TimeInterval ?? 00
                            let event = Event()
                            event.id = key
                            event.name = name
                            event.date = NSDate(timeIntervalSince1970: interval) as Date
                            
                            if !events.contains(event){
                               events.append(event)
                            }
                            
                        }
                        
                        let when = DispatchTime.now() + 0.1
                        DispatchQueue.main.asyncAfter(deadline: when) {
                            completionHandler(events)
                        }
                        
                    })
                }
                
            }else{
                completionHandler(nil)
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
       // completionHandler(false)
    
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

//MARK: -Fetch Photoes Url

func fetchPhotoesUrl(eventId:String,imagesNumber:Int?,completionHandler: @escaping ([String]?) -> Void) {
    var counter = 0
    var photosUrls = [String]()
    let ref = Database.database().reference().child("event-photos").child(eventId)

  DispatchQueue.global(qos: .userInitiated).async {
        ref.observe(.childAdded, with: { (snapshot) in
            
            if imagesNumber != nil {
                 counter += 1
                if counter > imagesNumber!{
                    completionHandler(photosUrls)
                    return
                }
            }
            let photoName = snapshot.key
            let photoRef =  Database.database().reference().child("Photos").child(photoName)
            photoRef.observe(.value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String:AnyObject]{
                        let url = dictionary["URL"] as! String
                        
                        if !photosUrls.contains(url) {
                            photosUrls.append(url)
                        }
                        completionHandler(photosUrls)
                    }else{
                        completionHandler(nil)
                     }
                }, withCancel: nil)
            }, withCancel: nil)
       }
   
}
//Mark: -Fetch Profiles Images
func fetchProfileImageUrl(friendId: String,completionHandler: @escaping (String?) -> Void)  {
    let refFriend = Database.database().reference().child("users").child(friendId)
    var profilImageUrl: String?
    DispatchQueue.global(qos: .userInitiated).async {
        refFriend.observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                profilImageUrl = dictionary["profileImageUrl"] as? String
                completionHandler(profilImageUrl!)
            }else{
                completionHandler(nil)
            }
        }, withCancel: nil)
    }
}

//MARK: -Fetch Event Members
func fetchEventMembersId(eventId: String,completionHandler: @escaping ([String]?) -> Void){
    var memberNames = [String]()
    let ref = Database.database().reference().child("event-users").child(eventId)
    DispatchQueue.global(qos: .userInitiated).async {
        ref.observe(.value, with: { (snapshot) in
           
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    
                    for (key, _ ) in dictionary {
                        let refFriend = Database.database().reference().child("users").child(key)
                        refFriend.observe(.value, with: { (snapshot) in
                        if let dictionary = snapshot.value as? [String:AnyObject]{
                           let name = dictionary["name"] as! String
                           memberNames.append(name)
                            }
                             }, withCancel: nil)
                    }
                    let when = DispatchTime.now() + 0.2
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        print(memberNames.count)
                        completionHandler(memberNames)
                    }
                    
                }else{
                    completionHandler(nil)
                    SVProgressHUD.dismiss()
                }
            })
     
    }
}

//MARK: -Remove selected Event from user events list
func removeSelectedIdFromThisUserList(eventId:String){
    let uid = Auth.auth().currentUser?.uid
    let ref = Database.database().reference().child("user-events").child(uid!).child(eventId)
    ref.removeValue { (error, ref) in
        if error != nil {
            print("error \(String(describing: error))")
        }
    }
}

//MARK: -Add New Event
func addNewEvent(name:String,selectedFriendsIds:[String]){
    let uid = Auth.auth().currentUser?.uid
    let ref = Database.database().reference().child("events")
    let eventdRef = ref.childByAutoId()
    eventdRef.updateChildValues(["name":name])
    let interval = NSDate().timeIntervalSince1970
    eventdRef.updateChildValues(["interval":interval])
    
    let eventId = eventdRef.key
    let userEventRef = Database.database().reference().child("user-events").child(uid!)
    userEventRef.updateChildValues([eventId:1])
    
    //add event id for all selected user and add all selected users id for event
    let eventUsersRef = Database.database().reference().child("event-users").child(eventId)
    eventUsersRef.updateChildValues([uid!:1])
    for friendId in selectedFriendsIds {
        let userEventsRef = Database.database().reference().child("user-events").child(friendId)
        userEventsRef.updateChildValues([eventId:1])
        eventUsersRef.updateChildValues([friendId:1])
    }

}
