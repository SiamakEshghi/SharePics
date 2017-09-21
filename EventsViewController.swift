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

class EventsViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    //MARK: -PROPERTIES
    var eventsIds = [String]()
    
    //MARK: -OUTLETS AND ACTIONS
    @IBOutlet weak var NavBar: UINavigationItem!
   
 
    @IBOutlet weak var tableView: UITableView!
   
    
    @IBAction func btnInformation(_ sender: UIButton) {
        print("info test")
    }
    
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
        self.eventsIds.removeAll()
        self.tableView.reloadData()
        }
    override func viewDidAppear(_ animated: Bool) {
        SVProgressHUD.show()
        self.isUserLogedIn()
        
        guard let uid = Auth.auth().currentUser?.uid else {
            handleLogout()
            return
        }
        fetchEvents(id: uid) { (fetchedEventIds) in
         self.eventsIds = fetchedEventIds
            self.tableView.reloadData()
        }
     }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return eventsIds.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        
        // add a border to cell
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 3
        cell.layer.cornerRadius = 8 // optional
        
        let id = eventsIds[indexPath.row]
        cell.eventId = id
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = eventsIds[indexPath.row]
        
        let oneEventVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectedEvent") as! SelectedEventViewController
        oneEventVC.id = id
        present(oneEventVC, animated: true, completion: nil)

    }
    
        
}
