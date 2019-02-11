//
//  MakeARequestViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 22/08/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import DatePickerDialog
import Alamofire
import SVProgressHUD
import SwiftyJSON

class MakeARequestViewController: UIViewController {
    
    var date = ""
    var time = ""
    var purpose = ""
    var additionalDetails = ""
    var location = ""
    
    
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var additionalDetailsTA: UITextView!
    @IBOutlet weak var purposeTF: UITextField!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBAction func timeBtn(_ sender: UIButton) {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "hh:mm:ss a"
                self.timeLbl.text = formatter.string(from: dt)
                formatter.dateFormat = "HH:mm"
                self.time = formatter.string(from: dt)
            }
        }
    }
    @IBAction func dateBtn(_ sender: UIButton) {
        
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            
            if let dt = date {
                let formatter = DateFormatter()
                
                formatter.dateFormat = "dd-MM-yyyy"
                self.dateLbl.text = formatter.string(from: dt)
                formatter.dateFormat = "yyyy-MM-dd"
                self.date = formatter.string(from: dt)
                self.timeLbl.text = ""
                self.time = ""
            }
        }
    }
    @IBAction func submitBtn(_ sender: UIButton) {
        SVProgressHUD.show()
        purpose = purposeTF.text!
        additionalDetails = additionalDetailsTA.text
        location = locationTF.text!
        
        if date != "" && time != ""{
            if purpose != "" && additionalDetails != "" && location != ""{
                
                let changedTimeString = time.replacingOccurrences(of: ":", with: ".")
                
                let parameter = ["AdditionalDetail":additionalDetails,"Code":defaults.string(forKey: "employeeCode")!,"MeetingWith": ManagerInfo.managerCode,"ProposalDate":date,"ProposalTime":changedTimeString,"Purpose":purpose,"RequestedBy":defaults.string(forKey: "employeeCode")!,"MeetingLocation":location,"Status":"P"]
                
                
                print("x = \(setMeeting(params: parameter))")
                
            }else{
                SVProgressHUD.showError(withStatus: "Purpose/Additional Details/Location can not be empty.")
            }
            
        }else{
            
            SVProgressHUD.showInfo(withStatus: "Invalid Date/Time. Please check again")
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        hideKeyboardWhenTappedAround()
    }
    
    
    func setMeeting(params : [String:String]){
        
        print(params)
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/meetingrequest" , method : .post,  parameters : params, encoding: JSONEncoding.default , headers: headers).responseJSON{
            response in
            
            
            let meetingJSON : JSON = JSON(response.result.value)
            
            if response.result.isSuccess{
                
                if meetingJSON["returnType"].string == "Successfully Inserted....!!!!"{
                    SVProgressHUD.showSuccess(withStatus: "Successfully send the meeting request.")
                    
                    self.clearAll()
                    
                }else{
                    SVProgressHUD.showError(withStatus: meetingJSON["returnType"].string)
                }
                print("Success! Posting the Leave Detail data")
                
                
//                print(meetingJSON)
                
            }
                
            else{
                //print("Error: \(response.result.error!)")
                print(meetingJSON)
            }
            
        }
        
    }
    
    
    func clearAll(){
        
        self.date = ""
        self.time = ""
        self.purpose = ""
        self.additionalDetails = ""
        self.location = ""
        
        self.dateLbl.text = ""
        self.timeLbl.text = ""
        self.purposeTF.text = ""
        self.locationTF.text = ""
        self.additionalDetailsTA.text = ""
        
    }
    
}




extension MakeARequestViewController : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Meeting Request")
    }
}
