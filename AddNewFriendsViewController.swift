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
import SVProgressHUD



class AddNewFriendsViewController: AdViewController,UITextFieldDelegate {

      var isAddedSuccessfull = false
    
    
    //MARK: -OUTLETS AND ACTIONS
    
    @IBOutlet weak var txtPhoneNumber: UITextField!
    

    
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        if isAddedSuccessfull {
            friends.removeAll()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnAddFriendTapped(_ sender: UIButton) {
        perform(#selector(handleAddFriend), with: nil, afterDelay: 0)
        }
    
    @IBAction func btnSyncPhoneNumbers(_ sender: UIButton) {
        var friendManager = FriendManager()
        var contactsPhoneNumbers = [String]()
        
        let alert = UIAlertController(title: "Sync Numbers", message: "SharePics Just Syncs your contact's phone number wich are started with + and country code like +1, +98", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (alerAction) in
            SVProgressHUD.show()
            contactsPhoneNumbers = (friendManager.fetchPhoneNumbers())
            
            self.syncContacys(contactsNumber: contactsPhoneNumbers, completionHandler: {
                self.isAddedSuccessfull = true
                SVProgressHUD.dismiss()
            })
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
       hideKeyboardWhenTappedAround()
        txtPhoneNumber.delegate = self
        
     
    }
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
    }
    override func viewWillDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.all)}
    
    //MARK: -ADD FRIEND
    @objc func handleAddFriend() {
        
        //query user by email
        let ref = Database.database().reference().child("users")
        let phoneNumber = txtPhoneNumber.text
        let uid = Auth.auth().currentUser?.uid
        
        guard isPhonenumberValid(phoneNumber: phoneNumber!) else{
            showAlert(text: "Phone number must start with + and contry code like +1, +98", title: "Input Format", vc: self)
            return
        }
        
        //query in database by email
        ref.queryOrdered(byChild: "phoneNumber").queryEqual(toValue: phoneNumber).observe(.value, with: { (snapshot) in
            if snapshot.exists(){
                
               //access user key in snapshot
                    if let dictionary = snapshot.value as? [String:AnyObject]{
                        for (friendId,_) in dictionary{
                           
                            //save new friend in database
                            let friendRef = Database.database().reference().child("users").child(uid!).child("friends")
                            friendRef.updateChildValues([friendId:phoneNumber!])
                            showAlert(text: "New friend is added successfully!", title: "Success", vc: self)
                            self.isAddedSuccessfull = true
                            self.txtPhoneNumber.text = ""
                        }
                    }
                    
            }else{
                showAlert(text: "The phone number is not existed!", title: "Not Found", vc: self)
             }
        }, withCancel: nil)
    }
   
    //MARK: - Sync contacts
    @objc func syncContacys(contactsNumber: [String], completionHandler: (()-> Void)? )  {
        if let currentUid = Auth.auth().currentUser?.uid{
            let friendsRef = Database.database().reference().child("users").child(currentUid).child("friends")
            
            let usersRef = Database.database().reference().child("users")
            usersRef.observe(.value) { (snapshot) in
                let userIds = snapshot.children.flatMap { $0 as? DataSnapshot }.map { $0.key }
//                 let group = DispatchGroup()
                
                for userId in userIds {
//                        group.enter()
                    let userRef = Database.database().reference().child("users").child(userId)
                    
                    userRef.observe(.value, with: { (snapshot) in
                        if let dictionary = snapshot.value as? [String:AnyObject]{
                            if let userPhoneNumber = dictionary["phoneNumber"] as? String {
                            
                            for contact in contactsNumber {
                                if contact == userPhoneNumber {
                                    let newValue = [userId:contact]
                                    friendsRef.updateChildValues(newValue)
                                }
                              }
                            }
                        }
//                          group.leave()
                    })
                }
                completionHandler!()
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
