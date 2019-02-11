//
//  MeetingFeedbackTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 23/08/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SVProgressHUD
import Alamofire
import MGSwipeTableCell
import SwiftyJSON

class MeetingFeedbackCell : MGSwipeTableCell{
    
    @IBOutlet weak var meetingWithLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var feedbackLbl: UILabel!
    
}

class MeetingFeedbackTableViewController: UITableViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFeedback()
    }
    
    
    
    func getFeedback(){
        
       
        
        SVProgressHUD.show()
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/meetingrequest", method: .get, headers : headers).responseJSON{
            response in
            
            let meetData = response.data!
            let meetJSON = response.result.value
            
            if response.result.isSuccess{
                //                print("UserJSON: \(visitJSON)")
                do{
                    let meeting = try JSONDecoder().decode(MeetingRequestRoot.self, from: meetData)
                    
                    for x in meeting.mrData{
                        
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
        return date.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        print("feedback \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "mfCell", for: indexPath) as! MeetingFeedbackCell
        
        
        let more = MGSwipeButton(title: "Feedback",icon: UIImage(named: "table-feedback"), backgroundColor: UIColor.flatSandDark) {
            (sender: MGSwipeTableCell!) -> Bool in
            
            let alert = UIAlertController(title: "FeedBack", message: "Please provide your feedback below.", preferredStyle: .alert)
            alert.addTextField(configurationHandler: self.feedbackTF)
            let okAction = UIAlertAction(title: "Send Feedback", style: .default, handler: self.okHandler)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancel)
            self.index = indexPath.row
            self.present(alert, animated: true)
            return true
            
        }
        
       
        
        more.centerIconOverText()
        
        cell.dateLbl.text = proposalDate[indexPath.row]
        cell.meetingWithLbl.text = meetingWith[indexPath.row]
        cell.timeLbl.text = proposalTime[indexPath.row]
        cell.feedbackLbl.text = requesteeFeedback[indexPath.row]
        
        if requesteeFeedback[indexPath.row] == ""{
             cell.leftButtons = [more]
        }
       
       
        cell.leftSwipeSettings.transition = .drag
        
        
        
        
        
        
        return cell
    }
    
    
    func feedbackTF(textField : UITextField){
        feedbackTF = textField
        feedbackTF?.placeholder = "feedback(if any)"
    }
    
    func okHandler(alert : UIAlertAction){
        setFeedback(fb: (feedbackTF?.text)!)
    }
    
    
    func setFeedback(fb : String){
        SVProgressHUD.show()
        
        let params = ["ManagerFeedback":managerFeedback[index],"RequesteeFeedback":fb,"AdditionalDetail":additionalDetails[index],"MeetingWith": meetingWith[index],"ProposalDate":proposalDate[index],"ProposalTime":proposalTime[index],"Purpose":purpose[index],"MeetingLocation":meetingLocation[index],"Rowseq":rowSeq[index]]
        
        print(params)
        Alamofire.request("\(LoginDetails.hostedIP)/sales/meetingrequest" , method : .put,  parameters : params, encoding: JSONEncoding.default , headers: headers).responseJSON{
            response in
            
            
            let meetingJSON : JSON = JSON(response.result.value)
            
            if response.result.isSuccess{
                
                if meetingJSON["returnType"].string == "Successfully Updated....!!!!"{
                    SVProgressHUD.showSuccess(withStatus: "Successfully send the meeting feedback.")
                    self.clearValues()
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
    
    
    
    func clearValues(){
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
        
        
        getFeedback()
    }
    
}





extension MeetingFeedbackTableViewController : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Meeting Feedback")
    }
}
