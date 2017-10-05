//
//  ImageDetailViewController.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-09-21.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {

    
    //MARK: Properties
    var imageUrl: String?
    
    //MARK: -Outlets and Actions
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func cancell(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       AppUtility.lockOrientation(.portrait)
       imageView.imageFromUrl(urlString: imageUrl!)
    }

   
    override func viewWillDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.all)
    }

    

}
