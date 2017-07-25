//
//  PhotoViewController.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-07-24.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    //MARK: -PROPERTIES
    var takenPhoto: UIImage?
    
    //MARK: -OUTLETS AND ACTIONS
 
    @IBOutlet weak var imageView: UIImageView!
   
   
    @IBAction func cancellBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let availableImage = takenPhoto {
            imageView.image = availableImage
        }
        
    }

    

}
