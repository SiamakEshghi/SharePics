//
//  EachEventViewController.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-07-18.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SelectedEventViewController: UIViewController {

    //MARK: -PROPERTIES
    var currentEvent = Event()
    var id:String?
    //MARK: -OUTLETS AND ACTIONS
    
    
    @IBAction func cancell(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraBTN(_ sender: UIBarButtonItem) {
        let CameraVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CameraVC") as! CameraViewController
        self.present(CameraVC, animated: true, completion: nil)
    }
    
    @IBOutlet weak var navBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
    }

    override func viewWillAppear(_ animated: Bool) {
      DispatchQueue.global(qos: .userInitiated).async {
            self.fetchEvent()
        }
       
    }
    
    
    //MARK: -FETCH CURRENT EVENT
    func fetchEvent() {
      
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
