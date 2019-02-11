//
//  TicketingStatusTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 28/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TicketStatusCell : UITableViewCell{
    
    @IBOutlet weak var ticketIDLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var deptLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var slaLbl: UILabel!
    @IBOutlet weak var queryLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var remarkLbl: UILabel!
    
}

class TicketingStatusTableViewController: UITableViewController {
    
    let statusURL = "\(LoginDetails.hostedIP)/Sales/TicketStatus"
    
    var ticketID = [String]()
    var date = [String]()
    var dept = [String]()
    var category = [String]()
    var sla = [String]()
    var query = [String]()
    var status = [String]()
    var remark = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTickeApproveDate()
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ticketID.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ticketingStatusCell", for: indexPath) as! TicketStatusCell
        
        cell.ticketIDLbl.text = ticketID[indexPath.row]
        cell.dateLbl.text = date[indexPath.row]
        cell.deptLbl.text = dept[indexPath.row]
        cell.categoryLbl.text = category[indexPath.row]
        cell.slaLbl.text = sla[indexPath.row]
        cell.queryLbl.text = query[indexPath.row]
        cell.statusLbl.text = status[indexPath.row]
        cell.remarkLbl.text = remark[indexPath.row]
        
        if cell.statusLbl.text == "Pending"{
            cell.statusLbl.textColor = UIColor.flatOrange
        }else if cell.statusLbl.text == "Rejected"{
            cell.statusLbl.textColor = UIColor.flatRed
        }else if cell.statusLbl.text == "Approved"{
            cell.statusLbl.textColor = UIColor.flatGreen
        }
        
        return cell
    }
    
    
    
    //MARK: - Networking - ALAMO FIRE
    /***************************************************************/
    func getTickeApproveDate(){
        
        ticketID = [String]()
        date = [String]()
        dept = [String]()
        category = [String]()
        sla = [String]()
        query = [String]()
        status = [String]()
        remark = [String]()
        
        Alamofire.request(statusURL, headers: headers).responseJSON{
            response in
            
            
            let rStatusData = response.data!
            let rStatusJSON = response.result.value
            
            if response.result.isSuccess{
                //                print(rStatusJSON)
                do{
                    let tApprove = try JSONDecoder().decode(TicketApproveRoot.self, from: rStatusData)
                    
                    for x in tApprove.taData{
                        
                        
                        if let tid = x.tID{
                            self.ticketID.append(tid)
                        }
                        if let date = x.otTime{
                            self.date.append(date)
                        }
                        if let department = x.dept{
                            self.dept.append(department)
                        }
                        if let category = x.category{
                            self.category.append(category)
                        }
                        if let sla = x.sla{
                            self.sla.append(sla)
                        }
                        if let query = x.remark{
                            self.query.append(query)
                        }
                        if let status = x.status{
                            self.status.append(status)
                        }
                        if let remark = x.remark{
                            self.remark.append(remark)
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
    
    
}
