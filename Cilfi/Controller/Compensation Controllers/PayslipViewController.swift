//
//  PayslipViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 22/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import PDFKit
import DatePickerDialog
import Alamofire
import SVProgressHUD

@available(iOS 11.0, *)
class PayslipViewController: UIViewController {
    
    let paySlipUrl = "\(LoginDetails.hostedIP)/sales/PaySlip"
    let headers : [String:String] = ["username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "user")!]
    
    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func dateButton(_ sender: UIButton) {
        
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM-yyyy"
                self.dateLabel.text = formatter.string(from: dt)
                formatter.dateFormat = "yyyyMM"
                self.getPayslip(ym : formatter.string(from: dt))
                
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateLabel.text = defaults.string(forKey: "yearMonth")!
        
        
    }
    
    func getPayslip(ym : String){
        
        let header : [String:String] = ["username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : ym, "employeecode" : defaults.string(forKey: "user")!]
        
        //              print("we are here")
        Alamofire.request(paySlipUrl, method: .get, headers : header).responseJSON{
            response in
            
            let paySlipData = response.data!
            let paySlipJSON = response.result.value
            if response.result.isSuccess{
                //                print(paySlipJSON)
                do{
                    let payslip = try JSONDecoder().decode(PaySlipRoot.self, from: paySlipData)
                    //line chart
                    
                    
                    if #available(iOS 11.0, *) {
                        if let pS = payslip.paySlip{
                            
                            
                            
                            if pS == ""{
                                SVProgressHUD.showError(withStatus: "PDF not available.")
                                SVProgressHUD.dismiss(withDelay: 3)
                                self.pdfView.document = nil
                            }else{
                                 if let finalurl = URL(string: "\(LoginDetails.hostedIP)\(pS)" ){
                                    
                                    self.pdfView.document = PDFDocument(url: finalurl)
                                    
                                }
                                
                            }
                        }
                        
                    } else{
                        SVProgressHUD.showError(withStatus: "The feature to view pdf is only availabe in IOS 11.0 and newer versions.")
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
}
