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


class SelectedEventViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    //MARK: -PROPERTIES
    var currentEvent = Event()
    var id:String?
    var photos = [Photo]()
    var selectedImageUrl: String?
    var isSelectMode = false
    var urlsForSaving = [String]()
    var isSelectAll = false
    var selectedIndexs = [IndexPath]()
 
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.fetchEvent()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        SVProgressHUD.show()
        fetchUrls()
        btnSelectAll.isEnabled = false
    }
    
    
    //MARK: -OUTLETS AND ACTIONS
  
    
    @IBOutlet weak var btnSelected: UIBarButtonItem!
    
    @IBOutlet weak var btnSelectAll: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func cancell(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraBTN(_ sender: UIBarButtonItem) {
        let CameraVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CameraVC") as! CameraController
        CameraVC.eventId = self.id
        self.present(CameraVC, animated: true, completion: nil)
    }
    
    @IBOutlet weak var navBar: UINavigationBar!
    
   
    @IBAction func btnSelectTapped(_ sender: UIBarButtonItem) {
        isSelectMode = !isSelectMode
       
        if isSelectMode {
            btnSelected.title = "Done"
            btnSelectAll.isEnabled = true
            selectedIndexs.removeAll()
        }else{
            btnSelectAll.isEnabled = false
            btnSelected.title = "Select"
            for photo in photos{
                photo.isSelected = false
            }
            isSelectAll = false
            btnSelectAll.title = "SelectAll"
        }
        self.collectionView.reloadData()
    }
    
    @IBAction func btnSelectedAllTaped(_ sender: UIBarButtonItem) {
        isSelectAll = !isSelectAll
        
        if isSelectAll {
        btnSelectAll.title = "RemoveAll"
        for photo in photos{
            photo.isSelected = true
            }
        }else{
            btnSelectAll.title = "SelectAll"
            for photo in photos{
                photo.isSelected = false
            }
        }
        self.collectionView.reloadData()
    }
    
    @IBAction func btnSaveImages(_ sender: UIBarButtonItem) {
        if selectedIndexs.count > 0 {
        for indexpath in selectedIndexs {
            let cell = self.collectionView.cellForItem(at: indexpath)
//            let imageData = UIImagePNGRepresentation(cell)
//            let compressedImage = UIImage(data: imageData!)
//            UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
            }
         showAlert(text: "Images Saved successfully!", title: "Save", vc: self)
        }
    }
   
    
    //Mark: -Fetch Photoes Urls
    func fetchUrls() {
        fetvhPhotoesUrl(id: self.id!) { (urls) in
            if urls != nil {
                for url in urls! {
                    let newPhoto = Photo()
                    newPhoto.url = url
                    self.photos.append(newPhoto)
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }else{
                SVProgressHUD.dismiss()
            }
        }
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
        
    //MARK: -COLLECTION VIEW DAtA SOURCE
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (photos.count)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotosCell
        
        
        
        cell.isSelectMode = self.isSelectMode
        
        // add a border to cell
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 3
        cell.layer.cornerRadius = 8 // optional
        
        let photo = photos[indexPath.row]
        
        //save selected or removing unselected indexpath for saving
        if photo.isSelected {
            if !selectedIndexs.contains(indexPath){
                selectedIndexs.append(indexPath)
            }
        }else{
            selectedIndexs = selectedIndexs.filter{$0 != indexPath}
        }
        
        cell.photo = photo
        
        return cell
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
         SVProgressHUD.show()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       SVProgressHUD.dismiss()
    }
    
    
    //MARK: -collectionView DataSource
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if !isSelectMode{
            selectedImageUrl = photos[indexPath.row].url
            performSegue(withIdentifier: "showDetail", sender: selectedImageUrl)
        }else{
            photos[indexPath.row].isSelected = !photos[indexPath.row].isSelected
            self.collectionView.reloadData()
            }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier ==  "showDetail"{
            let detailVC = segue.destination as! ImageDetailViewController
            detailVC.imageUrl = selectedImageUrl
        }
    }
    
       //customize collectionView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 4 - 1
        
        return CGSize(width: width, height: width)
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}



