//
//  ApplyLoanViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੧੬/੧੦/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON
import DatePickerDialog
import DropDown

class ApplyLoanViewController: UIViewController {
    
    var loanCode = [String]()
    var loanName = [String]()
    var loanFullName = [String]()
    
    var deductionDate = Date()
    
    var loanType = ""
    var transacDT = ""
    var deductDT = ""
    var startDeduction = ""
    
    @IBOutlet weak var loanTypeBtn: UIButton!
    @IBAction func loanTypeBtn(_ sender: UIButton) {
        let dropDown = DropDown()
        
        dropDown.dataSource = loanFullName
        dropDown.anchorView = loanTypeBtn
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.loanType = self.loanCode[index]
            self.loanTypeBtn.titleLabel?.text = item
        }
        
    }
    @IBAction func transactionDateBtn(_ sender: UIButton) {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: Date(), datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                self.deductionDate = dt
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                self.transacDT = formatter.string(from: dt)
                self.deductDT = formatter.string(from: dt)
                formatter.dateFormat = "dd-MMMM-yyyy"
                self.transactionDateTF.text = formatter.string(from: dt)
                formatter.dateFormat = "MMMM yyyy"
                self.deductiondateTF.text = formatter.string(from: dt)
                formatter.dateFormat = "MMyyyy"
                self.startDeduction = formatter.string(from: dt)
                
                
            }
        }
    }
    @IBAction func deductionDateBtn(_ sender: UIButton) {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: deductionDate, datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                self.deductDT = formatter.string(from: dt)
                formatter.dateFormat = "MMMM yyyy"
                self.deductiondateTF.text = formatter.string(from: dt)
                formatter.dateFormat = "MMyyyy"
                self.startDeduction = formatter.string(from: dt)
                
                
            }
        }
    }
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var noOfInstallmentsTF: UITextField!
    @IBAction func noOfInstallmentsTF(_ sender: UITextField) {
        
        if noOfInstallmentsTF.text != ""{
            if amountTF.text != ""{
                if Double(noOfInstallmentsTF.text!)! < 100{
                    installmentAmountTF.text =  String(format: "%.2f", Double(amountTF.text!)! / Double(noOfInstallmentsTF.text!)!)
                }else{
                    SVProgressHUD.showError(withStatus: "No of installments can't be more than 99.")
                    SVProgressHUD.dismiss(withDelay: 3)
                    installmentAmountTF.text = ""
                    noOfInstallmentsTF.text = ""
                }
            }else{
                SVProgressHUD.showError(withStatus: "Amount can't be empty.")
                SVProgressHUD.dismiss(withDelay: 3)
            }
        }
    }
    @IBOutlet weak var installmentAmountTF: UITextField!
    @IBOutlet weak var deductiondateTF: UITextField!
    @IBOutlet weak var remarkTF: UITextField!
    @IBOutlet weak var transactionDateTF: UITextField!
    
    @IBAction func submitApplicationBtn(_ sender: UIButton) {
        
        if loanType != "" && amountTF.text != "" && noOfInstallmentsTF.text != "" && installmentAmountTF.text != ""{
            if transacDT != "" && deductDT != ""{

                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
        
                postLoanApplication(params: ["EmployeeCode": defaults.string(forKey: "employeeCode")!,"ApplyAmount": Int(amountTF.text!)!,"ApplyInstallmentAmount": installmentAmountTF.text!,"StartDeduction": startDeduction,"Ltyp": "01","Dtyp": loanType, "Remark": remarkTF.text!,"ApplyNoOfInstallment": noOfInstallmentsTF.text!, "ApplyTransactionDate": formatter.string(from: Date())])
                
            }else{
                SVProgressHUD.showError(withStatus: "Enter valid date")
                SVProgressHUD.dismiss(withDelay: 3)
            }
        }else{
            SVProgressHUD.showError(withStatus: "It seems like you are missing out something.")
            SVProgressHUD.dismiss(withDelay: 3)
        }
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        getLoanType()
        // MARK:-  Listen for keyBoard Events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    
    @objc func keyboardWillChange(notification: Notification){
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -50
        }
        else{
            view.frame.origin.y = 0
        }
    }
    
    
    
    func getLoanType(){
        
        loanCode = [String]()
        loanName = [String]()
        loanFullName = [String]()
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/LoanType", headers: headers).responseJSON{
            response in
            
//            print(headers)
            let lStatusData = response.data!
            let lStatusJSON = response.result.value
            
            if response.result.isSuccess{
//                print(lStatusJSON)
                do{
                    let lStatus = try JSONDecoder().decode(LoanTypeRoot.self, from: lStatusData)
                    
                    for x in lStatus.loanType{
                        if let value = x.code{
                           self.loanCode.append(value)
                        }
                        if let value = x.name{
                            self.loanName.append(value)
                        }
                        if let value = x.fullName{
                            self.loanFullName.append(value)
                        }
                    }
                    
                    
                    
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
    
    
    func postLoanApplication(params : [String:Any]){
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/LoanApply" , method : .post,  parameters : params, encoding: JSONEncoding.default , headers: headers).responseJSON{
            response in
            
            print(params)
            
            let loginJSON : JSON = JSON(response.result.value)
            
            if response.result.isSuccess{
                
                
                if loginJSON["returnType"].string == "Loan Applied Successfully"{
                    SVProgressHUD.showSuccess(withStatus: loginJSON["returnType"].string)
                    self.clearData()
                }
                
            }
                
            else{
                //print("Error: \(response.result.error!)")
                print(loginJSON)
            }
            
        }
    }
    
    
    func clearData(){
        loanType = ""
        transacDT = ""
        deductDT = ""
        startDeduction = ""
        
        loanType = ""
        amountTF.text = ""
        noOfInstallmentsTF.text = ""
        installmentAmountTF.text = ""
        transacDT = ""
        deductDT = ""
        
        transactionDateTF.text = ""
        deductiondateTF.text = ""
        remarkTF.text = ""
        
        loanTypeBtn.titleLabel?.text = "--- Select Loan Type ---"
        
    }
    
    }
    
    



