//
//  EventsViewController.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-07-10.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SVProgressHUD

class EventsViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource{

    //MARK: -PROPERTIES
    var eventsIds = [String]()
    
    //MARK: -OUTLETS AND ACTIONS
    @IBOutlet weak var NavBar: UINavigationItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
   
  
    @IBAction func btnAddEvent(_ sender: UIBarButtonItem) {
        addNewEvent()
    }
    
    
    @IBAction func btnLogoutTapped(_ sender: UIBarButtonItem) {
        handleLogout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        }
    
    override func viewDidAppear(_ animated: Bool) {
        SVProgressHUD.show()
        prepareEventsController()
        }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return eventsIds.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! EventCollectionViewCell
        
        let id = eventsIds[indexPath.row]
        cell.eventId = id
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let id = eventsIds[indexPath.row]
        
        let oneEventVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectedEvent") as! SelectedEventViewController
            oneEventVC.id = id
        present(oneEventVC, animated: true, completion: nil)
        
        
    }
    
    //add 3 cell for each row  
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(3 - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(3))
        return CGSize(width: size, height: size)
    }
    
    
}
