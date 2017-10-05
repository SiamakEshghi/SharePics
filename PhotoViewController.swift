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
    var photo: UIImage?
    
    
    //MARK: -OUTLETS AND ACTIONS
 
    @IBOutlet weak var imageView: UIImageView!
   
   
    @IBAction func cancellBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnDownTapped(_ sender: UIBarButtonItem) {
        
        self.savePhoto()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         AppUtility.lockOrientation(.all)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtility.lockOrientation(.portrait)
        
        if let availableImage = takenPhoto {
            imageView.image = availableImage
            photo = availableImage
        }
     
    }
    
    //MARK: -SAVE PHOTO INTO FIREBASE STORAGE
    func savePhoto()  {
  
        let photoName = NSUUID().uuidString
        
        let photoEventRef = Database.database().reference().child("event-photos").child(eventId!)
        
        let storageref = Storage.storage().reference().child("photos").child("\(photoName).jpg")
        
        if  let uploadData = UIImageJPEGRepresentation(photo!, 0.1){
            storageref.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    return
                }
                
                photoEventRef.updateChildValues([photoName:1])
                
                if let photoUrl = metadata?.downloadURL()?.absoluteString{
                    let ref = Database.database().reference().child("Photos").child(photoName)
                    ref.updateChildValues(["URL":photoUrl])
                }
            }
        }
  }
    
    
}
