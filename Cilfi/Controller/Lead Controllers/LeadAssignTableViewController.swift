//
//  LeadAssignTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 13/07/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import Alamofire
import SwiftyJSON
import DropDown
import SVProgressHUD

class AssignLeadCell : MGSwipeTableCell{
    
    @IBOutlet weak var leadIDLbl: UILabel!
    @IBOutlet weak var assignedToLbl: UILabel!
    @IBOutlet weak var contactPersonLbl: UILabel!
    @IBOutlet weak var mobileLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
}

class LeadAssignTableViewController: UITableViewController {
    
    var id = ""
    var opt = ""
    var teamDetailEmpName = [String]()
    var teamDetailEmpCode = [String]()
    
    let dropDown = DropDown()
    
    var leadID = [String]()
    var leadAssignedTo = [String]()
    var contactPerson = [String]()
    var mobile = [String]()
    var date = [String]()
    
    @IBOutlet weak var leadOptBtn: UIButton!
    @IBAction func leadOptBtn(_ sender: UIButton) {
        
        dropDown.dataSource = ["New", "Follow Up", "Converted", "Lost"]
        dropDown.anchorView = leadOptBtn
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            SVProgressHUD.show()
            self.opt = item
            self.getLeadAcess()
            self.leadOptBtn.setTitle(item, for: .normal)
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTeamDetails()
        
        
    }
    
    @IBAction func unwindToLeadAssign(segue:UIStoryboardSegue) {
        getLeadAcess()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let leadAssign = segue.destination as! LeadAssignDetailViewController
        leadAssign.name = teamDetailEmpName
        leadAssign.code = teamDetailEmpCode
        leadAssign.id = id
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leadID.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignCell", for: indexPath) as! AssignLeadCell
        
        let more = MGSwipeButton(title: " Info",icon: UIImage(named: "table-info"), backgroundColor: UIColor.flatGray) {
            (sender: MGSwipeTableCell!) -> Bool in
            
            clearValues()
            self.id = self.leadID[indexPath.row]
            
            self.performSegue(withIdentifier: "goToAssignLeadDetails", sender: self)
            return true
            
        }
        
        cell.leftButtons = [more]
        
        cell.dateLbl.text = date[indexPath.row]
        cell.leadIDLbl.text = leadID[indexPath.row]
        cell.assignedToLbl.text = leadAssignedTo[indexPath.row]
        cell.mobileLbl.text = mobile[indexPath.row]
        cell.contactPersonLbl.text = contactPerson[indexPath.row]
        
        return cell
        
    }
    
    
    
    func getLeadAcess(){
        
        leadID = [String]()
        leadAssignedTo = [String]()
        contactPerson = [String]()
        mobile = [String]()
        date = [String]()
        
        Alamofire.request("\(LoginDetails.hostedIP)/Sales/leadapproval", method: .get, headers : headers).responseJSON{
            response in
            
            let leadData = response.data!
            let leadJSON = response.result.value
            if response.result.isSuccess{
                //                    print("UserTrackJSON: \(leadJSON)")
                do{
                    let lead = try JSONDecoder().decode(LeadDataRoot.self, from: leadData)
                    
                    for x in lead.leadData{
                        if x.status == self.opt{
                        if let id = x.leadID{
                            self.leadID.append(id)
                        }
                        if let assignedTo = x.executiveName{
                            self.leadAssignedTo.append(assignedTo)
                        }
                        if let person = x.fcontactPerson{
                            self.contactPerson.append(person)
                        }
                        if let mobile = x.firmContactPersonMobile{
                            self.mobile.append(mobile)
                        }
                        if let date = x.visitDate{
                            self.date.append(date)
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
        
    }
    
    
    func getTeamDetails(){
        teamDetailEmpName = [String]()
        teamDetailEmpCode = [String]()
        
        Alamofire.request("\(LoginDetails.hostedIP)/Sales/teamdetail", method: .get, headers : headers).responseJSON{
            response in
            
            let teamData = response.data!
            let teamJSON = response.result.value
            if response.result.isSuccess{
                //                    print("UserTrackJSON: \(leadJSON)")
                do{
                    let team = try JSONDecoder().decode(TeamDetailRoot.self, from: teamData)
                    
                    for x in team.teamdetail{
                        if let code = x.empCode{
                            self.teamDetailEmpCode.append(code)
                        }
                        if let name = x.empName{
                            self.teamDetailEmpName.append(name)
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
    
}
