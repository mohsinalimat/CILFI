//
//  ReimbursementDetailsViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੮/੧੦/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class ReimbursementDetailsViewController: UIViewController {

    let reimburseApprove = ReimbursementApprovalModel()
    
    
    var rowSeq = ""
    
    var dType = ""
    var empCode = ""
    var expenseDate = ""
    var lType = ""
    var rate = ""
    
    @IBOutlet weak var kmsStack: UIStackView!
    @IBOutlet weak var trackingStack: UIStackView!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var reimType: UILabel!
    @IBOutlet weak var kmsTF: UITextField!
    @IBAction func kmsTF(_ sender: UITextField) {
        kmsTF.isEnabled = false
    }
    
    
    @IBOutlet weak var kmsEditBtn: UIButton!
    @IBAction func kmsEditBtn(_ sender: UIButton) {
        kmsTF.isEnabled = true
        kmsTF.becomeFirstResponder()
    }
    @IBOutlet weak var trackKmsLbl: UILabel!
    @IBOutlet weak var totalAmmntTF: UITextField!
    
    @IBAction func totalAmmntTF(_ sender: UITextField) {
        totalAmmntTF.isEnabled = false
    }
    @IBOutlet weak var totalAmmntEditBtn: UIButton!
    @IBAction func totalAmmntEditBtn(_ sender: UIButton) {
        totalAmmntTF.isEnabled = true
        totalAmmntTF.becomeFirstResponder()
    }
    @IBOutlet weak var claimDateLbl: UILabel!
    @IBOutlet weak var remarksLbl: UILabel!
    @IBOutlet weak var mgrStatusLbl: UILabel!
    @IBOutlet weak var mgrRemarksTF: UITextField!
    
    @IBOutlet weak var acceptRejectView: UIView!
    @IBAction func rejectBTn(_ sender: UIButton) {
    
        if totalAmmntTF.text != "" && kmsTF.text != ""{
            
            reimburseApprove.status(dType: dType, empCode: empCode, expensedate: expenseDate, ltype: lType, mgrremarks: mgrRemarksTF.text!, mgrStatus: "N", rowseq: rowSeq, approvedAmmount: totalAmmntTF.text!, approvedKms: kmsTF.text!, completion:{(returnType) in
                
                if returnType == "Reimbursement rejected successfully" || returnType == "Reimbursement approved successfully"{
                    SVProgressHUD.showSuccess(withStatus: returnType)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    SVProgressHUD.showError(withStatus: returnType)
                }
                
                
            })
            
        }else{
            
            SVProgressHUD.showError(withStatus: "Please enter valid Amount/KMs.")
            
            
        }
        
       
    
    
    }
    
    @IBAction func approveBtn(_ sender: UIButton) {
    
        if totalAmmntTF.text != "" && kmsTF.text != ""{
            
            reimburseApprove.status(dType: dType, empCode: empCode, expensedate: expenseDate, ltype: lType, mgrremarks: mgrRemarksTF.text!, mgrStatus: "Y", rowseq: rowSeq, approvedAmmount: totalAmmntTF.text!, approvedKms: kmsTF.text!, completion:{(returnType) in
                
                if returnType == "Reimbursement rejected successfully" || returnType == "Reimbursement approved successfully"{
                    SVProgressHUD.showSuccess(withStatus: returnType)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    SVProgressHUD.showError(withStatus: returnType)
                }
                
                
            })
            
        }else{
            
            SVProgressHUD.showError(withStatus: "Please enter valid Amount/KMs.")
            
            
        }
        
    
    
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        
        hideKeyboardWhenTappedAround()
        
        getReimData()
        
        kmsTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    func getReimData(){
        
                Alamofire.request("\(LoginDetails.hostedIP)/sales/ReimbursementDetail", headers: headers).responseJSON{
                    response in
        
        
                    let rStatusData = response.data!
                    let rStatusJSON = response.result.value
        
                    if response.result.isSuccess{
        //                print(rStatusJSON)
                        do{
                            let rDetail = try JSONDecoder().decode(ReimbursementDetailRoot.self, from: rStatusData)
        
                            for x in rDetail.rInfo{
        
                                if self.rowSeq == x.rowSeq{
                                    
                                    
                                    
                                    if let value = x.rType{
                                        if value == "K" || value == "k"{
                                            self.kmsStack.isHidden = false
                                            self.trackingStack.isHidden = false
                                            self.kmsEditBtn.isHidden = false
                                        }else if value == "O" || value == "o"{
                                            self.totalAmmntEditBtn.isHidden = false
                                        }
                                    }
                                    
                                    if let value = x.empname{
                                        self.nameLbl.text = value
                                    }
                                    if let value = x.reimbursetype{
                                        self.reimType.text = value
                                    }
                                    /////////////////////////////////
                                    if let value = x.kms{
                                        self.kmsTF.text = String(value)
                                    }
                                    
                                    if let value = x.approvedKMS{
                                        if value != 0{
                                            self.kmsTF.text = String(value)
                                        }
                                        
                                    }
                                    
                                    if let value = x.trackedKms{
                                        self.trackKmsLbl.text = String(value)
                                    }
                                    ////////////////////////
                                    if let value = x.amnt{
                                        self.totalAmmntTF.text = value
                                    }
                                    
                                    if let value = x.approvedAmmount{
                                        if value != 0{
                                            self.totalAmmntTF.text = String(value)
                                        }
                                        
                                    }
                                    
                                    if let value = x._expenseDate{
                                        
                                        let formatter = DateFormatter()
                                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                                        if let date = formatter.date(from: value){
                                            formatter.dateFormat = "dd-MMMM-yyyy"
                                            self.claimDateLbl.text = formatter.string(from: date)
                                            formatter.dateFormat = "yyyy-MM-dd"
                                            self.expenseDate = formatter.string(from: date)
                                        }
                                    }
                                    if let value = x.remark{
                                        self.remarksLbl.text = value
                                    }
                                    if let value = x.mgrstatus{
                                        if value == "Approved" || value == "Rejected"{
                                            self.kmsEditBtn.isHidden = true
                                            self.totalAmmntEditBtn.isHidden = true
                                            
                                            if let remark = x.mgrremark{
                                                self.mgrRemarksTF.text = remark
                                            }
                                            
                                            self.mgrRemarksTF.isEnabled = false
                                            
                                        }else{
                                            self.acceptRejectView.isHidden = false
                                        }
                                        self.mgrStatusLbl.text = value
                                    }
                                    
                                    
                                    
                                    // Variables for parameters
                                    if let value = x.dtype{
                                        self.dType = value
                                    }
                                    if let value = x.ltype{
                                        self.lType = value
                                    }
                                    if let value = x.empcode{
                                        self.empCode = value
                                    }
                                    if let value = x.empcode{
                                        self.empCode = value
                                    }
                                    if let value = x.rate{
                                        self.rate = value
                                    }
                                    
                                }
        
                            }
                            
                            SVProgressHUD.dismiss()
                            }catch{
                            
                        }
        
                    }
                    else{
                        print("Something Went wrong")
                    }
                }
        
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if self.rate != ""{
            if kmsTF.text != ""{
                 totalAmmntTF.text = String(Double(rate)! * Double(kmsTF.text!)!)
            }
           
        }
        
    }
    
}
