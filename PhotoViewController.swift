//
//  PhotoViewController.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-07-24.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class PhotoViewController: UIViewController {
    
    //MARK: -PROPERTIES
    var takenPhoto: UIImage?
    var eventId: String?
    
    
    //MARK: -OUTLETS AND ACTIONS
 
    @IBOutlet weak var imageView: UIImageView!
   
   
    @IBAction func cancellBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnOKTapped(_ sender: UIBarButtonItem) {
        
        self.savePhoto()
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if let availableImage = takenPhoto {
            imageView.image = availableImage
        }
     
    }
    
    //MARK: -SAVE PHOTO INTO FIREBASE STORAGE
    func savePhoto()  {
        let photoName = NSUUID().uuidString
        let storageref = Storage.storage().reference().child("event-photos").child("\(photoName).jpg")
        if let photo = imageView.image , let uploadData = UIImageJPEGRepresentation(photo, 0.1){
            storageref.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    return
                }
                
                if let photoUrl = metadata?.downloadURL()?.absoluteString{
                    let ref = Database.database().reference().child("event-photos").child(self.eventId!)
                   ref.updateChildValues([photoName:photoUrl])
                }
            }
        }
  }
    

}
