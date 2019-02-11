//
//  AssetsApprovalDetailViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੨੨/੧੦/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class AssetsApprovalDetailViewController: UIViewController {

    var rowseq = ""
    
    let assets = AssetsApprovalModel()
    var empCode = ""
    var assetCode = ""
    
    var editFlag = false
    
     var header =  [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "employeeCode")!, "assetsType" : "A"]
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var assetLbl: UILabel!
    @IBOutlet weak var quantLbl: UILabel!
    @IBAction func approvedQuantTF(_ sender: UITextField) {
        
        if approvedQuantTF.text != ""{
            
            if Int(approvedQuantTF.text!)! <= Int(quantLbl.text!)! && Int(approvedQuantTF.text!)! >= 1 {
                editFlag = !editFlag
                
                setEnableDisable()
            }else{
                approvedQuantTF.text = quantLbl.text
                SVProgressHUD.showError(withStatus: "You can only approve quantity not more than \(quantLbl.text!)")
                approvedQuantTF.becomeFirstResponder()
            }
            
           
        }else{
            SVProgressHUD.showError(withStatus: "Quantity can't be empty.")
            approvedQuantTF.becomeFirstResponder()
        }
        
       
    }
    @IBOutlet weak var approvedQuantTF: UITextField!
    @IBOutlet weak var editBtn: UIButton!
    @IBAction func editBtn(_ sender: UIButton) {
        
        editFlag = !editFlag
        setEnableDisable()
    }
    
    @IBOutlet weak var applyDateLbl: UILabel!
    @IBOutlet weak var approvedDateLbl: UILabel!
    @IBOutlet weak var remarkLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var mgrRemarksTF: UITextField!
    
    @IBAction func rejectBtn(_ sender: UIButton) {
        
        assets.setData(assetType: "A", params: [self.getParams(status : "R")], completion: { (returnType) in
            if returnType.string == "Rejected successfully"{
                SVProgressHUD.showSuccess(withStatus: returnType.string)
                self.navigationController?.popViewController(animated: true)
            }else{
                SVProgressHUD.showError(withStatus: returnType.string)
            }
        })
    }
    @IBAction func approveBtn(_ sender: UIButton) {
        
        assets.setData(assetType: "A", params: [self.getParams(status : "A")], completion: { (returnType) in
            if returnType.string == "Approved successfully"{
                SVProgressHUD.showSuccess(withStatus: returnType.string)
               self.navigationController?.popViewController(animated: true)
            }else{
                SVProgressHUD.showError(withStatus: returnType.string)
            }
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        getData()
    }

    func getData(){
        
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/Assetsapproval", headers: header).responseJSON{
            response in
            
            //            print(headers)
            let aData = response.data!
            let aJSON = response.result.value
            
            if response.result.isSuccess{
                //                print(aJSON)
                do{
                    let aStatus = try JSONDecoder().decode(AssetsApprovalRoot.self, from: aData)
                    
                    for x in aStatus.asset{
                        
                        if self.rowseq == x.rowSeq{
                            
                            if let value = x.empName{
                                self.nameLbl.text = value
                            }
                            if let value = x.productName{
                                self.assetLbl.text = value
                            }
                            if let value = x.applyQuantity{
                                self.quantLbl.text = String(value)
//                                self.approvedQuantTF.text = String(value)
                            }
                            if let value = x.applyTransactionDate{
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                                if let date = formatter.date(from: value){
                                    formatter.dateFormat = "dd MMMM yyyy"
                                    self.applyDateLbl.text = (formatter.string(from: date))
                                }
                            }
                            if let value = x.mgrDate{
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                                if let date = formatter.date(from: value){
                                    formatter.dateFormat = "dd MMMM yyyy"
                                    self.approvedDateLbl.text = (formatter.string(from: date))
                                }
                            }
                            if let value = x.remark{
                                self.remarkLbl.text = value
                            }
                            if let value = x.mgrStatus{
                                if value == "Pending"{
                                   self.approvedQuantTF.text = String(x.applyQuantity!)
                                    self.editBtn.isHidden = false
                                }else{
                                    self.approvedQuantTF.text = String(x.mgrQuantity!)
                                    self.editBtn.isHidden = true
                                }
                                 self.statusLbl.text = value
                            }
                            
                            if let value = x.empCode{
                                self.empCode = value
                            }
                            if let value = x.applyProduct{
                                self.assetCode = value
                            }
                            
                            
                        }
                    }
                    
                    SVProgressHUD.dismiss()
                }
                catch{
                    print (error)
                }
                
            }
            else{
                print("Something Went wrong")
            }
        }
    }

    
    func setEnableDisable(){
        
        if editFlag{
            approvedQuantTF.isEnabled = true
           approvedQuantTF.becomeFirstResponder()
            editBtn.setImage(UIImage(named: "icons8-no-edit-30"), for: .normal)
        }else{
            approvedQuantTF.isEnabled = false
            editBtn.setImage(UIImage(named: "icons8-edit-30"), for: .normal)
        }
        
    }
    
    func getParams(status : String) -> Any{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        
        return ["EmployeeCode":empCode ,"MgrQuantity": approvedQuantTF.text!,"MgrProduct": assetCode,"ProductName": assetLbl.text,"MgrDate": formatter.string(from: Date()),"MgrStatus": status,"MgrRemark": mgrRemarksTF.text!,"RowSeq": rowseq]
        
    }
}
