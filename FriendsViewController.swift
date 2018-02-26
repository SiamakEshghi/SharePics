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
import DZNEmptyDataSet


class FriendsViewController: AdViewController,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{

  //MARK: -OUTLETS AND ACTIONS
    
    @IBOutlet weak var tableView: UITableView!
    

    
override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.emptyDataSetDelegate = self
    tableView.emptyDataSetSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SVProgressHUD.show()
        self.tableView.reloadData()
        if friends.count == 0 {
            SVProgressHUD.dismiss()
        }
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
    
    //Add description/subtitle on empty dataset
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Tap the +  to add your first friend."
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
}
