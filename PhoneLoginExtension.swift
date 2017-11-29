//
//  PhoneLoginExtension.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-11-28.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import SVProgressHUD

extension PhoneLoginViewController :UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func prepareProfileImage()  {
        profileImageView.image = #imageLiteral(resourceName: "NoOne")
        manageProfileImagePicker() 
    }
    
    //MARK: -PROFILE IMAGE
    func manageProfileImagePicker()  {
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImage)))
    }
    
    @objc func handleSelectProfileImage()  {
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
            profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel picker")
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Register
    func register(){
        SVProgressHUD.show()
        guard let phoneNumber = self.txtPhoneNumber.text, let _ = txtName.text else {
            showAlert(text: "Please fill all fields!", title: "Error", vc: self)
            return
        }
      
        
        let alert = UIAlertController(title: "Phone number", message: "Is this your phone number \n \(phoneNumber)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default) { (alerAction) in
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationId, error) in
                if error != nil {
                    SVProgressHUD.dismiss()
                    showAlert(text: "Error: \(error.debugDescription)", title: "Error", vc: self)
                }else{
                    let defaults = UserDefaults.standard
                    defaults.setValue(verificationId, forKey: "authVID")
                    
                     self.performSegue(withIdentifier: "code", sender: Any?.self)
                }
            }
        }
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let verification = segue.destination as? VerificationViewController{
            verification.profileImage = self.profileImageView.image
            verification.name = self.txtName.text
            
        }
    }
}
