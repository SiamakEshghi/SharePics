//
//  AddNewEventsViewController.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-07-10.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD


class AddNewEventsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    //MARK: -PROPERTIES
    var selectedFriendsIds = [String]()
    
    
    //MARK: -OUTLETS AND ACTIONS
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var txtEventName: UITextField!
    
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnCancell(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        }
    @IBAction func btnAdd(_ sender: UIButton) {
        guard txtEventName.text != "" else {
            showAlert(text: "Please enter name of event!", title: "Alert", vc: self)
            return
        }
        addNewEvent(name: txtEventName.text!, selectedFriendsIds: selectedFriendsIds)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        SVProgressHUD.show()
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        txtEventName.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
      }
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell2", for: indexPath) as!
        FreindTableViewCell
     
        let friend = friends[indexPath.row]
        cell.friend = friend
        return cell
    }
    
    //MARK: -MULTI SELECTED TABLEVIEW
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if (cell?.accessoryType == UITableViewCellAccessoryType.checkmark){
            
            cell!.accessoryType = UITableViewCellAccessoryType.none;
            selectedFriendsIds = selectedFriendsIds.filter(){$0 != friends[indexPath.row].id}
        }else{
            
            cell!.accessoryType = UITableViewCellAccessoryType.checkmark;
            selectedFriendsIds.append(friends[indexPath.row].id!)
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



