//
//  LoanApproveDetailViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੧੭/੧੦/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class LoanApproveDetailViewController: UIViewController {
    
    var editFlag = false
    
    var rowSeq = ""
    
    var appliedAmnt = 0.0
    var appliedInstallmentAmnt = 0.0
    var appliedNoOfInstallment = 0.0
    
    var empcode = ""
    
    @IBOutlet weak var resetValueBtn: UIButton!
    @IBAction func resetValuesBtn(_ sender: UIButton) {
        managerInstallmentAmntLbl.text = "0.0"
        managerApprovedAmntLbl.text = "0.0"
        managerApprovednoOfInstalmentsLbl.text = "0.0"
    }
    
    @IBOutlet weak var editBtn: UIButton!
    @IBAction func editBtn(_ sender: UIButton) {
        editFlag = !editFlag
        print(editFlag)
        setEnableDisable()
    }
    
    @IBOutlet weak var seqNoLbl: UILabel!
    @IBOutlet weak var empNameLbl: UILabel!
    @IBOutlet weak var loanTypeLbl: UILabel!
    @IBOutlet weak var loanAppliedDateLbl: UILabel!
    @IBOutlet weak var loanAppliedInstallmentAmntLbl: UILabel!
    @IBOutlet weak var loanAppliedAmntLbl: UILabel!
    @IBOutlet weak var loanAppliednoOfInstallmentsLbl: UILabel!
    @IBOutlet weak var applicantsRemarkLbl: UILabel!
    @IBOutlet weak var deductionStartLbl: UILabel!
    
    @IBOutlet weak var managerInstallmentAmntLbl: UITextField!
    @IBOutlet weak var managerApprovedAmntLbl: UITextField!
    @IBOutlet weak var managerApprovednoOfInstalmentsLbl: UITextField!
    @IBOutlet weak var managerRemarksLbl: UITextField!
    
    @IBOutlet weak var rejectApproveStack: UIStackView!
    
    @IBAction func managerApprovednoOfInstalmentsLbl(_ sender: UITextField) {
        if managerApprovednoOfInstalmentsLbl.text != "" {
            if managerApprovedAmntLbl.text != ""{
                if Int(managerApprovednoOfInstalmentsLbl.text!)! < 100{
                     managerInstallmentAmntLbl.text =  String(format: "%.2f", Double(managerApprovedAmntLbl.text!)! / Double(managerApprovednoOfInstalmentsLbl.text!)!)
                }else{
                    SVProgressHUD.showError(withStatus: "No of installments can't be more than 99.")
                    SVProgressHUD.dismiss(withDelay: 3)
                    managerApprovednoOfInstalmentsLbl.text = ""
                    managerInstallmentAmntLbl.text = ""
                }
            }else{
                SVProgressHUD.showError(withStatus: "Amount can't be empty.")
                SVProgressHUD.dismiss(withDelay: 3)
            }
        }
    }
    @IBAction func managerApprovedAmntLbl(_ sender: UITextField) {
        if managerApprovedAmntLbl.text != "" {
            if managerApprovednoOfInstalmentsLbl.text != ""{
               
                managerInstallmentAmntLbl.text =  String(format: "%.2f", Double(managerApprovedAmntLbl.text!)! / Double(managerApprovednoOfInstalmentsLbl.text!)!)
            }
        }
    }
    @IBOutlet weak var rejectAcceptStack: UIStackView!
    
    @IBAction func rejectBtn(_ sender: UIButton) {
        if managerApprovednoOfInstalmentsLbl.text != "" && managerApprovedAmntLbl.text != "" && managerInstallmentAmntLbl.text != ""{
            if managerApprovednoOfInstalmentsLbl.text != "0.0" && managerApprovedAmntLbl.text != "0.0" && managerInstallmentAmntLbl.text != "0.0"{
                setData(status: "R")
                
            }else{
                SVProgressHUD.showInfo(withStatus: "Amount/Installment Amount/No. Of Installments can't be 0 or empty.")
            }
            
            
        }else{
            SVProgressHUD.showInfo(withStatus: "You have missed out something")
        }
    }
    
    @IBAction func acceptBtn(_ sender: UIButton) {
        if managerApprovednoOfInstalmentsLbl.text != "" && managerApprovedAmntLbl.text != "" && managerInstallmentAmntLbl.text != ""{
            if managerApprovednoOfInstalmentsLbl.text != "0.0" && managerApprovedAmntLbl.text != "0.0" && managerInstallmentAmntLbl.text != "0.0"{
                setData(status: "A")
                
            }else{
                SVProgressHUD.showInfo(withStatus: "Amount/Installment Amount/No. Of Installments can't be 0 or empty.")
            }
        }else{
            SVProgressHUD.showInfo(withStatus: "You have missed out something")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        print(rowSeq)
        getLoanApplyData()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    
    func getLoanApplyData(){
        
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/loanapply", headers: headers).responseJSON{
            response in
            
            //            print(headers)
            let lApplyData = response.data!
            let lApplyJSON = response.result.value
            
            if response.result.isSuccess{
                //                print(lStatusJSON)
                do{
                    let lApply = try JSONDecoder().decode(LoanApplyRoot.self, from: lApplyData)
                    //                    print(lApplyJSON)
                    for x in lApply.loanApply{
                        if self.rowSeq == x.rowSeq{
                            if let value = x.seqNo{
                                self.seqNoLbl.text = value
                            }
                            if let value = x.empName{
                                self.empNameLbl.text = value
                            }
                            if let value = x.loanType{
                                self.loanTypeLbl.text = value
                            }
                            if let value = x.applyTransactionDate{
                                self.loanAppliedDateLbl.text = value
                            }
                            if let value = x.applyAmnt{
                                //                                self.appliedAmnt = value
                                self.loanAppliedAmntLbl.text = String(value)
                                //                                self.managerApprovedAmntLbl.text = String(value)
                            }
                            if let value = x.applyNoOfInstallment{
                                //                                self.appliedNoOfInstallment = value
                                self.loanAppliednoOfInstallmentsLbl.text = String(value)
                                //                                self.managerApprovednoOfInstalmentsLbl.text = String(value)
                            }
                            if let value = x.applyInstallmentAmount{
                                //                                self.appliedInstallmentAmnt = value
                                self.loanAppliedInstallmentAmntLbl.text = String(value)
                                //                                self.managerInstallmentAmntLbl.text = String(value)
                            }
                            if let value = x.remark{
                                self.applicantsRemarkLbl.text = value
                            }
                            if let value = x.mgrStatus{
                                if value == "Pending"{
                                    self.rejectAcceptStack.isHidden = false
                                    self.resetValueBtn.isHidden = false
                                    self.editBtn.isHidden = false
                                    self.managerRemarksLbl.isEnabled = true
                                    self.deductionStartLbl.textColor = UIColor.flatOrange
                                    
                                    if let value = x.applyAmnt{
                                        
                                        self.managerApprovedAmntLbl.text = String(value)
                                        
                                    }
                                    if let value = x.applyNoOfInstallment{
                                        
                                        self.managerApprovednoOfInstalmentsLbl.text = String(value)
                                        
                                    }
                                    if let value = x.applyInstallmentAmount{
                                        
                                        self.managerInstallmentAmntLbl.text = String(value)
                                        
                                    }
                                }else if value == "Approved"{
                                    self.editBtn.isHidden = true
                                    self.resetValueBtn.isHidden = true
                                    self.managerRemarksLbl.isEnabled = false
                                    self.deductionStartLbl.textColor = UIColor.flatGreen
                                    
                                    if let value = x.mgrAmnt{
                                        self.managerApprovedAmntLbl.text = String(value)
                                    }
                                    
                                    if let value = x.mgrNoOfInstallment{
                                        self.managerApprovednoOfInstalmentsLbl.text = String(value)
                                    }
                                    
                                    if let value = x.mgrInstallmentAmount{
                                        self.managerInstallmentAmntLbl.text = String(value)
                                    }
                                    
                                }else if value == "Rejected"{
                                    self.resetValueBtn.isHidden = true
                                    self.deductionStartLbl.textColor = UIColor.flatRed
                                    self.editBtn.isHidden = true
                                    self.managerRemarksLbl.isEnabled = false
                                    
                                    if let value = x.mgrAmnt{
                                        self.managerApprovedAmntLbl.text = String(value)
                                    }
                                    
                                    if let value = x.mgrNoOfInstallment{
                                        self.managerApprovednoOfInstalmentsLbl.text = String(value)
                                    }
                                    
                                    if let value = x.mgrInstallmentAmount{
                                        self.managerInstallmentAmntLbl.text = String(value)
                                    }
                                    
                                }
                                self.deductionStartLbl.text = value
                            }
                            
                            
                            if let value = x.empCode{
                                self.empcode = value
                            }
                            
                            
                            
                            
                        }
                        
                    }
                    
                }catch{
                    print (error)
                }
                
            }
            else{
                print("Something Went wrong")
            }
        }
    }
    
    func setData( status: String){
        
        let loan = LoanApprovalModel()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        loan.setLoanApprovalModal(params: ["loanData":[["EmployeeCode":empcode,"MgrAmount":Double(managerApprovedAmntLbl.text!)!,"MgrInstallmentAmount":Double(managerInstallmentAmntLbl.text!)!,"MgrNoOfInstallment":Double(managerApprovednoOfInstalmentsLbl.text!)!,"MgrRemark":"","MgrStatus":status,"MgrTransactionDate":formatter.string(from: Date()),"RowSeq":self.rowSeq]]], completion: { (returnType) in
            
            print(returnType.string)
            if returnType.string == "Loan approved successfully" || returnType.string == "Loan rejected successfully"{
                SVProgressHUD.showSuccess(withStatus: returnType.string)
                self.getLoanApplyData()
                self.navigationController?.popViewController(animated: true)
            }else{
                
                SVProgressHUD.showError(withStatus: returnType.string)
            }
            
            
            
        })
        
    }
    
    func setEnableDisable(){
        
        if editFlag{
            managerApprovednoOfInstalmentsLbl.isEnabled = true
            managerApprovedAmntLbl.isEnabled = true
            //            managerInstallmentAmntLbl.isEnabled = true
            editBtn.setImage(UIImage(named: "icons8-no-edit-30"), for: .normal)
        }else{
            managerApprovednoOfInstalmentsLbl.isEnabled = false
            managerApprovedAmntLbl.isEnabled = false
            //            managerInstallmentAmntLbl.isEnabled = false
            editBtn.setImage(UIImage(named: "icons8-edit-30"), for: .normal)
        }
    }
    
}
