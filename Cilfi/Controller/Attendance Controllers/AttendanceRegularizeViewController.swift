//
//  AttendanceRegularizeViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੧੫/੧੧/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import UIKit
import DatePickerDialog
import DropDown
import SVProgressHUD
import Alamofire
import SwiftyJSON

class AttendanceRegularizeViewController: UIViewController {
    
    
    var date = ""
    var regularizeType = ""
    
    @IBOutlet weak var selectBtn: UIButton!
    @IBAction func selectBtn(_ sender: UIButton) {
        let dropDown = DropDown()
        
        dropDown.dataSource = ["Work From Home", "On Official Duty - OOD", "Miss Punch", "Tecnical Error"]
        dropDown.anchorView = selectBtn
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            self.selectBtn.setTitle(item, for: .normal)
            self.regularizeType = String(index+1)
        }
    }
    @IBAction func dateBtn(_ sender: UIButton) {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel",maximumDate : Date(), datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MMMM-yyyy"
                self.dateLbl.text = formatter.string(from: dt)
                formatter.dateFormat = "yyyy-MM-dd"
                self.date = formatter.string(from: dt)
                SVProgressHUD.show()
                self.getInOutDetail()
                
            }
        }
    }
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var detailStack: UIStackView!
    @IBOutlet weak var inDetailLbl: UILabel!
    @IBOutlet weak var outDetailLbl: UILabel!
    
    @IBOutlet weak var inTimeLbl: UILabel!
    @IBOutlet weak var outTimeLbl: UILabel!
    
    @IBAction func inTimeBtn(_ sender: UIButton) {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                self.inTimeLbl.text = formatter.string(from: dt)
                
            }
        }
    }
    @IBAction func outTimeBtn(_ sender: Any) {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                self.outTimeLbl.text = formatter.string(from: dt)
                
            }
        }
    }
    
    @IBOutlet weak var remarkLbl: UITextField!
    
    @IBAction func submitBtn(_ sender: UIButton) {
        
        var inTime = inTimeLbl.text!
        var outTime = outTimeLbl.text!
        
        var inRemark = ""
        var outRemark = ""
        
        
        if regularizeType != "" && date != "" {
            if remarkLbl.text != ""{
                if inTime == "Select In Time"{
                    inRemark = ""
                    inTime = ""
                }else{
                    inRemark = remarkLbl.text!
                }
                if outTime == "Select Out Time"{
                    outRemark = ""
                    outTime = ""
                }else{
                    outRemark = remarkLbl.text!
                }
                
                
                saveRegularizeData(params: [ "RegularizeTypeIn": regularizeType, "RegularizeTypeOut": regularizeType, "FromDate": date, "ToDate": date, "InTime": inTime.replacingOccurrences(of: ":", with: "."), "OutTime": outTime.replacingOccurrences(of: ":", with: "."), "StatusIn":"P", "StatusOut":"P", "RemarkIn": inRemark, "RemarkOut" : outRemark])
            }else{
                SVProgressHUD.showError(withStatus: "Please enter valid remarks.")
            }
            
        }else{
            SVProgressHUD.showError(withStatus: "Regularize Type / Date can't be empty.")
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
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
    
    
    
    func getInOutDetail(){
        headers = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "employeeCode")!, "datetime" : date]
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/AttendanceInOutTime", method: .get, headers : headers).responseJSON{
            response in
            
            let attnData = response.data!
            let attnJSON = response.result.value
            
            if response.result.isSuccess{
                
                do{
                    SVProgressHUD.dismiss()
                    let attndTrack = try JSONDecoder().decode(AttendanceInOutRoot.self, from: attnData)
                    //line chart
                    
                    self.inDetailLbl.text = attndTrack.inTime?.replacingOccurrences(of: ".", with: ":")
                    self.outDetailLbl.text = attndTrack.outTime?.replacingOccurrences(of: ".", with: ":")
                    
                    self.detailStack.isHidden = false
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
    
    
    func saveRegularizeData(params : [String:String]){
        
        print(params)
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/RegularizeAttendance" , method : .post,  parameters : params, encoding: JSONEncoding.default , headers: headers).responseJSON{
            response in
            
            //            print(response)
            
            let loginJSON : JSON = JSON(response.result.value)
            
            if response.result.isSuccess{
                print(loginJSON)
                print("Success! Posting the Regularization data")
                
                if loginJSON["returnType"].string == "Regularize Marked Successfully"{
                    SVProgressHUD.showSuccess(withStatus: loginJSON["returnType"].string)
                    self.clearAll()
                }else if loginJSON["returnType"].string == "Regularize Marked Failed"{
                    SVProgressHUD.showError(withStatus: loginJSON["returnType"].string)
                }
                //                print(JSONEncoding())
                //                print(loginJSON)
                //                self.updateLoginData(json : loginJSON)
            }
                
            else{
                //print("Error: \(response.result.error!)")
                print(loginJSON)
            }
            
        }
    }
    
    func clearAll(){
        
        date = ""
        regularizeType = ""
        
        selectBtn.setTitle("--- Select ---", for: .normal)
        
        inTimeLbl.text = "Select In Time"
        outTimeLbl.text = "Select Out Time"
        dateLbl.text = "Select Reimbursement Date"
        remarkLbl.text = ""
        
        detailStack.isHidden = true
        
    }
    
}
