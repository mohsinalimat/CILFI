//
//  MeetingApprovalTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 23/08/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import MGSwipeTableCell
import Alamofire
import DropDown
import SVProgressHUD
import SwiftyJSON
class MeetingApprovalCell : MGSwipeTableCell{
    
    @IBOutlet weak var requestedByLbl: UILabel!
    @IBOutlet weak var purposeLbl: UILabel!
    @IBOutlet weak var additionalDetailLbl: UILabel!
    @IBOutlet weak var purposalDateLbl: UILabel!
    @IBOutlet weak var purposalTimeLbl: UILabel!
    
}

class MeetingApprovalTableViewController: UITableViewController{
 
    var index = -1
    
    
    var date = [Date]()
    var code = [String]()
    var name = [String]()
    var additionalDetails = [String]()
    var meetingWith = [String]()
    var proposalDate = [String]()
    var proposalTime = [String]()
    var purpose = [String]()
    var requestedBy = [String]()
    var meetingLocation = [String]()
    var status = [String]()
    var rowSeq = [String]()
    var requesteeFeedback = [String]()
    var managerFeedback = [String]()
    var managerRemark = [String]()
    
    
    var feedbackTF : UITextField?
    var remarksTF : UITextField?
    
    @IBOutlet weak var statusBtn: UIButton!
    @IBAction func statusBtn(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.dataSource = ["Pending","Approved","Rejected"]
        dropDown.anchorView = view
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            self.statusBtn.setTitle(item, for: .normal)
            self.getStatus(state: item)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusBtn.setTitle("Pending", for: .normal)
        getStatus(state: "Pending")
    }
    
    
    
