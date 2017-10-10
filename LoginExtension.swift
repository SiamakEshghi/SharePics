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
        imageViewProfile.image = #imageLiteral(resourceName: "welcome")
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
        if isSignIn{ signIn() }else{   registerNewUser()      }
    }
    
    
    //MARK: -Handle SignIn
    func signIn()  {
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: txtFieldEmail.text!, password: txtFieldPass1.text!, completion: { (user, error) in
            if error != nil{
                SVProgressHUD.dismiss()
                showAlert(text: "User name or Password are not correct!", title: "Error", vc: self)
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        })

    }
    
    //MARK: -Handle Register
    func registerNewUser()  {
        //register new user
        
        Auth.auth().createUser(withEmail: txtFieldEmail.text!, password: txtFieldPass1.text!){ (user, error) in
            if error != nil{
                showAlert(text: (error?.localizedDescription)!, title: "Error", vc: self)
                return
            }else{
                guard let uid = user?.uid else{
                    return
                }
                
                if  let profileImage = self.imageViewProfile.image{
                    saveProfileImage(profileImage: profileImage , completionHandler: { (profileImageUrl) in
                        
                        saveNewUserInFirebase(profileImageUrl: profileImageUrl, uid: uid, name: self.txtFieldName.text!, email: self.txtFieldEmail.text!, completionHandler: { (isError) in
                            if isError {
                                showAlert(text: "There is error in registeration!", title: "Error", vc: self)
                            }else{
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
                    })
                }
           }
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
               showAlert(text: "Passwords are diffrent!", title: "Pass Error", vc: self)
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
