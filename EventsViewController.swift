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

 var friends = [User]()
class EventsViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,DisplayMembers{

    //MARK: -PROPERTIES
    var events = [Event]()
    var refresh = UIRefreshControl()
    
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

    override func viewDidAppear(_ animated: Bool) {
        self.isUserLogedIn()
        SVProgressHUD.show()
        guard (Auth.auth().currentUser?.uid) != nil else {
            SVProgressHUD.show()
            handleLogout()
            return
        }
        fetchEventsAndDisplay()
     }
    override func viewWillAppear(_ animated: Bool) {
        fetchFriends { (fetchedFriends) in
            if  (fetchedFriends?.count)! > 0 {
                friends = fetchedFriends!
                }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.events.removeAll()
        self.tableView.reloadData()
    }
    
    func fetchEventsAndDisplay()  {
        fetchEvents { (fetchedEvents) in
            self.events = fetchedEvents!
            if self.events.count > 0 {
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
            removeSelectedIdFromThisUserList(eventId: deletedEventId, completionHandler: { (isDeleted) in
                if isDeleted {
                   showAlert(text: "The group is removed successfully!", title: "DELETE", vc: self)
                }else{
                    showAlert(text: "There is an error in removing!", title: "ERROR", vc: self)
                }
             })
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
    //MARK: Display AddNewEvent View
    func addNewEvent()  {
        let popOverAddNewEvent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNewEvent") as! AddNewEventsViewController
        self.addChildViewController(popOverAddNewEvent)
        popOverAddNewEvent.view.frame = self.view.frame
        self.view.addSubview(popOverAddNewEvent.view)
        popOverAddNewEvent.didMove(toParentViewController: self)
    }
    
    
}
