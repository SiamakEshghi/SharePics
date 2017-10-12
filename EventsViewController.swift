//
//  EventsViewController.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-07-10.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD

class EventsViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,DisplayMembers{

    //MARK: -PROPERTIES
    var events = [Event]()
    
    //MARK: -OUTLETS AND ACTIONS
    @IBOutlet weak var NavBar: UINavigationItem!
   
 
    @IBOutlet weak var tableView: UITableView!
   
    
    @IBAction func btnLogoutTapped(_ sender: UIBarButtonItem) {
        handleLogout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        }
    override func viewWillAppear(_ animated: Bool) {
        //Clean collectionView
        self.events.removeAll()
        self.tableView.reloadData()
        }
    override func viewDidAppear(_ animated: Bool) {
        self.isUserLogedIn()
        SVProgressHUD.show()
        guard (Auth.auth().currentUser?.uid) != nil else {
            handleLogout()
            return
        }
        fetchEvents() { (events) in
            if events != nil , (events?.count)! > 0  {
                self.events = (events?.sorted{ $0.date! > $1.date!})!
                self.tableView.reloadData()
            }else{
                SVProgressHUD.dismiss()
            }
        }
     }
    
    
    //TableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return events.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        cell.delegate = self
        // add a border to cell
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 3
        cell.layer.cornerRadius = 8 // optional
        
        let event = events[indexPath.row]
        cell.event = event
        
        return cell
    }
    
    
    //TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = events[indexPath.row].id!
        
        let oneEventVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectedEvent") as! SelectedEventViewController
        oneEventVC.eventId = id
        present(oneEventVC, animated: true, completion: nil)

    }
    // delete button for table view
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            
             let deletedEventId = self.events[indexPath.row].id!
             self.events.remove(at: indexPath.row)
             self.tableView.reloadData()
             removeSelectedIdFromThisUserList(eventId:deletedEventId)
            })
        
        return [deleteAction]
    }
    
    //MARK: -Display event member sent by delegate DisplayMembers
    func sendingMemberList(members: [String]) {
        var nameList = "*-"
        for member in members {
            nameList +=  member + "-"
        }
        nameList += "*"
        showAlert(text: nameList, title: "Members!", vc: self)
    }

    
    //Add  animation
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //1. set the initial state of the cell
        cell.alpha = 0
        
        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
        cell.layer.transform = transform
        
        //2.UIView animation method to change to the final state of the cell
        UIView.animate(withDuration: 1.0) { 
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }
    }
}
