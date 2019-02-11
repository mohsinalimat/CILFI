//
//  LeadStatusTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 10/07/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import Alamofire
import SwiftyJSON
import DropDown
import SVProgressHUD
class LeadStatusCell: MGSwipeTableCell {
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var leadIDLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mobileLbl: UILabel!
}

class LeadStatusTableViewController: UITableViewController {

    var opt = ""
   @IBAction func unwindToLeadStatus(segue:UIStoryboardSegue) {
    
        getLeaveData(option: opt)
    }
    
    
    var id = ""
    let dropDown = DropDown()
    
    var name = [String]()
    var leadID = [String]()
    var date = [String]()
    var mobileNo = [String]()
    
    @IBOutlet weak var selectBtn: UIButton!
    
    @IBAction func selectBtn(_ sender: UIButton) {
        
        dropDown.dataSource = ["New", "Follow Up", "Converted", "Lost"]
        dropDown.anchorView = selectBtn
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            SVProgressHUD.show()
            self.opt = item
            self.getLeaveData(option: item)
            self.selectBtn.titleLabel?.text = item
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let statusDetail = segue.destination as! LeadStatusDetailViewController
        statusDetail.leadId = id
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return leadID.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leadStatCell", for: indexPath) as! LeadStatusCell
        
        let more = MGSwipeButton(title: " Info",icon: UIImage(named: "table-info"), backgroundColor: UIColor.flatGray) {
            (sender: MGSwipeTableCell!) -> Bool in
            
            clearValues()
            self.id = self.leadID[indexPath.row]
           
            self.performSegue(withIdentifier: "goToLeadStatusDetail", sender: self)
            return true
            
        }
        
        cell.leftButtons = [more]
        
        cell.dateLbl.text = date[indexPath.row]
        cell.leadIDLbl.text = leadID[indexPath.row]
        cell.mobileLbl.text = mobileNo[indexPath.row]
        cell.nameLbl.text = name[indexPath.row]
        
        return cell
        
    }
    
    
    
    func getLeaveData(option : String){
        
        name = [String]()
        leadID = [String]()
        date = [String]()
        mobileNo = [String]()
        
        //      print("we are here")
        Alamofire.request("\(LoginDetails.hostedIP)/Sales/LeadData", method: .get, headers : headers).responseJSON{
            response in
            
            let leadData = response.data!
            let leadJSON = response.result.value
            if response.result.isSuccess{
                //                    print("UserTrackJSON: \(leadJSON)")
                do{
                    let lead = try JSONDecoder().decode(LeadDataRoot.self, from: leadData)
                    
                    for x in lead.leadData{
                        if x.status == option{
                            
                            if let name = x.fcontactPerson{
                                self.name.append(name)
                            }else {
                                self.name.append("")
                            }
                            
                            if let id = x.leadID{
                                self.leadID.append(id)
                            }else {
                                self.leadID.append("")
                            }
                            
                            if let date = x.visitDate{
                                self.date.append(date)
                            }else {
                                self.date.append("")
                            }
                            
                            if let mobileno = x.firmContactPersonMobile{
                                self.mobileNo.append(mobileno)
                            }else {
                                self.mobileNo.append("")
                            }
                            
                        }
                        
                    }
                    SVProgressHUD.dismiss()
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
        
        //      getCurrentLocation()
    }
    
}
