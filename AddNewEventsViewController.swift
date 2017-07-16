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
    
    //MARK: -OUTLETS AND ACTIONS
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var txtEventName: UITextField!
    
    @IBAction func btnCancell(_ sender: UIButton) {
    }
    @IBAction func btnAdd(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsMultipleSelection = true
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
