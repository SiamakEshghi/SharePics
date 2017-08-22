//
//  FreindsViewController.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-07-10.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Kingfisher
import SVProgressHUD

class FriendsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    
    //MARK: -PROPERTIES
    var friendsId = [String]()
    
   //MARK: -OUTLETS AND ACTIONS
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: -NEW FRIENDS
    @IBAction func btnAddNewFriends(_ sender: UIBarButtonItem) {
        let popOverNewFriendVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpNewFriend") as! AddNewFriendsViewController
        self.addChildViewController(popOverNewFriendVc)
        popOverNewFriendVc.view.frame = self.view.frame
        self.view.addSubview(popOverNewFriendVc.view)
        
        popOverNewFriendVc.didMove(toParentViewController: self)
    }
    
    
override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SVProgressHUD.show()
        self.friendsId.removeAll()
        self.tableView.reloadData()
        DispatchQueue.global(qos: .userInitiated).async {
           fetchFriends(ids:self.friendsId,tableview:self.tableView)
        }
       
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsId.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as!
        FreindTableViewCell
        
        let friendId = friendsId[indexPath.row]
        
        cell.friendId = friendId
        
        return cell
    }
    
   
}


    
    
//    func fetchFriends() {
//        let group = DispatchGroup()
//        
//        let uid = Auth.auth().currentUser?.uid
//        let refFriendList = Database.database().reference().child("users").child(uid!).child("friends")
//        
//        
//            refFriendList.observe(.value, with: { (snapshot) in
//                
//                if let dictionary = snapshot.value as? [String:AnyObject]{
//                    self.friendsId.removeAll()
//                    
//                    for (key, _ ) in dictionary {
//                        group.enter()
//                        self.friendsId.append(key)
//                        group.leave()
//                    }
//                    group.notify(queue: .main, execute: {
//                        self.tableView.reloadData()
//                        SVProgressHUD.dismiss()
//                    })
//                }
//                
//            }, withCancel: nil)
//       
//        
//    }
//}
