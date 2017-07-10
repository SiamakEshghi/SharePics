//
//  LoginViewController.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-07-09.
//  Copyright © 2017 Joopooli. All rights reserved.
//
import UIKit
import AVFoundation

class LoginViewController: UIViewController {
    
    //MARK: -PROPERTIES
    var Player: AVPlayer!
    var PlayerLayer: AVPlayerLayer!
    var isSignIn = true
    
    
    //MARK: -OUTLETS AND ACTIONS
    @IBOutlet weak var txtFieldName: UITextField!
    
    @IBOutlet weak var txtFieldEmail: UITextField!
    
    @IBOutlet weak var txtFieldPass1: UITextField!
    
    @IBOutlet weak var txtFieldPass2: UITextField!
    
    @IBOutlet weak var btnSignIn: UIButton!
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        handleSegment()
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
         handleRegisterAndSignIn()
    }
    
    @IBAction func btnForgetPass(_ sender: UIButton) {
        showForgetPassView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVideoBackground()
        hiddensHandles()
        addProfileImage()
    }
    
    
    
   
}
