//
//  CameraController.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-09-01.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import UIKit
import SwiftyCam
import SVProgressHUD

class CameraController: SwiftyCamViewController,SwiftyCamViewControllerDelegate {
    
    //MARK: -Properties
     var eventId: String?
    //MARK: -OUtlets and Actions
    
    @IBOutlet weak var imageViewflash: UIImageView!
    
    @IBAction func switchCameraAction(_ sender: UIBarButtonItem) {
        switchCamera()
    }

    @IBAction func cancellBtnAction(_ sender: UIBarButtonItem) {
        SVProgressHUD.show()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takingPhotoAction(_ sender: UIBarButtonItem) {
        takePhoto()
        }
    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraDelegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageViewflash.isUserInteractionEnabled = true
        imageViewflash.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        flashEnabled = !flashEnabled
        
        if flashEnabled {
            imageViewflash.image = #imageLiteral(resourceName: "flashOn")
        }else {
            imageViewflash.image = #imageLiteral(resourceName: "flashOff")
        }
        
    }

   
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        // Called when takePhoto() is called or if a SwiftyCamButton initiates a tap gesture
        // Returns a UIImage captured from the current session
        let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoVC") as! PhotoViewController
        
        photoVC.takenPhoto = photo
        photoVC.eventId = self.eventId
        DispatchQueue.main.async {
            self.present(photoVC, animated: true, completion:nil)
             
            }
    }

   
}
