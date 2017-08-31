//
//  LoginExtension.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-07-09.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SVProgressHUD

extension LoginViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    //MARK: -TEXTFIELDS
    
    func hiddensHandles()  {
        txtFieldName.isHidden = true
        txtFieldPass2.isHidden = true
        imageViewProfile.image = #imageLiteral(resourceName: "welcom")
        }
    
    
    
    //MARK: -SEGMENT
    func handleSegment() {
        isSignIn = !isSignIn
        
        if isSignIn{
            imageViewProfile.isUserInteractionEnabled = false
            btnSignIn.setTitle("SignIn", for: .normal)
            hiddensHandles()
            parentStackView.distribution = .fillProportionally
            
        }else{
            addProfileImage()
            btnSignIn.setTitle("Register", for: .normal)
            txtFieldName.isHidden = false
            txtFieldPass2.isHidden = false
            imageViewProfile.image =  #imageLiteral(resourceName: "NoOne")
            parentStackView.distribution = .fillEqually
        }
    }
    
 
    
    
    //MARK: -PROFILE IMAGE
    func addProfileImage()  {
        imageViewProfile.isUserInteractionEnabled = true
        imageViewProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImage)))
    }
    func handleSelectProfileImage()  {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            selectedImageFromPicker = editedImage
        }else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker{
            imageViewProfile.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel picker")
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: -REGISTER AND SIGN IN
    func handleRegisterAndSignIn()  {
        
        checkInputTexts()
        
        //sign in
        if isSignIn{
            SVProgressHUD.show()
            Auth.auth().signIn(withEmail: txtFieldEmail.text!, password: txtFieldPass1.text!, completion: { (user, error) in
                if error != nil{
                    SVProgressHUD.dismiss()
                    showAlert(text: "User name or Password are not correct!", title: "Error", vc: self)
                }else{
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }else{ //register new user
            
           Auth.auth().createUser(withEmail: txtFieldEmail.text!, password: txtFieldPass1.text!){ (user, error) in
                if error != nil{
                    showAlert(text: (error?.localizedDescription)!, title: "Error", vc: self)
                    return
                }else{
                    guard let uid = user?.uid else{
                        return
                    }
                    
                 //create a unic name for image
                    let imageName = NSUUID().uuidString
                    let storgaeRef = Storage.storage().reference().child("Profile_Images").child("\(imageName).jpg")
                    
                    //Save image in storage
                    if let profileImage = self.imageViewProfile.image , let uploadedData = UIImageJPEGRepresentation(profileImage, 0.1){
                        storgaeRef.putData(uploadedData, metadata: nil){ (metadata, error) in
                            if error != nil {
                                return
                            }
                            if let profileImageUrl = metadata?.downloadURL()?.absoluteString{
                                let values = ["name":self.txtFieldName.text!,"email":self.txtFieldEmail.text!,"profileImageUrl":profileImageUrl]
                                self.registerNewUserIntoFirebaseDatabase(uid: uid, values: values as [String:AnyObject])
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    func registerNewUserIntoFirebaseDatabase(uid: String,values: [String:AnyObject]) {
        let ref = Database.database().reference()
        
        let userRef = ref.child("users").child(uid)
        userRef.updateChildValues(values) { (error, ref) in
            if error != nil{
                showAlert(text: "There is some error in registering!", title: "Error", vc: self)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    //MARK: -INPUT CHECK
    func checkInputTexts()  {
        
        guard txtFieldEmail.text != "",
            txtFieldPass1.text != "" else {
               showAlert(text: "Please fill all fields!", title: "Alert", vc: self)
                return
        }
        
        //for register
        if !isSignIn{
            guard txtFieldPass2.text != "",
                txtFieldName.text  != "" else{
                showAlert(text: "Please fill all fields!", title: "Alert", vc: self)
                    return
            }
            
            //check pass1 is equal pass2
            guard txtFieldPass1 != txtFieldPass2 else{
               showAlert(text: "Entered passwords are diffrent!", title: "Pass Error", vc: self)
                return
            }
            
            
        }
    }
    
    //MARK: -FORGET PASS
    func showForgetPassView() {
        let popOverResetPassVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpResetPass") as! ForgetPasswordPopUpViewController
        self.addChildViewController(popOverResetPassVc)
        popOverResetPassVc.view.frame = self.view.frame
        self.view.addSubview(popOverResetPassVc.view)
        popOverResetPassVc.didMove(toParentViewController: self)
    }
    
    
    
}
