//
//  TicketingHelpDeskViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 29/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import SwiftyJSON
import SVProgressHUD

class TicketingHelpDeskViewController: UIViewController {

    let ticket = TicketingModel()
    let dropDown = DropDown()
    let deptURL = "\(LoginDetails.hostedIP)/Sales/TicketDept"
    let catURL = "\(LoginDetails.hostedIP)/Sales/TicketCategory"
    let ticketRequest = "\(LoginDetails.hostedIP)/Sales/TicketRequest"
    @IBOutlet weak var deptBtn: UIButton!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var queryTF: UITextField!
    
    @IBAction func deptBtn(_ sender: UIButton) {
    
        dropDown.dataSource = ticket.deptName
        dropDown.anchorView = deptBtn
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.deptBtn.setTitle(item, for: .normal)
            self.categoryBtn.setTitle("--- Select Category ---", for: .normal)
            TicketingModel.deptCode = self.ticket.deptCode[index]
            TicketingModel.catCode = ""
            self.ticket.getCategoryData(url: self.catURL)
            
        }
    
    }
    
    @IBAction func categoryBtn(_ sender: UIButton) {
    
        dropDown.dataSource = ticket.catName
        dropDown.anchorView = categoryBtn
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.categoryBtn.setTitle(item, for: .normal)
            TicketingModel.catCode = self.ticket.catCode[index]
            
        }
    
    }
    
    
    @IBAction func submitBtn(_ sender: UIButton) {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd hh:mm:ss a"
        
        if deptBtn.titleLabel?.text != "--- Select Dept ---" && queryTF.text != "" {
        status(code: defaults.string(forKey: "employeeCode")!, dept: TicketingModel.deptCode, cat: TicketingModel.catCode, req: queryTF.text!, ottime: formatter.string(from: date))
        }else {
            SVProgressHUD.showError(withStatus: "Please fill all the nessesary details.")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ticket.getDepartmentData(url: deptURL)
        
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

    
   
    //MARK: - Networking - ALAMO FIRE
    /***************************************************************/
    
    func status(code: String, dept: String, cat: String, req: String , ottime: String){
        
       
//        {"Code": "A35","Dept": "40","Category": "01","Request": "Lan Lavel Problem","OpenTicketTime": "2018/02/05 03:50:20 PM"}
        
        let parameters : [String:Any] = ["Code": code, "Dept": dept, "Category": cat,"Request": req,"OpenTicketTime": ottime]
        
              print(parameters)
        Alamofire.request(ticketRequest , method : .post,  parameters : parameters, encoding: JSONEncoding.default , headers: headers).responseJSON{
            response in
            
            let requestJSON : JSON = JSON(response.result.value)
            
            print (requestJSON)
            if response.result.isSuccess{
                
               
                if requestJSON["Message"].string == "Ticket Not Generated"{
                    SVProgressHUD.showError(withStatus: requestJSON["Message"].string)
                }else{
                    SVProgressHUD.showSuccess(withStatus: "Successfully posted your request. Your Ticket ID is : \(requestJSON["TicketID"].string)")
                }
                
                
                
            }
                
            else{
                //print("Error: \(response.result.error!)")
                print(requestJSON)
            }
            
        }
    }

    

}
