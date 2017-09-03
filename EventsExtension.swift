//
//  EventsExtension.swift
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

extension EventsViewController {
    
    //MARK: -CHECK CURRENT USER
    func isUserLogedIn()  {
        guard let uid = Auth.auth().currentUser?.uid else {
            handleLogout()
            return
        }
        let userRef = Database.database().reference().child("users").child(uid)
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                let name = dictionary["name"] as! String
                self.NavBar.title = name + "'s groups"
            }
        })
        
    }
    
    
    //MARK: -LOGOUT
    func handleLogout()  {
        do{
            try Auth.auth().signOut()
        }catch {
            showAlert(text: error.localizedDescription, title: "Error", vc: self)
        }
        
        DispatchQueue.main.async {
              let Loginview = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginView") as! LoginViewController
            self.present(Loginview, animated: true, completion:nil)
        }
    }
    //MARK: _ADD NEW EVENT
    func addNewEvent()  {
        let popOverAddNewEvent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpAddNewEvent") as! AddNewEventsViewController
        self.addChildViewController(popOverAddNewEvent)
        popOverAddNewEvent.view.frame = self.view.frame
        self.view.addSubview(popOverAddNewEvent.view)
        popOverAddNewEvent.didMove(toParentViewController: self)
    }
    
    //MARK: -FETCH EVENTS ID FROM DATABASE
    func fetchEvents()  {
        
       guard let uid = Auth.auth().currentUser?.uid else {
            handleLogout()
            return
        }
    
        let ref = Database.database().reference().child("user-events").child(uid)
        
        ref.observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                
                self.eventsIds.removeAll()
                let group = DispatchGroup()
                for (key, _ ) in dictionary {
                    group.enter()
                    self.eventsIds.append(key)
                    group.leave()
                }
                group.notify(queue: .main, execute: {
                    self.collectionView.reloadData()
                    SVProgressHUD.dismiss()
                })
            }else{
                SVProgressHUD.dismiss()
            }
            
        }, withCancel: nil)
    }
    
    
    //MARK: -Prepare Events
    func prepareEventsController()  {
       
        DispatchQueue.global(qos: .userInitiated).async {
            self.isUserLogedIn()
            self.fetchEvents()
        }
        
        }
 
}
