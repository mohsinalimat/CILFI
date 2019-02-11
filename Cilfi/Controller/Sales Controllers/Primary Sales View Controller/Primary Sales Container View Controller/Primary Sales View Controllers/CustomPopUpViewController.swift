//
//  CustomPopUpViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 19/07/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import DropDown
import SVProgressHUD

class CustomPopUpViewController: UIViewController {

    let getGroup = PrimarySalesModel()
    let dropDown = DropDown()
    
    var groupID = ""
    var groupName = ""
    var itemName = ""
    var itemID = ""
    var quantity = ""
    var mrp = ""
    var discount = ""
    
    @IBOutlet weak var popUp: UIView!
    
    @IBOutlet weak var itemBtn: UIButton!
    @IBOutlet weak var groupBtn: UIButton!
    @IBAction func groupBtn(_ sender: UIButton) {
        dropDown.dataSource = getGroup.groupName
        dropDown.anchorView = groupBtn
        
        
        dropDown.show()
        
     
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.itemID = ""
            self.itemName = ""
            self.mrp = ""
            self.itemBtn.titleLabel?.text = "--- Select Item ---"
            self.groupBtn.titleLabel?.text = item
            self.getGroup.getItemData(groupName: self.getGroup.groupCode[index])
            self.groupID = self.getGroup.groupCode[index]
            
            self.groupName = item
        }
    }
    
    @IBAction func itemBtn(_ sender: UIButton) {
        dropDown.dataSource = getGroup.itemName
        dropDown.anchorView = itemBtn
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.itemBtn.titleLabel?.text = item
            self.quantityTF.isEnabled = true
            self.itemID = self.getGroup.itemCode[index]
            self.itemName = item
            self.mrp = self.getGroup.itemMrp[index]
            self.discount = self.getGroup.itemDiscount[index]
    }
    }
    
    @IBOutlet weak var quantityTF: UITextField!
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func addBtn(_ sender: UIButton) {
        if groupID != "" && itemID != "" && mrp != ""{
            if quantityTF.text != ""{
                Group.groupName.append(groupName)
                Group.groupID.append(groupID)
                Group.itemID.append(itemID)
                Group.itemName.append(itemName)
                Group.quantity.append(quantityTF.text!)
                Group.itemMrp.append(mrp)
                Group.itemDiscount.append(discount)
                
                self.performSegue(withIdentifier: "unwindToPSTable", sender: self)
                
            }else{
                SVProgressHUD.showError(withStatus: "Please enter valid quantity.")
                SVProgressHUD.dismiss(withDelay: 3)
            }
        }else{
            SVProgressHUD.showError(withStatus: "Group/Item cant be empty. ")
            SVProgressHUD.dismiss(withDelay: 3)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        
        popUp.layer.borderWidth = 3
        popUp.layer.borderColor = UIColor.black.cgColor
        
        popUp.layer.shadowColor = UIColor.black.cgColor
        popUp.layer.shadowOffset = .zero
        popUp.layer.shadowOpacity = 0.5
        popUp.layer.shadowRadius = 5
        
        
        view.layer.cornerRadius = 10.0
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 0.5
        view.clipsToBounds = true
        
        getGroup.getGroupData()
        
    }

  
}
