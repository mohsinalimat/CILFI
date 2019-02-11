//
//  ReimbursementClaimViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 25/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import DropDown
import DatePickerDialog
import Alamofire
import SwiftyJSON
import SVProgressHUD
import MobileCoreServices

class ReimbursementClaimViewController: UIViewController, UIDocumentPickerDelegate {
    
    let reimbursment = ReimbursementModel()
    let claimURL = "\(LoginDetails.hostedIP)/sales/ReimbursementClaim"
    let rTypeURL = "\(LoginDetails.hostedIP)/sales/ReimbursementType"
    let user = UserTrackModel()
    
    let dropDown = DropDown()
    
    var code = String()
    var type = String()
    var rate = Double()
    var expenseDate = String()
    
    var reimbursmentType = ""
    var attachType = ""
    var attachment = ""
    var tracked = [Double]()
    
    @IBOutlet weak var reimbursmentTypeBtn: UIButton!
    @IBOutlet weak var expenseDateTf: UITextField!
    @IBOutlet weak var originTf: UITextField!
    @IBOutlet weak var destinationTf: UITextField!
    @IBOutlet weak var kmTf: UITextField!
    @IBOutlet weak var rateTf: UITextField!
    @IBOutlet weak var amntTf: UITextField!
    @IBOutlet weak var remarkTf: UITextField!
    @IBOutlet weak var attachmentTf: UITextField!
    @IBAction func attachmentBtn(_ sender: UIButton) {
        
        let types: [String] = [kUTTypePDF as String]
        let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .popover
        self.present(documentPicker, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var originstack: UIStackView!
    @IBOutlet weak var destinationstack: UIStackView!
    @IBOutlet weak var kmstack: UIStackView!
    @IBOutlet weak var ratestack: UIStackView!
    
    @IBAction func kmTF(_ sender: UITextField) {
        
//        if kmTf.text == ""{
//            amntTf.text = ""
//        }else{
            if let kms = Double(kmTf.text!){
                amntTf.text = String(kms*rate)
//
//            }
        }
    }
    
    @IBAction func reimbursmentTypeBtn(_ sender: UIButton) {
        
        dropDown.dataSource = reimbursment.rName
        dropDown.anchorView = reimbursmentTypeBtn
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            if self.reimbursment.reimburseType[index] == "O"{
               
                self.kmstack.isHidden = true
                self.ratestack.isHidden = true
                self.originstack.isHidden = true
                self.destinationstack.isHidden = true
                self.amntTf.isEnabled = true
                self.amntTf.text = ""
            } else{
                
                self.kmstack.isHidden = false
                self.ratestack.isHidden = false
                self.originstack.isHidden = false
                self.destinationstack.isHidden = false
                self.amntTf.isEnabled = false
                self.amntTf.text = ""
                
            }
            
            self.reimbursmentType = self.reimbursment.reimburseType[index]
            self.reimbursmentTypeBtn.titleLabel?.text = item
            self.type = item
//            self.reimbursment.getRRateData(code: self.reimbursment.rCode[index], completion: { (rate) in
//                self.setRate(r8: rate)
//
//            })
            
            self.code = self.reimbursment.rCode[index]
            self.setRate(code: self.reimbursment.rCode[index])
            
        }
    }
    
    func setRate(code : String){
        
        SVProgressHUD.show()
        let header : [String:String] = ["username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "user")! , "code" : code]
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/ReimbursementRate", headers: header).responseJSON{
            response in
            
            
            let rRateData = response.data
            let rRateJSON = response.result.value
            
            if response.result.isSuccess{
                //                    print(rRateJSON)
                do{
                    let rate = try JSONDecoder().decode(ReimbursementRateRoot.self, from: rRateData!)
                    
                    
                    if let r8 = rate.rate{
                        
                        self.rate = Double(r8)!
                        self.rateTf.text = r8
                         print (r8)
                    }
                    SVProgressHUD.dismiss()
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
    
    @IBAction func edDateBtn(_ sender: UIButton) {
        let date = Calendar.current.date(byAdding: .month, value: -1, to: Date())
       
        
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel",minimumDate: date, maximumDate: Date(), datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
        
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                self.expenseDateTf.text = formatter.string(from: dt)
                formatter.dateFormat = "yyyy-MM-dd"
                self.expenseDate = formatter.string(from: dt)
                
                self.user.getUserTrackData(date: formatter.string(from: dt), employee: defaults.string(forKey: "user")! ) { (loc, date, notification, trackedKms) in
                    if !trackedKms.isEmpty{
                        self.tracked = trackedKms
                    }
                   
                }
            }
        }
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        reimbursment.getRTypeData()
        
        
        
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
            view.frame.origin.y = -50
        }
        else{
            view.frame.origin.y = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let date = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        expenseDateTf.placeholder = "\(formatter.string(from: date!)) to \(formatter.string(from: Date()))"
    }
    
    @IBAction func submitBtn(_ sender: UIButton) {
        var trackingKms = 0.0
        
        if reimbursmentType == "O"{
            trackingKms = 0
        }else{
            if tracked == [] || tracked.isEmpty{
                trackingKms = 0
            }else{
                for x in tracked{
                    trackingKms += x
                }
            }
        }
        
        
        if amntTf.text != "" && expenseDateTf.text != ""{
            
            let rRate = rateTf.text
            let amnt = amntTf.text
            let km = kmTf.text
            let fromdestination = originTf.text
            let todestination = destinationTf.text
            
            let parameters : [String:[Any]] = [ "reimburseData" :[ ["Amount" : amnt!, "Dtyp": code,"EmpCode":defaults.string(forKey: "user")!,"ExpenseDate":expenseDate ,"Kilometer":km!,"Ltyp":"02","Remark":remarkTf.text!,"AttachmentType": attachType,"Attachment":attachment, "Rate" : rRate!,"FromDest":fromdestination,"ToDest":todestination,"TrackingKMS ":String(trackingKms/1000)]]]
        
//                    print(parameters)
            
            Alamofire.request(claimURL , method : .post,  parameters : parameters, encoding: JSONEncoding.default , headers: headers).responseJSON{
                response in

                print(parameters)


                //
                let loginJSON : JSON = JSON(response.result.value)

                if response.result.isSuccess{


                    print("Success! Posting the Leave Detail data")
                    //                print(JSONEncoding())

                    print(loginJSON)

                    if loginJSON["returnType"].string == "Reimbursement Claimed Successfully"{
                        SVProgressHUD.showSuccess(withStatus: loginJSON["returnType"].string)
                        SVProgressHUD.dismiss(withDelay: 5)
                        self.expenseDateTf.text = ""
                        self.originTf.text = ""
                        self.destinationTf.text = ""
                        self.kmTf.text = ""
                        self.amntTf.text = ""
                        self.remarkTf.text = ""
                        self.rateTf.text = ""
                        self.attachment = ""
                        self.attachmentTf.text = ""
                        self.attachType = ""
                    }else{
                        SVProgressHUD.showError(withStatus: loginJSON["returnType"].string )
                        SVProgressHUD.dismiss(withDelay: 5)
                    }

                    //                self.updateLoginData(json : loginJSON)

                }

                else{
                    //print("Error: \(response.result.error!)")
                    print(loginJSON)
                }

            }
        }else{
            SVProgressHUD.showInfo(withStatus: "Please fill all the fields first.")
            SVProgressHUD.dismiss(withDelay: 3)
        }

    }
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // you get from the urls parameter the urls from the files selected
        let urlArr = urls[0].absoluteString.components(separatedBy: "/")
        if let filename = urlArr.last{
            attachmentTf.text = filename
        }
        
       
        let filePath = urls.first //URL of the PDF
        let fileData = try! Data.init(contentsOf: filePath!)
        attachment = fileData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        attachType = urls.first!.absoluteURL.pathExtension
       
    }
    
}



