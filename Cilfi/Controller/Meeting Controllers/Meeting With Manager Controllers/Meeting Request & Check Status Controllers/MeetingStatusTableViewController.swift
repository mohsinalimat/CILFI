//
//  MeetingStatusTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 23/08/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import SVProgressHUD
import DropDown

class MeetingStatusCell : UITableViewCell{
    
    @IBOutlet weak var requestedByLbl: UILabel!
    @IBOutlet weak var purposeLbl: UILabel!
    @IBOutlet weak var additionalDetailLbl: UILabel!
    @IBOutlet weak var purposalDateLbl: UILabel!
    @IBOutlet weak var purposalTimeLbl: UILabel!
    @IBOutlet weak var requesteeFeedbackLbl: UILabel!
    @IBOutlet weak var managerFeedbackLbl: UILabel!
    @IBOutlet weak var managerRemarksLbl: UILabel!
    
}

class MeetingStatusTableViewController: UITableViewController {

    
    var date = [Date]()
    var reqBy = [String]()
    var purpose = [String]()
    var additionalInfo = [String]()
    var purposalDate = [String]()
    var purposalTime = [String]()
     var requesteeFeedback = [String]()
     var managerFeedback = [String]()
     var managerRemarks = [String]()
    
    @IBOutlet weak var statusBtn: UIButton!
    @IBAction func statusBtn(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.dataSource = ["Pending","Approved","Rejected"]
        dropDown.anchorView = view
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            self.statusBtn.setTitle(item, for: .normal)
            self.getStatus(status: item)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        statusBtn.setTitle("Pending", for: .normal)
       getStatus(status: "Pending")
    }

    

    func getStatus(status : String){
        date = [Date]()
        reqBy = [String]()
        purpose = [String]()
        additionalInfo = [String]()
        purposalDate = [String]()
        purposalTime = [String]()
        requesteeFeedback = [String]()
        managerFeedback = [String]()
        managerRemarks = [String]()
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/meetingrequest", method: .get, headers : headers).responseJSON{
            response in
            
            let meetData = response.data!
            let meetJSON = response.result.value
            
            if response.result.isSuccess{
//                print("UserJSON: \(visitJSON)")
                do{
                    let meeting = try JSONDecoder().decode(MeetingRequestRoot.self, from: meetData)
                    
                    for x in meeting.mrData{
                        if x.status == status{
                            if let value = x.requestedBy{
                                self.reqBy.append(value)
                            }
                            if let value = x.purpose{
                                self.purpose.append(value)
                            }
                            if let value = x.additionalDetails{
                                self.additionalInfo.append(value)
                            }
                            if let value = x.proposalDate{
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                                self.date.append(formatter.date(from: value)!)
                            }
                            if let value = x.proposalTime{
                                self.purposalTime.append(value)
                            }
                            if let value = x.requesteeFeedback{
                                self.requesteeFeedback.append(value)
                            }
                            if let value = x.managerFeedback{
                                self.managerFeedback.append(value)
                            }
                            if let value = x.managerRemark{
                                self.managerRemarks.append(value)
                            }
                        }
                        
                    }
                    
                    for x in self.date{
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd-MMMM-yyyy"
                        self.purposalDate.append(formatter.string(from: x))
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
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return purposalDate.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "msCell", for: indexPath) as! MeetingStatusCell
        
        cell.requestedByLbl.text = reqBy[indexPath.row]
        cell.purposeLbl.text = purpose[indexPath.row]
        cell.additionalDetailLbl.text = additionalInfo[indexPath.row]
        cell.purposalDateLbl.text = purposalDate[indexPath.row]
        cell.requesteeFeedbackLbl.text = requesteeFeedback[indexPath.row]
        cell.managerFeedbackLbl.text = managerFeedback[indexPath.row]
        cell.managerRemarksLbl.text = managerRemarks[indexPath.row]
        
        let changedString = purposalTime[indexPath.row].replacingOccurrences(of: ".", with: ":")
        cell.purposalTimeLbl.text = changedString
        
        return cell
    }
   
}

extension MeetingStatusTableViewController : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Meeting Status")
    }
}
