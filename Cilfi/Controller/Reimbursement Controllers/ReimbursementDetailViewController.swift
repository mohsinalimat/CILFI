////
////  ReimbursementDetailViewController.swift
////  Cilfi
////
////  Created by Amandeep Singh on 26/06/18.
////  Copyright © 2018 Focus Infosoft. All rights reserved.
////
//
//import UIKit
//import Alamofire
//import SwiftyJSON
//import SVProgressHUD
//
////struct ApproveData{
////
////    static var  empcode = String()
////    static var reimbursementType = String()
////    static var date = String()
////    static var dType = String()
////    static var lType = String()
////    static var rType = String()
////    static var rowSeq = String()
////}
//
//
//
//
//
//class ReimbursementDetailViewController: UIViewController{
//    
//    
//    var rowSeq = ""
//    var actionType = ""
//    var reimburseType = ""
//    
//    
//    let url = "\(LoginDetails.hostedIP)/sales/ReimbursementDetail"
//    let reimbursementApproveURL = "\(LoginDetails.hostedIP)/sales/ReimbursementApproval"
//    
//    let formatter = DateFormatter()
//    let rTable = ReimbursementApproveTableViewController()
//    
//    @IBOutlet weak var nameLbl: UILabel!
//    @IBOutlet weak var reimbursementTypeLbl: UILabel!
//    @IBOutlet weak var amntLbl: UILabel!
//    @IBOutlet weak var mgrRemarksLbl: UITextField!
//    @IBOutlet weak var mgrStatusLbl: UILabel!
//    @IBOutlet weak var remarksLbl: UITextView!
//    @IBOutlet weak var claimDateLbl: UILabel!
//    @IBOutlet weak var rejectBtn: UIButton!
//    @IBOutlet weak var acceptBtn: UIButton!
//    
//    @IBOutlet weak var kmTitleLbl: UILabel!
//    @IBOutlet weak var kmMiddleLbl: UILabel!
//    @IBOutlet weak var kmvalueLbl: UILabel!
//    
//    @IBOutlet weak var trackedKMTitleLbl: UILabel!
//    @IBOutlet weak var trackedKMMiddleLbl: UILabel!
//    @IBOutlet weak var trackedKMValueLbl: UILabel!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        getRDetailsData()
//        
//        if actionType == "Rejected" || actionType == "Approved"{
//            mgrRemarksLbl.isEnabled = false
//            rejectBtn.isHidden = true
//            acceptBtn.isHidden = true
//        }
//        
//        if reimburseType == "O"{
//            kmTitleLbl.isHidden = true
//            kmvalueLbl.isHidden = true
//            kmMiddleLbl.isHidden = true
//            
//            trackedKMValueLbl.isHidden = true
//            trackedKMTitleLbl.isHidden = true
//            trackedKMMiddleLbl.isHidden = true
//        }else if reimburseType == "K"{
//            kmTitleLbl.isHidden = false
//            kmvalueLbl.isHidden = false
//            kmMiddleLbl.isHidden = false
//            
//            trackedKMValueLbl.isHidden = false
//            trackedKMTitleLbl.isHidden = false
//            trackedKMMiddleLbl.isHidden = false
//        }
//        
//        
//        
//        claimDateLbl.text = ApproveData.date
//        hideKeyboardWhenTappedAround()
//        
//        
//        // MARK:-  Listen for keyBoard Events
//        NotificationCenter.default.addObserver(self, selector: #selector(kewboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(kewboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(kewboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
//    }
//    
//    
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
//    }
//    
//    
//    @objc func kewboardWillChange(notification: Notification){
//        
//        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
//            return
//        }
//        
//        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame {
//            view.frame.origin.y = -keyboardRect.height
//        }
//        else{
//            view.frame.origin.y = 0
//        }
//        
//    }
//    
//    @IBAction func rejectBtn(_ sender: UIButton) {
//        
//        self.status(dType: ApproveData.dType, empCode: ApproveData.empcode, expensedate: ApproveData.date, ltype: ApproveData.lType, mgrremarks: mgrRemarksLbl.text!, mgrStatus: "N", rowseq: ApproveData.rowSeq)
//        
//    }
//    
//    @IBAction func acceptBtn(_ sender: UIButton) {
//        
//        self.status(dType: ApproveData.dType, empCode: ApproveData.empcode, expensedate: ApproveData.date, ltype: ApproveData.lType, mgrremarks: mgrRemarksLbl.text!, mgrStatus: "Y", rowseq: ApproveData.rowSeq)
//        
//    }
//    
//    
//    
//    
//    func getRDetailsData(){
//        
//        
//        
//        Alamofire.request(url, headers: headers).responseJSON{
//            response in
//            
//            
//            let rStatusData = response.data!
//            let rStatusJSON = response.result.value
//            
//            if response.result.isSuccess{
////                print(rStatusJSON)
//                do{
//                    let rDetail = try JSONDecoder().decode(ReimbursementDetailRoot.self, from: rStatusData)
//                    
//                    for x in rDetail.rInfo{
//                        
//                        if ApproveData.empcode == x.empcode && ApproveData.reimbursementType ==  x.reimbursetype && ApproveData.rowSeq == x.rowSeq{
//                            if let name = x.empname{
//                                self.nameLbl.text = name
//                            }
//                            if let type = x.reimbursetype{
//                                self.reimbursementTypeLbl.text = type
//                            }
//                            if let total = x.amnt{
//                                self.amntLbl.text = total
//                            }
//                            
//                            
//                            
//                            if let remarks = x.remark{
//                                self.remarksLbl.text = remarks
//                            }
//                            if let mgrstatus = x.mgrstatus{
//                                self.mgrStatusLbl.text = mgrstatus
//                            }
//                            
//                            if let mgrremark = x.mgrremark{
//                                self.mgrRemarksLbl.text = mgrremark
//                            }
//                            
//                            if let km = x.kms{
//                                self.kmvalueLbl.text = String(km)
//                            }
//                            if let tkm = x.trackedKms{
//                                self.trackedKMValueLbl.text = String(tkm)
//                            }
//                            
//                        }
//                        
//                    }
//                }
//                    
//                    
//                    
//                    
//                catch{
//                    print (error)
//                }
//                
//            }
//            else{
//                print("Something Went wrong")
//            }
//        }
//        
//    }
//    
//    
//    //MARK: - Networking - ALAMO FIRE
//    /***************************************************************/
//    
//    func status(dType: String, empCode: String, expensedate: String, ltype: String, mgrremarks: String, mgrStatus: String, rowseq : String){
//        //        {"mgrReimburse":[{"Dtyp":"03","EmpCode":"r35","ExpenseDate":"2017-11-19","Ltyp":"02","MgrRemark":"","MgrStatus":"Y"}
//        
//        let parameters : [String:[Any]] = [ "mgrReimburse" : [["Dtyp" : dType, "EmpCode": empCode,"ExpenseDate":expensedate, "Ltyp":ltype, "MgrRemark":mgrRemarksLbl.text!, "MgrStatus":mgrStatus, "RowSeq": rowseq]]]
//        
//                        print(parameters)
//        Alamofire.request(reimbursementApproveURL , method : .post,  parameters : parameters, encoding: JSONEncoding.default , headers: headers).responseJSON{
//            response in
//            
//            
//            
//            //
//            let loginJSON : JSON = JSON(response.result.value)
//            
//            if response.result.isSuccess{
//                print("Success! Posting the Leave Detail data")
//                //                print(JSONEncoding())
//                print(loginJSON)
//                
//                if loginJSON["returnType"].string == "Reimbursement reject successfully" || loginJSON["returnType"].string == "Reimbursement approve successfully"{
//                    
//                    SVProgressHUD.showSuccess(withStatus: loginJSON["returnType"].string)
//                    
//                    //                    self.performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
//                }else{
//                    SVProgressHUD.showError(withStatus: loginJSON["returnType"].string)
//                }
//                
//                self.performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
//                
//            }
//                
//            else{
//                //print("Error: \(response.result.error!)")
//                print(loginJSON)
//            }
//            
//        }
//    }
//    
//}
