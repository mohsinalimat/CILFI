//
//  TeamVisitTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 28/07/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import Alamofire
class TeamVisitCell: MGSwipeTableCell{
    
    @IBOutlet weak var accountLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var visitDateLbl: UILabel!
    @IBOutlet weak var nextDateLbl: UILabel!
    @IBOutlet weak var empNameLbl: UILabel!
    
}

class TeamVisitTableViewController: UITableViewController {

    
    var executiveName = [String]()
    var executiveCode = [String]()
    var designation = [String]()
    var visitDate = [String]()
    var reportDate = [String]()
    var reportLocation = [String]()
    var customerName = [String]()
    var customerAccount = [String]()
    var visitPurpose = [String]()
    var visitTask = [String]()
    var visitAchieve = [String]()
    var targetDate = [String]()
    var nextDate = [String]()
    
    var index = -1
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        getMyVisitReport()
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return visitDate.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tvCell", for: indexPath) as! TeamVisitCell
        
        let more = MGSwipeButton(title: " Info",icon: UIImage(named: "table-info"), backgroundColor: UIColor.flatGray) {
            (sender: MGSwipeTableCell!) -> Bool in
            
            self.index = indexPath.row
            self.performSegue(withIdentifier: "goToTeamVisitDetails", sender: self)
            return true
            
        }
        
        more.centerIconOverText()
        cell.leftButtons = [more]
        
        cell.empNameLbl.text = executiveName[indexPath.row]
        cell.visitDateLbl.text = visitDate[indexPath.row]
        cell.nextDateLbl.text = nextDate[indexPath.row]
        cell.accountLbl.text = customerAccount[indexPath.row]
        cell.nameLbl.text = customerName[indexPath.row]
        
        return cell
    }
    
    
    func getMyVisitReport(){
        
        executiveName = [String]()
        executiveCode = [String]()
        designation = [String]()
        visitDate = [String]()
        reportDate = [String]()
        reportLocation = [String]()
        customerName = [String]()
        customerAccount = [String]()
        visitPurpose = [String]()
        visitTask = [String]()
        visitAchieve = [String]()
        targetDate = [String]()
        nextDate = [String]()
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/visitingmgrreport", method: .get, headers : headers).responseJSON{
            response in
            
            let visitData = response.data!
            let visitJSON = response.result.value
            
            if response.result.isSuccess{
                print("UserJSON: \(visitJSON)")
                do{
                    let visit = try JSONDecoder().decode(VisitingReportRoot.self, from: visitData)
                    
                    for x in visit.visitingReport{
                        
                        if let eName = x.executiveName{
                            self.executiveName.append(eName)
                        }
                        if let eCode = x.executiveCode{
                            self.executiveCode.append(eCode)
                        }
                        
                        //                        if let desg = x.designation{
                        //                            self.designation.append(desg)
                        //                        }
                        
                        if let visitdate = x.visitDate{
                            self.visitDate.append(visitdate)
                        }
                        
                        if let rDate = x.reportDate{
                            self.reportDate.append(rDate)
                        }
                        
                        if let rLoc = x.reportLocation{
                            self.reportLocation.append(rLoc)
                        }
                        
                        if let custName = x.customerName{
                            self.customerName.append(custName)
                        }
                        
                        if let custAccount = x.customerAccount{
                            self.customerAccount.append(custAccount)
                        }
                        
                        if let vPurp = x.visitPuporse{
                            self.visitPurpose.append(vPurp)
                        }
                        
                        if let vTask = x.visitTask{
                            self.visitTask.append(vTask)
                        }
                        
                        if let vAchieve = x.visitAchived{
                            self.visitAchieve.append(vAchieve)
                        }
                        if let tDate = x.targetDate{
                            self.targetDate.append(tDate)
                        }
                        if let nDate = x.nextDate{
                            self.nextDate.append(nDate)
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! MyVisitDetailViewController
        destinationVC.executiveName = executiveName[index]
        destinationVC.executiveCode = executiveCode[index]
        //        destinationVC.designation = designation[index]
        destinationVC.visitDate = visitDate[index]
        destinationVC.reportDate = reportDate[index]
        destinationVC.reportLocation = reportLocation[index]
        destinationVC.customerName = customerName[index]
        destinationVC.customerAccount = customerAccount[index]
        destinationVC.visitPurpose = visitPurpose[index]
        destinationVC.visitTask = visitTask[index]
        destinationVC.visitAchieve = visitAchieve[index]
        destinationVC.targetDate = targetDate[index]
        destinationVC.nextDate = nextDate[index]
    }
   

}
