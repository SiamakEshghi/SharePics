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

class FriendsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ParentDelegateUpdate {

    
   //MARK: -OUTLETS AND ACTIONS
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: -NEW FRIENDS
    @IBAction func btnAddNewFriends(_ sender: UIBarButtonItem) {
        let popOverNewFriendVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpNewFriend") as! AddNewFriendsViewController
        self.addChildViewController(popOverNewFriendVc)
        popOverNewFriendVc.view.frame = self.view.frame
        self.view.addSubview(popOverNewFriendVc.view)
        
        popOverNewFriendVc.delegate = self
        
        popOverNewFriendVc.didMove(toParentViewController: self)
    }
    
override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell? = nil
        return cell!
    }

    //MARK: -DELEGATE FUNCTION
    
    func parentViewUpdate() {
        print("subview is closed")
    }
  
}
