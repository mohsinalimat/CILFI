//
//  RegularizeAttendanceViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 15/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import DropDown
import DatePickerDialog
import Alamofire
import SwiftyJSON
import SVProgressHUD
class RegularizeAttendanceViewController: UIViewController {
    let regularizeURL = "\(LoginDetails.hostedIP)/sales/RegularizeAttendance"
    var regularizeType = ""
    var fDate = ""
    var tDate = ""
   
    var minimumToDate = Date()
    
    var iTime = ""
    var iTimeHour = ""
    var iTimeMinute = ""
    var oTime = ""
    var oTimeHour = ""
    var oTimeMinute = ""
    
    @IBOutlet weak var reasonType: UIButton!
    @IBOutlet weak var fromDate: UILabel!
    @IBOutlet weak var toDate: UILabel!
    @IBOutlet weak var fromTime: UILabel!
    @IBOutlet weak var toTime: UILabel!
    @IBOutlet weak var inRemarks: UITextField!
    @IBOutlet weak var outRemarks: UITextField!
    
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
    
    
    @IBAction func reasonType(_ sender: UIButton) {
        let dropDown = DropDown()
        
        dropDown.dataSource = ["Work From Home", "On Official Duty - OOD", "Miss Punch", "Tecnical Error"]
        dropDown.anchorView = reasonType
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            self.reasonType.setTitle(item, for: .normal)
            self.regularizeType = String(index+1)
        }
    }
    
    
    @IBAction func fromDateBtn(_ sender: UIButton) {
        
       let dte = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel",maximumDate : Date(), datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                self.minimumToDate = dt
                formatter.dateFormat = "dd-MM-yyyy"
                self.fromDate.text = formatter.string(from: dt)
                formatter.dateFormat = "yyyy-MM-dd"
                self.fDate = formatter.string(from: dt)
            }
        }
    }
    
    @IBAction func toDateBtn(_ sender: UIButton) {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel",minimumDate : minimumToDate, maximumDate : Date(), datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                self.toDate.text = formatter.string(from: dt)
                formatter.dateFormat = "yyyy-MM-dd"
                self.tDate = formatter.string(from: dt)
            }
        }
    }
    
    @IBAction func inTime(_ sender: UIButton) {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm a"
                self.fromTime.text = formatter.string(from: dt)
                
                formatter.dateFormat = "HH"
                self.iTimeHour = formatter.string(from: dt)
                
                formatter.dateFormat = "mm"
                self.iTimeMinute = formatter.string(from: dt)
            
                self.iTime = "\(self.iTimeHour).\(self.iTimeMinute)"
            }
        }
        
    }
    
    @IBAction func outTime(_ sender: UIButton) {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm a"
                self.toTime.text = formatter.string(from: dt)
                formatter.dateFormat = "HH"
                self.oTimeHour = formatter.string(from: dt)
                
                formatter.dateFormat = "mm"
                self.oTimeMinute = formatter.string(from: dt)
                
                self.oTime = "\(self.oTimeHour).\(self.oTimeMinute)"
            }
        }
    }
    
    
    @IBAction func submitBtn(_ sender: UIButton) {
        var flag = 0
        
        if regularizeType != ""{
            flag += 1
        }else{alert(title: "Invalid", message: "Invalid regularize type.")}
        
        if fDate != "" && tDate != ""{
            flag += 1
        }else{alert(title: "Invalid Date", message: "You missed out date.")}
        
        if iTime != "" && oTime != ""{
            flag += 1
        }else{alert(title: "Invalid Time", message: "You missed out Time")}
        
        if flag == 3{
            let parameters : [String:String] = [ "RegularizeTypeIn": regularizeType, "RegularizeTypeOut": regularizeType, "FromDate": fDate, "ToDate": tDate, "InTime": iTime, "OutTime": oTime, "StatusIn":"P", "StatusOut":"P", "RemarkIn": inRemarks.text!, "RemarkOut" : (reasonType.titleLabel?.text)!]
            
            setRegularizeData(url: regularizeURL, header: headers, parameter: parameters)
        }else{
            print (flag)
            print("flag not 3")
        }
    }
    
    @IBAction func attendanceSummaryBtn(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToAttendanceSummary", sender: self)
    }
    
    
    func alert(title : String , message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the setAttendanceData method here:
    
    func setRegularizeData(url : String, header : [String:String], parameter : [String:String]){
        
        
                print(parameter)
        Alamofire.request(url , method : .post,  parameters : parameter, encoding: JSONEncoding.default , headers: header).responseJSON{
            response in
            
            //            print(response)
            
            let loginJSON : JSON = JSON(response.result.value)
            
            if response.result.isSuccess{
                print(loginJSON)
                print("Success! Posting the Regularization data")
                
                if loginJSON["returnType"].string == "Regularize Mark Successfully"{
                    SVProgressHUD.showSuccess(withStatus: "Regularize Mark Successfully")
                    self.clearAll()
                }else if loginJSON["returnType"].string == "Regularize Mark Failed"{
                    SVProgressHUD.showError(withStatus: "Regularize Mark Failed. Check date again.")
                }
                //                print(JSONEncoding())
                //                               print(loginJSON)
                //                self.updateLoginData(json : loginJSON)
            }
                
            else{
                //print("Error: \(response.result.error!)")
                print(loginJSON)
            }
            
        }
    }
    
    
    func clearAll(){
        regularizeType = ""
        fDate = ""
        tDate = ""
        iTime = ""
        oTime = ""
        
        reasonType.setTitle("--- Select ---", for: .normal)
        fromDate.text = "From Date"
        toDate.text = "To Date"
        fromTime.text = "From Time"
        toTime.text = "To Time"
        inRemarks.text = ""
        outRemarks.text = ""
        
       
    }
}
