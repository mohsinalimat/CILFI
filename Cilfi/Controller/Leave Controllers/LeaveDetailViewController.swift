//
//  LeaveDetailViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 06/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class LeaveDetailViewController: UIViewController {
    
    let setDataURL = "\(LoginDetails.hostedIP)/sales/LeaveApproval"
    let dataURL = "\(LoginDetails.hostedIP)/sales/LeaveDetail"
    let headers : [String:String] = ["username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "employeeCode")!]
    let date = Date()
    let formatter = DateFormatter()
    
    
    
    
    @IBOutlet weak var managerRemarkslbl: UITextField!
    @IBOutlet weak var managerStatuslbl: UILabel!
    @IBOutlet weak var remarklbl: UILabel!
    @IBOutlet weak var reasonlbl: UILabel!
    @IBOutlet weak var toDateHalflbl: UILabel!
    @IBOutlet weak var fromDateHalflbl: UILabel!
    @IBOutlet weak var toDatelbl: UILabel!
    @IBOutlet weak var fromDatelbl: UILabel!
    @IBOutlet weak var leaveTypelbl: UILabel!
    @IBOutlet weak var empCodelbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    
    @IBAction func rejectBtn(_ sender: UIButton) {
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Reject", message: "Are you sure you want to reject this leave application?", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            self.status(rowSeq: rowseq, approvalDate: self.formatter.string(from: self.date), mgrRemarks: self.managerRemarkslbl.text ?? "Rejected", mgerStatus:"N" )
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        formatter.dateFormat = "yyyy-MM-dd"
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func acceptBtn(_ sender: UIButton) {
        // Create the alert controller
        let alertController = UIAlertController(title: "Approve", message: "Are you sure you want to approve this leave application?", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            self.status(rowSeq: rowseq, approvalDate: self.formatter.string(from: self.date), mgrRemarks: self.managerRemarkslbl.text ?? "Approved", mgerStatus:"Y" )
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        formatter.dateFormat = "yyyy-MM-dd"
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        if action == "Rejected" || action == "Approved"{
            managerRemarkslbl.isEnabled = false
            rejectBtn.isHidden = true
            acceptBtn.isHidden = true
        }
        hideKeyboardWhenTappedAround()
        getLeaveData(url: dataURL, header: headers)
        
        // MARK:-  Listen for keyBoard Events
        NotificationCenter.default.addObserver(self, selector: #selector(kewboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kewboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kewboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    @objc func kewboardWillChange(notification: Notification){
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -keyboardRect.height
        }
        else{
            view.frame.origin.y = 0
        }
        
    }
    
    
    
    //MARK: - Networking - ALAMO FIRE
    /***************************************************************/
    
    func getLeaveData(url : String, header : [String:String]){
        
        Alamofire.request(url, method: .get, headers : header).responseJSON{
            response in
            
            let leaveData = response.data!
            let leaveJSON = response.result.value
            
            if response.result.isSuccess{
                
                do{
                    let leave = try JSONDecoder().decode(LeaveDetailRoot.self, from: leaveData)
                    //line chart
                    
                    for x in leave.leaveInfo{
                        if x.rowSeq == rowseq{
                            self.nameLbl.text = x.empName
                            self.empCodelbl.text = x.empCode
                            self.leaveTypelbl.text = x.leaveType
                            self.fromDatelbl.text = x.fromDate
                            self.fromDateHalflbl.text = x.fromDateHalf
                            self.toDatelbl.text = x.toDate
                            self.toDateHalflbl.text = x.toDateHalf
                            self.reasonlbl.text = x.reason
                            self.remarklbl.text = x.remark
                            self.managerStatuslbl.text = x.mgrStatus
                            self.managerRemarkslbl.text = x.mgrRemark
                        }
                    }
                    //                                        print(self.empName)
                    //                                        print(self.leaveType)
                    
                    
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
    
    
    //MARK: - Networking - ALAMO FIRE
    /***************************************************************/
    
    func status(rowSeq : String, approvalDate : String, mgrRemarks: String, mgerStatus: String){
        let parameters : [String:[Any]] = [ "mgrLeave" :[ ["RowSeq" : rowSeq, "ApprovalDate": approvalDate,"MgrRemark":mgrRemarks,"MgrStatus":mgerStatus]]]
        
        
        Alamofire.request(setDataURL , method : .post,  parameters : parameters, encoding: JSONEncoding.default , headers: headers).responseJSON{
            response in
            
            print(parameters)
            
            
            //
            let loginJSON : JSON = JSON(response.result.value)
            
            if response.result.isSuccess{
                if loginJSON["returnType"].string == "Leave rejected successfully" || loginJSON["returnType"].string == "Leave approved successfully" {
                    SVProgressHUD.showSuccess(withStatus: loginJSON["returnType"].string)
                    self.performSegue(withIdentifier: "unwindToLeaveApproval", sender: self)
                }else{
                    SVProgressHUD.showSuccess(withStatus: loginJSON["returnType"].string)
            }
           }else{
            //print("Error: \(response.result.error!)")
            print(loginJSON)
        }
        //
    }
}

}
