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
import SVProgressHUD


class AddNewEventsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK: -PROPERTIES
    var selectedFriendsIds = [String]()
    
    //MARK: -OUTLETS AND ACTIONS
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var txtEventName: UITextField!
    
    @IBAction func btnCancell(_ sender: UIButton) {
        removeAnimate(vc: self)
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func btnAdd(_ sender: UIButton) {
        addNewEvent()
        
    }
    
    override func viewDidLoad() {
        SVProgressHUD.show()
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        showAnimate(vc: self)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.delegate = self
        tableView.dataSource = self
        fetchFriends(tableview: self.tableView)
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
            showAlert(text: "Please enter name of event!", title: "Alert", vc: self)
            return
        }
        eventdRef.updateChildValues(["name":txtEventName.text!])
        eventdRef.updateChildValues(["date":""])
        

        
        let eventId = eventdRef.key
        let userEventRef = Database.database().reference().child("user-events").child(uid!)
        userEventRef.updateChildValues([eventId:1])
        
        //add event id for all selected user
        for friendId in selectedFriendsIds {
            let userEventRef = Database.database().reference().child("user-events").child(friendId)
            userEventRef.updateChildValues([eventId:1])
        }
        removeAnimate(vc: self)
        self.dismiss(animated: true, completion: nil)
    }
    
}



