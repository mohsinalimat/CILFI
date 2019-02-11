//
//  AssetsIssueDetailsViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੨੩/੧੦/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class AssetsIssueDetailsViewController: UIViewController {

    var rowseq = ""
    var atype = "A"
    let assets = AssetsApprovalModel()
    var empCode = ""
    var assetCode = ""
    
    var editFlag = false
    
    var header = [String:String]()
    
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var assetLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var approvedQuantityTF: UITextField!
    @IBAction func approvedQuantityTF(_ sender: UITextField) {
        
        if approvedQuantityTF.text != ""{
            
            if Int(approvedQuantityTF.text!)! <= Int(quantityLbl.text!)! && Int(approvedQuantityTF.text!)! >= 1 {
                editFlag = !editFlag
                
                setEnableDisable()
            }else{
                approvedQuantityTF.text = quantityLbl.text
                SVProgressHUD.showError(withStatus: "You can only approve quantity not more than \(quantityLbl.text!)")
                approvedQuantityTF.becomeFirstResponder()
            }
            
            
        }else{
            SVProgressHUD.showError(withStatus: "Quantity can't be empty.")
            approvedQuantityTF.becomeFirstResponder()
        }
        
        
    }
    @IBOutlet weak var editBtn: UIButton!
    @IBAction func editBtn(_ sender: UIButton) {
        
        editFlag = !editFlag
        setEnableDisable()
    }
    @IBOutlet weak var applyDateLbl: UILabel!
    @IBOutlet weak var approvedDateLbl: UILabel!
    @IBOutlet weak var remarkLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var issuerRemarkTF: UITextField!
    
    @IBOutlet weak var acceptRejectStack: UIStackView!
    @IBAction func rejectBtn(_ sender: UIButton) {
        assets.setIssueData(assetType: atype, params: [self.getParams(status : "R")], completion: { (returnType) in
            if returnType.string == "Rejected successfully"{
                SVProgressHUD.showSuccess(withStatus: returnType.string)
                self.navigationController?.popViewController(animated: true)
            }else{
                SVProgressHUD.showError(withStatus: returnType.string)
            }
        })
    }
    @IBAction func approveBtn(_ sender: UIButton) {
        
        assets.setIssueData(assetType: atype, params: [self.getParams(status : "A")], completion: { (returnType) in
            if returnType.string == "Issued successfully"{
                SVProgressHUD.showSuccess(withStatus: returnType.string)
                self.navigationController?.popViewController(animated: true)
            }else{
                SVProgressHUD.showError(withStatus: returnType.string)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SVProgressHUD.show()
        hideKeyboardWhenTappedAround()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        header =  [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "employeeCode")!, "assetsType" : atype]
        
        
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
                            if let value = x.mgrQuantity{
                                self.quantityLbl.text = String(value)
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
                            if let value = x.paidStatus{
                                if value == "Pending"{
                                    self.approvedQuantityTF.text = String(x.mgrQuantity!)
                                    self.editBtn.isHidden = false
                                    self.acceptRejectStack.isHidden = false
                                    self.issuerRemarkTF.isEnabled = true
                                }else{
                                    self.approvedQuantityTF.text = String(x.quantity!)
                                    self.editBtn.isHidden = true
                                    self.acceptRejectStack.isHidden = true
                                     self.issuerRemarkTF.isEnabled = false
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
            approvedQuantityTF.isEnabled = true
            approvedQuantityTF.becomeFirstResponder()
            editBtn.setImage(UIImage(named: "icons8-no-edit-30"), for: .normal)
        }else{
            approvedQuantityTF.isEnabled = false
            editBtn.setImage(UIImage(named: "icons8-edit-30"), for: .normal)
        }
        
    }
    
    func getParams(status : String) -> Any{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        
        return ["EmployeeCode":empCode ,"Quantity": approvedQuantityTF.text!,"Product": assetCode,"ProductName": assetLbl.text,"ApplyDate": formatter.string(from: Date()),"PaidStatus": status,"PaidRemark": issuerRemarkTF.text!,"RowSeq": rowseq]
        
    }

  
}
