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


class SelectedEventViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SaveImages {

    //MARK: -PROPERTIES
    var currentEvent = Event()
    var eventId:String?
    var photos = [Photo]()
    var imageTapedUrl: String?
    var isSelectMode = false
    var isSelectAll = false
    var urls = [String]()
    var selectedImages = [UIImage]()
 
    
    override func viewDidAppear(_ animated: Bool) {
        
        fetchUrls()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchEvent()
        collectionView.delegate = self
        collectionView.dataSource = self
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
        CameraVC.eventId = self.eventId!
        self.present(CameraVC, animated: true, completion: nil)
    }
    
    @IBOutlet weak var navBar: UINavigationBar!
    
   
    @IBAction func btnSelectTapped(_ sender: UIBarButtonItem) {
        isSelectMode = !isSelectMode
       
        if isSelectMode {
            btnSelected.title = "Done"
            btnSelectAll.isEnabled = true
            selectedImages.removeAll()
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
        customizeCheck(isSelected: true)
        }else{
            btnSelectAll.title = "SelectAll"
            customizeCheck(isSelected: false)  }
        
    }
    
    
    // customize Check status of cells
    func customizeCheck(isSelected: Bool) {
        for photo in photos{
            photo.isSelected = isSelected
        }
        self.collectionView.reloadData()
    }
    
    @IBAction func btnSaveImages(_ sender: UIBarButtonItem) {
        saveImagesIntoPhone { (isSavingComplete) in
            if isSavingComplete {
                    self.customizeCheck(isSelected: false)
                    SVProgressHUD.dismiss()
                    showAlert(text: "Images Saved successfully!", title: "Save", vc: self)
                
            }
        }
        
    }
   

    
    //MARk: Protocol SaveImages  functions
    func saveSelectedImage(image:UIImage?){
        if !selectedImages.contains(image!){
        selectedImages.append(image!)
        }
    }
    func removeUnselectedImage(image:UIImage?){
        selectedImages = selectedImages.filter{$0 != image}
    }
    
    //Mark: -saveImages into phone
    func saveImagesIntoPhone(completionHandler: @escaping(Bool) -> Void) {
        if selectedImages.count > 0 {
            SVProgressHUD.show()
            DispatchQueue.global(qos: .userInitiated).async {
                for image in self.selectedImages {
                    let imageData = image.PNGRepresentation()
                    let compressedImage = UIImage(data: imageData!)
                   
                    UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
                }

                self.selectedImages.removeAll()
            }
            completionHandler(true)
        }
    }
    
    //Mark: -Fetch Photoes Urls
    func fetchUrls() {
        photos.removeAll()
        urls.removeAll()
        fetchPhotoesUrl(eventId: self.eventId!, imagesNumber: nil) { (urls) in

            if urls != nil {
                for url in urls! {
                    
                    //we use urls array to have count for displaying images and avoiding cells duplicatin
                    if !self.urls.contains(url){
                        self.urls.append(url)
                        let newPhoto = Photo()
                        newPhoto.url = url
                        self.photos.append(newPhoto)
                    }
                    
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
            let eventRef = Database.database().reference().child("events").child(self.eventId!)
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
        return (urls.count)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotosCell
        
        cell.delegate = self
        
        cell.isSelectMode = self.isSelectMode
        
        cell.imageView.image = nil
        cell.photo = nil
        
        // add a border to cell
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 3
        cell.layer.cornerRadius = 8 // optional
        let photo = photos[indexPath.row]
        cell.photo = photo
        
        return cell
    }
    
    
    
    //MARK: -collectionView DataSource
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if !isSelectMode{
            imageTapedUrl = photos[indexPath.row].url
            performSegue(withIdentifier: "showDetail", sender: imageTapedUrl)
        }else{
            
             //set selected status
            photos[indexPath.row].isSelected = !photos[indexPath.row].isSelected
            self.collectionView.reloadData()
            }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier ==  "showDetail"{
            let detailVC = segue.destination as! ImageDetailViewController
            detailVC.imageUrl = imageTapedUrl
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



