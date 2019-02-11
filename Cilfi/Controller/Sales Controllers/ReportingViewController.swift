//
//  ReportingViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 06/08/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import DatePickerDialog
import DropDown
import SVProgressHUD
import Alamofire
import SwiftyJSON

class ReportingViewController: UIViewController {
    
    let report = ReportingModel()
    let customer = CustomerModel()
    
    var reportDate = Date()
    
    @IBOutlet weak var executiveCodeLbl: UILabel!
    @IBOutlet weak var executiveNameLbl: UILabel!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var visitDateLbl: UILabel!
    @IBOutlet weak var reportDateLbl: UILabel!
    @IBOutlet weak var reportLocationTV: UITextView!
    @IBOutlet weak var visitPurposeTF: UITextField!
    @IBOutlet weak var visitTaskTF: UITextField!
    @IBOutlet weak var visitAccomplishedTF: UITextField!
    @IBOutlet weak var targetDateLbl: UILabel!
    @IBOutlet weak var nextFollowupLbl: UILabel!
    @IBOutlet weak var customerNameBtn: UIButton!
    
    @IBAction func visitDateBtn(_ sender: UIButton) {
    
    
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: Date(), datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
            
                self.reportDate = dt
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                self.visitDateLbl.text = formatter.string(from: dt)
                formatter.dateFormat = "yyyy-MM-dd"
                self.report.visitDate = formatter.string(from: dt)
            }
        }
    }
    
    @IBAction func reportDateBtn(_ sender: UIButton) {
        
       DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: reportDate, datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                self.reportDateLbl.text = formatter.string(from: dt)
                formatter.dateFormat = "yyyy-MM-dd"
                self.report.reportDate = formatter.string(from: dt)
            }
        }
    }
    
    @IBAction func targetDateBtn(_ sender: UIButton) {
        
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: Date(), datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                self.targetDateLbl.text = formatter.string(from: dt)
                formatter.dateFormat = "yyyy-MM-dd"
                self.report.targetDate = formatter.string(from: dt)
            }
        }
    }
    
    @IBAction func nextFollowupDateBtn(_ sender: UIButton) {
        
       DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: Date(), datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                self.nextFollowupLbl.text = formatter.string(from: dt)
                formatter.dateFormat = "yyyy-MM-dd"
                self.report.nextFollowupDate = formatter.string(from: dt)
            }
        }
    }
    
    @IBAction func customerNameBtn(_ sender: UIButton) {
        let dropDown = DropDown()
        
        dropDown.dataSource = customer.custName
        dropDown.anchorView = customerNameBtn
        dropDown.direction = .bottom
        // Top of drop down will be below the anchorView
        dropDown.bottomOffset = CGPoint(x: 0, y:30)
        dropDown.dismissMode = .onTap
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.flatWhite
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        DropDown.appearance().cellHeight = 40
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            
            self.customerNameBtn.setTitle(item, for: .normal)
            self.report.customerName = self.customer.custCode[index]
            
        }
        
    }
    
    @IBAction func submitBtn(_ sender: UIButton) {
        
        if report.customerName == "" ||  visitPurposeTF.text == "" || visitTaskTF.text == "" || visitAccomplishedTF.text == ""{
            SVProgressHUD.showError(withStatus: "Please fill all values first.")
            SVProgressHUD.dismiss(withDelay: 3)
        }else{
            
            let parameters = ["ExecutiveCode":report.executiveCode,"Designation":report.desig,"VisitDate":report.visitDate,"ReportDate":report.reportDate,"ReportLocation":report.reportLocation,"CustomerAccount":report.customerName,"VisitPurpose":visitPurposeTF.text!,"VisitTask":visitTaskTF.text!,"VisitAchieved":visitAccomplishedTF.text!,"TargetDate":report.targetDate,"NextDate":report.nextFollowupDate]
            SVProgressHUD.show()
            
            postReportingData(params : parameters)
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        
        hideKeyboardWhenTappedAround()
        currentLocationAddress()
        customer.getCustomerData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let date = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-yyyy"
        
        visitDateLbl.text = dateformatter.string(from: date)
        reportDateLbl.text = dateformatter.string(from: date)
        targetDateLbl.text = dateformatter.string(from: date)
        nextFollowupLbl.text = dateformatter.string(from: date)
        
        report.visitDate = dateformatter.string(from: date)
        report.reportDate = dateformatter.string(from: date)
        report.targetDate = dateformatter.string(from: date)
        report.nextFollowupDate = dateformatter.string(from: date)
        
        executiveCodeLbl.text = report.executiveCode
        executiveNameLbl.text = report.executiveName
        designationLbl.text = report.desig
        
        reportLocationTV.text = currentAddress
        report.reportLocation = currentAddress
        
        SVProgressHUD.dismiss()
    }
    
    
    func postReportingData(params : [String:String]){
        
        
        print(params)
        
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/VisitingReport", method : .post,  parameters : params, encoding: JSONEncoding.default , headers: headers).responseJSON{
            response in
            
            //            print(response)
            
            let loginJSON : JSON = JSON(response.result.value)
            
            if response.result.isSuccess{
                print(loginJSON)
                
                
                                if loginJSON["returnType"].string == "Visiting Report Placed Successfully"{
                                    SVProgressHUD.showSuccess(withStatus: loginJSON["returnType"].string)
                                    _ = self.navigationController?.popViewController(animated: true)
                                }else if loginJSON["returnType"].string == "Regularize Mark Failed"{
                                    SVProgressHUD.showError(withStatus: loginJSON["returnType"].string)
                                }
                
                            }
                
                            else{
                
                                print(loginJSON)
                            }
            
            }
        }
    
    
    
    //   {"ExecutiveCode":"00033","Designation":"GM","VisitDate":"2018-05-21","ReportDate":"2018-05-21","ReportLocation":"Vikas Surya Plaza, Sector -3, Mangalam Place, Sector 3, Rohini, Delhi, 110085, India","CustomerAccount":"16A148","VisitPurpose":"tyy","VisitTask":"fh","VisitAchieved":"no","TargetDate":"2018-05-21","NextDate":"2018-05-21"}
}