    func getStatus(state : String){
        date = [Date]()
        code = [String]()
        name = [String]()
        additionalDetails = [String]()
        meetingWith = [String]()
        proposalDate = [String]()
        proposalTime = [String]()
        purpose = [String]()
        requestedBy = [String]()
        meetingLocation = [String]()
        status = [String]()
        rowSeq = [String]()
        requesteeFeedback = [String]()
        managerFeedback = [String]()
        managerRemark = [String]()
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/meetingapproval", method: .get, headers : headers).responseJSON{
            response in
            
            let meetData = response.data!
            let meetJSON = response.result.value
            
            if response.result.isSuccess{
                //                print("UserJSON: \(visitJSON)")
                do{
                    let meeting = try JSONDecoder().decode(MeetingRequestRoot.self, from: meetData)
                    
                    for x in meeting.mrData{
                        if x.status == state{
                            if let value = x.code{
                                self.code.append(value)
                            }
                            
                            if let value = x.name{
                                self.name.append(value)
                            }
                            
                            if let value = x.additionalDetails{
                                self.additionalDetails.append(value)
                            }
                            
                            if let value = x.meetingWith{
                                self.meetingWith.append(value)
                            }
                            
                            if let value = x.purpose{
                                self.purpose.append(value)
                            }
                            
                            if let value = x.requestedBy{
                                self.requestedBy.append(value)
                            }
                            
                            if let value = x.meetingLocation{
                                self.meetingLocation.append(value)
                            }
                            
                            if let value = x.status{
                                self.status.append(value)
                            }
                            
                            if let value = x.rowSeq{
                                self.rowSeq.append(value)
                            }
                            
                            if let value = x.managerFeedback{
                                self.managerFeedback.append(value)
                            }
                            
                            if let value = x.managerRemark{
                                self.managerRemark.append(value)
                            }
                            
                            if let value = x.requesteeFeedback{
                                self.requesteeFeedback.append(value)
                            }
                            
                            if let value = x.proposalDate{
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                                self.date.append(formatter.date(from: value)!)
                            }
                            if let value = x.proposalTime{
                                self.proposalTime.append(value)
                            }
                        }
                        
                        for x in self.date{
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd"
                            self.proposalDate.append(formatter.string(from: x))
                        }
                        SVProgressHUD.dismiss()
                        self.tableView.reloadData()
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

    
    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rowSeq.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "maCell", for: indexPath) as! MeetingApprovalCell
        
       
       
        let more = MGSwipeButton(title: "Approve/Reject ",icon: UIImage(named: "table-decision"), backgroundColor: UIColor.flatPlum) {
            (sender: MGSwipeTableCell!) -> Bool in

            if self.managerFeedback[indexPath.row] == "" && self.managerRemark[indexPath.row] == ""{
                let alert = UIAlertController(title: "Approve/Reject", message: "Approve or reject meeting request. Please also provide feedback and remarks below if any.", preferredStyle: .alert)
                alert.addTextField(configurationHandler: self.feedbackTF)
                alert.addTextField(configurationHandler: self.remarksTF)
                let accept = UIAlertAction(title: "Accept", style: .default, handler: self.acceptHandler)
                let reject = UIAlertAction(title: "Reject", style: .default, handler: self.rejectHandler)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(accept)
                alert.addAction(reject)
                alert.addAction(cancel)
                self.index = indexPath.row
                self.present(alert, animated: true)
            }else if self.managerFeedback[indexPath.row] != "" && self.managerRemark[indexPath.row] == ""{
                let alert = UIAlertController(title: "Approve/Reject", message: "Approve or reject meeting request. Please also provide your remarks below if any.", preferredStyle: .alert)
                self.feedbackTF?.text = self.managerFeedback[indexPath.row]
                alert.addTextField(configurationHandler: self.remarksTF)
                let accept = UIAlertAction(title: "Accept", style: .default, handler: self.acceptHandler)
                let reject = UIAlertAction(title: "Reject", style: .default, handler: self.rejectHandler)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(accept)
                alert.addAction(reject)
                alert.addAction(cancel)
                self.index = indexPath.row
                self.present(alert, animated: true)
            }else if self.managerFeedback[indexPath.row] == "" && self.managerRemark[indexPath.row] != ""{
                let alert = UIAlertController(title: "Approve/Reject", message: "Approve or reject meeting request. Please also provide your feedback below if any.", preferredStyle: .alert)
                self.remarksTF?.text = self.managerRemark[indexPath.row]
                alert.addTextField(configurationHandler: self.feedbackTF)
                let accept = UIAlertAction(title: "Accept", style: .default, handler: self.acceptHandler)
                let reject = UIAlertAction(title: "Reject", style: .default, handler: self.rejectHandler)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(accept)
                alert.addAction(reject)
                alert.addAction(cancel)
                self.index = indexPath.row
                self.present(alert, animated: true)
            }else if self.managerFeedback[indexPath.row] != "" && self.managerRemark[indexPath.row] != ""{
                let alert = UIAlertController(title: "", message: "You already provided feedack and remarks to this meeting request.", preferredStyle: .alert)

                let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(cancel)
                self.present(alert, animated: true)
            }
            return true

        }
        more.centerIconOverText()
        
        cell.requestedByLbl.text = name[indexPath.row]
        
        cell.purposeLbl.text = purpose[indexPath.row]
        
        cell.additionalDetailLbl.text = additionalDetails[indexPath.row]
        
        cell.purposalDateLbl.text = proposalDate[indexPath.row]


        let changedString = proposalTime[indexPath.row].replacingOccurrences(of: ".", with: ":")
        cell.purposalTimeLbl.text = changedString
        
        
        cell.leftButtons = [more]
        
        
        
        return cell
    }
    
    func feedbackTF(textField : UITextField){
        feedbackTF = textField
        feedbackTF?.placeholder = "feedback(if any)"
    }
    
    func remarksTF(textField : UITextField){
        remarksTF = textField
        remarksTF?.placeholder = "remarks(if any)"
    }
    

    func acceptHandler(alert : UIAlertAction){
        setFeedback(fb: (feedbackTF?.text)!, remarks: (remarksTF?.text)!, status: "A")
    }
    
    func rejectHandler(alert : UIAlertAction){
         setFeedback(fb: (feedbackTF?.text)!, remarks: (remarksTF?.text)!, status: "R")
    }
    
    func setFeedback(fb : String, remarks : String, status : String){
        SVProgressHUD.show()
        
        let params = ["ManagerFeedback" : fb, "ManagerRemark":remarks,"Status":status, "Rowseq":rowSeq[index]]
        
        print(params)
        Alamofire.request("\(LoginDetails.hostedIP)/Sales/MeetingApproval" , method : .put,  parameters : params, encoding: JSONEncoding.default , headers: headers).responseJSON{
            response in
            
            
            let meetingJSON : JSON = JSON(response.result.value)
            
            if response.result.isSuccess{
                
                if meetingJSON["returnType"].string == "Successfully Updated....!!!!"{
                    SVProgressHUD.showSuccess(withStatus: "Successfully send the meeting feedback.")
                    self.getStatus(state: "Pending")
                }else{
                    SVProgressHUD.showError(withStatus: meetingJSON["returnType"].string)
                }
                print("Success! Posting the Leave Detail data")
                
                
                //                print(meetingJSON)
                
            }
                
            else{
                //print("Error: \(response.result.error!)")
                print(meetingJSON)
            }
            
        }
        
    }
    
    
}

extension MeetingApprovalTableViewController : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Meeting Manager Approval")
    }
}
