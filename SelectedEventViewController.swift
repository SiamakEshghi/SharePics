//
//  EachEventViewController.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-07-18.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SVProgressHUD


class SelectedEventViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    //MARK: -PROPERTIES
    var currentEvent = Event()
    var id:String?
    var photosUrls = [String]()
    
    
    //MARK: -OUTLETS AND ACTIONS
    
    @IBOutlet weak var tappedPhotoImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func cancell(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraBTN(_ sender: UIBarButtonItem) {
        let CameraVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CameraVC") as! CameraViewController
        CameraVC.eventId = self.id
        self.present(CameraVC, animated: true, completion: nil)
    }
    
    @IBOutlet weak var navBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
       }

    override func viewWillAppear(_ animated: Bool) {
        self.photosUrls.removeAll()
        self.fetchEvent()
    }
    override func viewDidAppear(_ animated: Bool) {
        SVProgressHUD.show()
        fetchPhotos()
    }

    //MARK: -FETCH CURRENT EVENT
    func fetchEvent() {
      
        DispatchQueue.global(qos: .userInitiated).async {
            let eventRef = Database.database().reference().child("events").child(self.id!)
            var name: String?
            eventRef.observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    name = dictionary["name"] as? String
                    
                    DispatchQueue.main.async {
                        self.currentEvent.name = name
                        self.navBar.topItem?.title = name
                    }
                   
                }
            }, withCancel: nil)
        }
        
    }
    
    //MARK: -FETCH PHOTOS
    func fetchPhotos()  {
        let ref = Database.database().reference().child("event-photos").child(self.id!)
        
        ref.observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:String]{
                
                let group = DispatchGroup()
                for (_,value) in dictionary {
                
                    group.enter()
                    if self.photosUrls.contains(value) == false{
                    self.photosUrls.append(value)
                    }
                    group.leave()
                  
                }
                group.notify(queue: .main, execute: {
                    self.collectionView.reloadData()
                    SVProgressHUD.dismiss()
                    })
            }else{
                SVProgressHUD.dismiss()
            }
            
        }, withCancel: nil)
    }
    
    //MARK: -COLLECTION VIEW CONFIGURATION
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return (photosUrls.count)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotosCollectionViewCell
        
        let url = photosUrls[indexPath.row]
        cell.photoUrl = url
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       let selectedPhotoUrl = photosUrls[indexPath.row]
       self.tappedPhotoImageView?.imageFromUrl(urlString: selectedPhotoUrl)
        
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


