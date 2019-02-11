//
//  TicketApproveDetailViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 28/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class TicketingApproveDetailViewController: UIViewController {

    let ticketApproveURL = "\(LoginDetails.hostedIP)/Sales/TicketApprove"
    var date = Date()
    let formatter = DateFormatter()
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var empCodeLbl: UILabel!
    @IBOutlet weak var deptLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var tIDLbl: UILabel!
    @IBOutlet weak var reqLbl: UILabel!
    @IBOutlet weak var ottLbl: UILabel!
    @IBOutlet weak var cttLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var remarksTf: UITextField!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var approveBtn: UIButton!
    
    @IBAction func approveBtn(_ sender: UIButton) {
    
        self.formatter.dateFormat = "yyyy/MM/dd hh:mm:ss a"
        let timedate = self.formatter.string(from: self.date)
        
        self.status(dateTime: timedate , status: "Y", remark: remarksTf.text!, ticketID: TicketingApproveModel.ticketID)
        
    }
    @IBAction func rejectBtn(_ sender: UIButton) {
    
        self.formatter.dateFormat = "yyyy/MM/dd hh:mm:ss a"
        let timedate = self.formatter.string(from: self.date)
        
        self.status(dateTime: timedate , status: "N", remark: remarksTf.text!, ticketID: TicketingApproveModel.ticketID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTickeApproveDate()
    
    
        if action == "Rejected" || action == "Approved"{
            remarksTf.isEnabled = false
            rejectBtn.isHidden = true
            approveBtn.isHidden = true
        }
        hideKeyboardWhenTappedAround()
        
        
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
            view.frame.origin.y = -175
        }
        else{
            view.frame.origin.y = 0
        }

    
    }

    //MARK: - Networking - ALAMO FIRE
    /***************************************************************/
    
    func getTickeApproveDate(){
        
       
        Alamofire.request(ticketApproveURL, headers: headers).responseJSON{
            response in
            
            
            let tApproveData = response.data!
            let tApproveJSON = response.result.value
            
            if response.result.isSuccess{
//                print(rStatusJSON)
                do{
                    let tApprove = try JSONDecoder().decode(TicketApproveRoot.self, from: tApproveData)
                    
                    for x in tApprove.taData{
                        if TicketingApproveModel.ticketID == x.tID{
                            
                            if let name = x.name{
                                self.nameLbl.text = name
                            }
                            if let code = x.code{
                                self.empCodeLbl.text = code
                            }
                            if let dept = x.dept{
                                self.deptLbl.text = dept
                            }
                            if let category = x.category{
                                self.categoryLbl.text = category
                            }
                            if let ticketID = x.tID{
                                self.tIDLbl.text = ticketID
                            }
                            if let request = x.request{
                                self.reqLbl.text = request
                            }
                            if let ott = x.otTime{
                                self.ottLbl.text = ott
                            }
                            if let ctt = x.clTime{
                                self.cttLbl.text = ctt
                            }
                            if let status = x.status{
                                if status == "Pending"{
                                    self.statusLbl.textColor = UIColor.flatOrange
                                }else if status == "Approved"{
                                    self.statusLbl.textColor = UIColor.flatGreen
                                }else if status == "Rejected"{
                                    self.statusLbl.textColor = UIColor.flatRed
                                }
                                self.statusLbl.text = status
                            }
                            
                            if let mgrRemarks = x.remark{
                                    self.remarksTf.text = mgrRemarks
                                }
                            
                            
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
    
    
    //MARK: - Networking - ALAMO FIRE
    /***************************************************************/
    
    func status(dateTime: String, status: String, remark: String, ticketID: String){
        
        //        {"CloseTicketTime": "2018/02/05 03:50:20 PM","Status": "Y", "Remark": "Provide accessories","TicketID": "5" }
        
        
        let parameters : [String:Any] = [ "CloseTicketTime" : dateTime, "Status" : status, "Remark": remark,"ticketID": ticketID]
        
        //        print(parameters)
        Alamofire.request(ticketApproveURL , method : .post,  parameters : parameters, encoding: JSONEncoding.default , headers: headers).responseJSON{
            response in
            
            let tApproveJSON : JSON = JSON(response.result.value)
            
            if response.result.isSuccess{
                print("Success! Posting the Leave Detail data")
                //                print(JSONEncoding())
                                            print(tApproveJSON)
                
                if tApproveJSON["returnType"].string == "Ticket approve successfully" || tApproveJSON["returnType"].string == "Ticket reject successfully"{
                    SVProgressHUD.showSuccess(withStatus: tApproveJSON["returnType"].string)
                    self.getTickeApproveDate()
                }else{
                    SVProgressHUD.showError(withStatus: tApproveJSON["returnType"].string)
                }
               
                self.performSegue(withIdentifier: "unwindSegueToTAT", sender: self)
            }
                
            else{
                //print("Error: \(response.result.error!)")
                print(tApproveJSON)
            }
            
        }
    }


}
