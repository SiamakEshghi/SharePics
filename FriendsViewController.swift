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
import SVProgressHUD

class FriendsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

  //MARK: -OUTLETS AND ACTIONS
    
    @IBOutlet weak var tableView: UITableView!
    
    
override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SVProgressHUD.show()
        self.tableView.reloadData()
     }

    override func viewWillAppear(_ animated: Bool) {
        SVProgressHUD.show()
        if friends.count == 0 {
            fetchFriends(completionHandler: { (fetchedFriends) in
                friends = fetchedFriends!
            })
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as!
        FreindTableViewCell
        
        let friend = friends[indexPath.row]
        cell.friend = friend
        
        return cell
    }
    
    
}
