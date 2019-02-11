//
//  TicketingApproveViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 28/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MGSwipeTableCell
import DropDown
import SVProgressHUD

class TicketApproveCell :MGSwipeTableCell{
    
    @IBOutlet weak var empNameLbl: UILabel!
    @IBOutlet weak var deptLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var trackIDLbl: UILabel!
    
}


class TicketingApproveTableViewController: UITableViewController{

    let ticketApproveURL = "\(LoginDetails.hostedIP)/Sales/TicketApprove"
    let dropDown = DropDown()
    var date = Date()
    let formatter =  DateFormatter()
    var empName = [String]()
    var dept = [String]()
    var category = [String]()
    var tID = [String]()
    
     @IBAction func unwindToTicketingApprovalTable(segue:UIStoryboardSegue) { }
    
    @IBOutlet weak var typeBtn: UIButton!
    @IBAction func typeBtn(_ sender: UIButton) {
    
        dropDown.dataSource = ["Pending", "Approved", "Rejected"]
        dropDown.anchorView = typeBtn
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            self.typeBtn.setTitle(item, for: .normal)
            action = item
            self.getTickeApproveDate()
            
        }
    
    }
    
        override func viewDidLoad() {
            super.viewDidLoad()
    
          
        }
    
    override func viewWillAppear(_ animated: Bool) {
        if let tbText = typeBtn.titleLabel?.text{
            if tbText == "Pending" || tbText == "Approved" || tbText == "Rejected"{
                getTickeApproveDate()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return empName.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "ticketingApproveCell", for: indexPath) as! TicketApproveCell
        
        
        let more = MGSwipeButton(title: " Info",icon: UIImage(named: "table-info"), backgroundColor: UIColor.flatGray) {
            (sender: MGSwipeTableCell!) -> Bool in
            
            
            TicketingApproveModel.ticketID = self.tID[indexPath.row]

            self.performSegue(withIdentifier: "ticketApproveDetail", sender: self)
            return true
            
        }
        
        let approve = MGSwipeButton(title: "",icon: UIImage(named: "table-success"), backgroundColor: UIColor.flatGreen) {
            (sender: MGSwipeTableCell!) -> Bool in
            
            self.formatter.dateFormat = "yyyy/MM/dd hh:mm:ss a"
            let timedate = self.formatter.string(from: self.date)
            
            self.status(dateTime: timedate , status: "Y", remark: "", ticketID: self.tID[indexPath.row])
            
            return true
            
        }
        
        let reject = MGSwipeButton(title: "",icon: UIImage(named:"table-error"), backgroundColor: UIColor.flatRed) {
            (sender: MGSwipeTableCell!) -> Bool in
            
            self.formatter.dateFormat = "yyyy/MM/dd hh:mm:ss a"
            let timedate = self.formatter.string(from: self.date)
            
            self.status(dateTime: timedate , status: "N", remark: "", ticketID: self.tID[indexPath.row])
            return true
            
        }
        
        
        
        
        cell.empNameLbl.text = empName[indexPath.row]
        cell.deptLbl.text = dept[indexPath.row]
        cell.categoryLbl.text = category[indexPath.row]
        cell.trackIDLbl.text = tID[indexPath.row]
        
        cell.leftButtons = [more]
        cell.leftSwipeSettings.transition = .drag
        
        if action == "Pending"{
            cell.rightButtons = [ reject, approve]
            cell.rightSwipeSettings.transition = .drag
            
        }
        else{
            cell.rightButtons = []
        }
        
        cell.rightSwipeSettings.transition = .rotate3D
        
        return cell
        
    }
    

    func getTickeApproveDate(){
        
         empName = [String]()
         dept = [String]()
         category = [String]()
         tID = [String]()
        
        Alamofire.request(ticketApproveURL, headers: headers).responseJSON{
            response in
            
            
            let rStatusData = response.data!
            let rStatusJSON = response.result.value
            
            if response.result.isSuccess{
//                print(rStatusJSON)
                do{
                    let tApprove = try JSONDecoder().decode(TicketApproveRoot.self, from: rStatusData)
                    
                    for x in tApprove.taData{
                         if action == x.status{
                       
                            if let name = x.name{
                                self.empName.append(name)
                            }
                            if let dept = x.dept{
                                self.dept.append(dept)
                            }
                            if let category = x.category{
                                self.category.append(category)
                            }
                            if let tid = x.tID{
                                self.tID.append(tid)
                            }
                            
                        }
                        
                    }
                    
                    self.tableView.reloadData()
                    
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
//                            print(tApproveJSON)
                
                if tApproveJSON["returnType"].string == "Ticket approve successfully" || tApproveJSON["returnType"].string == "Ticket reject successfully"{
                    SVProgressHUD.showSuccess(withStatus: tApproveJSON["returnType"].string)
                    self.getTickeApproveDate()
                }else{
                    SVProgressHUD.showError(withStatus: tApproveJSON["returnType"].string)
                }
                
            }
                
            else{
                //print("Error: \(response.result.error!)")
                print(tApproveJSON)
            }
            
        }
    }
    
    
}
