//
//  EventInfoViewController.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-11-30.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import UIKit
import Firebase

class EventInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblEventName: UILabel!
    
    @IBOutlet weak var lblAdmin: UILabel!
    
    var members = [User]()
    var event: Event?
    
    @IBAction func btnCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        lblAdmin.text = event?.adminId
        lblEventName.text = event?.name
        fetchAdminName()
    }

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell3")
        
        let item = members[indexPath.row]
        cell?.textLabel?.text = item.name
        
        //Just display phone numbers for admin
        if event?.adminId == Auth.auth().currentUser?.uid{
           cell?.detailTextLabel?.text = item.phoneNumber
        }else {
            cell?.detailTextLabel?.text = ""
        }
        
        return cell!
    }

    func fetchAdminName() {
        let ref = Database.database().reference().child("users")
        ref.observe(.value) { (snapshot) in
            if snapshot.value == nil  {
                return
            }
            let groupKeys = snapshot.children.flatMap { $0 as? DataSnapshot }.map { $0.key }
            
            for key in groupKeys {
                if key == self.event?.adminId {
                    let adminRef = ref.child(key)
                    adminRef.observe(.value, with: { (snapshot) in
                        if let dictionary = snapshot.value as? [String:AnyObject]{
                            DispatchQueue.main.async {
                                let adminName = dictionary["name"] as? String
                                self.lblAdmin.text = "Admin: \(adminName ?? "")"
                            }
                        }
                    })
                }
            }
        }
    }
    
    // delete button for table view
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Remove", handler: { (action, indexPath) in
           
            //Just Admin can remove members
            if self.event?.adminId == Auth.auth().currentUser?.uid{
                let deletedMemberId = self.members[indexPath.row].id!
                
                let alert = UIAlertController(title: "Remove Member", message: "Are You Sure you want to remove the member?", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Yes", style: .default) { (alerAction) in
                    self.members.remove(at: indexPath.row)
                    self.tableView.reloadData()
                    removeSelectedIdFromMemberList(memberId: deletedMemberId, eventId: (self.event?.id)!, completionHandler: {  (isDeleted) in
                        if isDeleted {
                            showAlert(text: "The member is removed successfully!", title: "Remove", vc: self)
                        }else{
                            showAlert(text: "There is an error in removing!", title: "ERROR", vc: self)
                        }
                    })
                }
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alert.addAction(action)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            }else {
                showAlert(text: "Only admin can remove the members!", title: "Error", vc: self)
            }
            
        })
        
        return [deleteAction]
    }
}
