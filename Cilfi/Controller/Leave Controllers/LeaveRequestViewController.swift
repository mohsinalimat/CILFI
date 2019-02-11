//
//  LeaveRequestViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 04/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Alamofire
import DropDown
import DatePickerDialog
import SwiftyJSON
import SVProgressHUD

class LeaveRequestViewController: UIViewController {

    var minimumDate = Date()
    
    let getLeavesNameUrl = "\(LoginDetails.hostedIP)/sales/GetLeaveNames"
    let leaveSummaryURL = "\(LoginDetails.hostedIP)/sales/LeaveSummary"
    let leaveRequestURL = "\(LoginDetails.hostedIP)/sales/LeaveRequest"
    let dropDown = DropDown()
    let headers : [String:String] = ["username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "user")!]
    let day = ["Full Day", "First Half", "Second Half"]
    var leaveNames = [String]()
    var leaveType = [String]()
    let leaveReq = LeaveRequestModel()
    
    
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var leaveTypeView: DropDown!
    @IBOutlet weak var fromDropDown: DropDown!
    @IBOutlet weak var toDropDown: DropDown!
    @IBOutlet weak var sickLeaveButton: UIButton!
    @IBOutlet weak var fromButton: UIButton!
    @IBOutlet weak var toButton: UIButton!
    @IBOutlet weak var reasonTf: UITextField!
    @IBOutlet weak var remarksTf: UITextField!
    @IBOutlet weak var attachmentTf: UITextField!
    @IBOutlet weak var earnLeaveLabel: UILabel!
    @IBOutlet weak var casualLeaveLabel: UILabel!
    @IBOutlet weak var sickLeaveLabel: UILabel!
    @IBOutlet weak var maternityLeaveLabel: UILabel!
    
    @IBAction func myLeavesButton(_ sender: UIButton) {
    
    performSegue(withIdentifier: "goToMyLeaves", sender: self)
    }
    
    
    @IBAction func applyLeave(_ sender: UIButton) {
       
        if leaveReq.leaveType != nil && leaveReq.fromDate != nil && leaveReq.toDate != nil && leaveReq.fromDateHalf != nil && leaveReq.toDateHalf != nil && reasonTf.text != ""{
           
            let parameters : [String:Any] = ["EmpCode" : leaveReq.empcode!, "LeaveType": leaveReq.leaveType! ,"FromDate":leaveReq.fromDate!,"ToDate":leaveReq.toDate!,"Reason":reasonTf.text!,"Remarks":remarksTf.text!,"FromDateHalf":leaveReq.fromDateHalf!,"ToDateHalf":leaveReq.toDateHalf!,"RequestDate":leaveReq.requestDate!,"AttachmentType":leaveReq.attachmentType,"Attachment":leaveReq.attachment]
            
            
          setLeaveReqData(url: leaveRequestURL, header: headers, parameter: parameters)
            print(parameters)
        }
        else
            {
                let alert = UIAlertController(title: "Unable to apply for leave", message: "It seems you have missing something.", preferredStyle: UIAlertController.Style.alert)
            
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
                self.present(alert, animated: true, completion: nil)
                
            }
        
       
        
        
        //        {"EmpCode":"R35","LeaveType":"EL","FromDate":"2017-11-01",
        //    "ToDate":"2017-11-12","Reason":"sick leave","Remarks":"earn leave","FromDateHalf":"1","ToDateHalf":"2","RequestDate":"2018/01/17","AttachmentType": ".jpg","Attachment":""}
        
        
        
    }
    @IBAction func toDatePicker(_ sender: UIButton) {
    
        
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: minimumDate,datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MMMM-yyyy"
                
                self.toLabel.text = formatter.string(from: dt)
                formatter.dateFormat = "yyyy-MM-dd"
                self.leaveReq.toDate = formatter.string(from: dt)
            }
        }
        
    }
    @IBAction func fromDatePicker(_ sender: UIButton) {
        
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: Date(), datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MMMM-yyyy"
                self.minimumDate = dt
                self.fromLabel.text = formatter.string(from: dt)
                formatter.dateFormat = "yyyy-MM-dd"
                self.leaveReq.fromDate = formatter.string(from: dt)
            }
        }
    
    }
    
    @IBAction func toButton(_ sender: UIButton) {
        
        dropDown.dataSource = day
        dropDown.anchorView = toDropDown
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            self.toButton.setTitle(item, for: .normal)
            self.leaveReq.toDateHalf = String(index+1)
        }
    }
    @IBAction func fromButton(_ sender: UIButton) {
        dropDown.dataSource = day
        dropDown.anchorView = fromDropDown
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            self.fromButton.setTitle(item, for: .normal)
            self.leaveReq.fromDateHalf = String(index+1)
        }
        
    }
    @IBAction func sickLeaveButton(_ sender: UIButton) {
    
        if leaveNames.isEmpty{
            print("Leave Names Empty")
        }
        else{
        dropDown.dataSource = leaveNames
        dropDown.anchorView = sickLeaveButton
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            self.sickLeaveButton.setTitle(item, for: .normal)
            self.leaveReq.leaveType = self.leaveType[index]

            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        leaveReq.requestDate = formatter.string(from: date)
        
        leaveReq.empcode = defaults.string(forKey: "employeeCode")
        hideKeyboardWhenTappedAround()
        getLeavesName(url: getLeavesNameUrl, header: headers)
        getLeaveSummary(url: leaveSummaryURL, header: headers)
    }

    //MARK: - Networking
    /***************************************************************/
    
    //Write the getLeavesName for dropdown method here:
    func getLeavesName(url : String, header : [String:String]){
      
        Alamofire.request(url, method: .get, headers : headers).responseJSON{
            response in
            
            let leaveNamesData = response.data!
            let leaveNamesJSON = response.result.value
            if response.result.isSuccess{
//                print(leaveNamesJSON)
                do{
                    let leave = try JSONDecoder().decode(LeaveNamesRoot.self, from: leaveNamesData)
                    
                    
                    for x in leave.leaveNames{
                        if let leaveDetail = x.leaveDetail{
                        self.leaveNames.append(x.leaveDetail!)
                    } else {print("Unable to fetch data")}
                   }
                    
                    for x in leave.leaveNames{
                        if let leaveType = x.leaveType{
                            self.leaveType.append(x.leaveType!)
                        } else {print("Unable to fetch data")}
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
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getLeaveSummary method here:
    func getLeaveSummary(url : String, header : [String:String]){
        
      
        Alamofire.request(url, method: .get, headers : header).responseJSON{
            response in
            //            var times = [String]()
            //            var addresss = [String]()
            
            let leaveSummaryData = response.data!
            let leaveSummaryJSON = response.result.value
            if response.result.isSuccess{
//                                print("LeaveSummaryJSON: \(leaveSummaryJSON)")
                do{
                    let leaveSummary = try JSONDecoder().decode(LeaveSummaryRoot.self, from: leaveSummaryData)
                    
                    for x in leaveSummary.leaveSummary{
                        if let summary = x.leaveType{
                            if let closing = x.closing{
                                if summary == "EARN LEAVE"
                                {
                                    self.earnLeaveLabel.text = closing
                                }
                                else if summary == "CASUAL LEAVE"
                                {
                                    self.casualLeaveLabel.text = closing
                                }
                                else if summary == "SICK LEAVE"
                                {
                                    self.sickLeaveLabel.text = closing
                                }
                                else if summary == "MATERNITY LEAVE"
                                {
                                    self.maternityLeaveLabel.text = closing
                                }
                                
                                
                            }
                        
                            
                        }
                        else {
                            print ("Unable to fetch Leave Summary.")
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
    
    
    
    func setLeaveReqData(url : String, header : [String:String], parameter : [String:Any]){
        
        
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON{
            response in
            
            
            
            //
            let loginJSON : JSON = JSON(response.result.value)
            
            if response.result.isSuccess{
                if loginJSON["returnType"].string == "Leave Applied Successfully"{
                    SVProgressHUD.showSuccess(withStatus: loginJSON["returnType"].string)
                    self.clearData()
                }else{
                     SVProgressHUD.showError(withStatus: loginJSON["returnType"].string)
                }
                
                
            }
                
            else{
                //print("Error: \(response.result.error!)")
                print(loginJSON)
                
                
                // create the alert
                let alert = UIAlertController(title: "Failed!", message: "Unable to posted your leave request.", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        
       
        
    }
    
    
   
    
    func clearData(){
        
        
        leaveReq.leaveType = nil
        leaveReq.fromDate = nil
        leaveReq.toDate = nil
        leaveReq.fromDateHalf = nil
        leaveReq.toDateHalf = nil
        reasonTf.text = ""
        remarksTf.text = ""
        
        fromLabel.text = "From (dd MM yy)"
        toLabel.text = "To (dd MM yy)"
        sickLeaveLabel.text = ""
        
        toButton.setTitle("Select your option", for: .normal)
        fromButton.setTitle("Select your option", for: .normal)
        sickLeaveButton.setTitle("Select Leave Type", for: .normal)
        
    }
    
}

