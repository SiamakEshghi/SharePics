//
//  AddNewEventsViewController.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-07-10.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class AddNewEventsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK: -PROPERTIES
    var friendsId = [String]()
    var selectedFriendsIds = [String]()
    
    //MARK: -OUTLETS AND ACTIONS
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var txtEventName: UITextField!
    
    @IBAction func btnCancell(_ sender: UIButton) {
        UsefullFunctions.removeAnimate(vc: self)
        self.view.removeFromSuperview()
    }
    @IBAction func btnAdd(_ sender: UIButton) {
        addNewEvent()
        UsefullFunctions.removeAnimate(vc: self)
        self.view.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UsefullFunctions.showAnimate(vc: self)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        tableView.delegate = self
        tableView.dataSource = self
        fetchFriends()
        }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsId.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell2", for: indexPath) as!
        FreindTableViewCell
     
        let friendId = friendsId[indexPath.row]
        cell.friendId = friendId
        return cell
    }
    
    //MARK: -MULTI SELECTED TABLEVIEW
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if (cell?.accessoryType == UITableViewCellAccessoryType.checkmark){
            
            cell!.accessoryType = UITableViewCellAccessoryType.none;
            selectedFriendsIds = selectedFriendsIds.filter(){$0 != friendsId[indexPath.row]}
        }else{
            
            cell!.accessoryType = UITableViewCellAccessoryType.checkmark;
            selectedFriendsIds.append(friendsId[indexPath.row])
        }
        
    }
    
    //MARK: -ADD NEW FRIEND
    func addNewEvent() {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("events")
        let eventdRef = ref.childByAutoId()
        guard txtEventName.text != "" else {
            UsefullFunctions.showAlert(text: "Please fill all fields", title: "Alert", vc: self)
            return
        }
        eventdRef.updateChildValues(["name":txtEventName.text!])
        eventdRef.updateChildValues(["date":""])
        
        let friendsRef = eventdRef.child("friendsId")
        for friendId in selectedFriendsIds {
            friendsRef.updateChildValues([friendId:1])
        }
        
        let eventId = eventdRef.key
        let userEventRef = Database.database().reference().child("user-events").child(uid!)
        userEventRef.updateChildValues([eventId:1])
    }
    

    //MARK: -FETCH FRIENDS FROM DATABASE
    func fetchFriends() {
        let uid = Auth.auth().currentUser?.uid
        let refFriendList = Database.database().reference().child("users").child(uid!).child("friends")
        refFriendList.observe(.childAdded, with: { (snapshot) in
            
            let friendKey = snapshot.key
            self.friendsId.append(friendKey)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }, withCancel: nil)
    }

}
