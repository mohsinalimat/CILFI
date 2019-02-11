//
//  AttendanceSummaryTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 13/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import DatePickerDialog
import Alamofire
import SVProgressHUD

class CustomAttendanceCell : UITableViewCell{
    
    @IBOutlet weak var profileImg: UIImageView!{
        didSet{
            profileImg.layer.borderWidth = 1.0
            profileImg.layer.masksToBounds = false
            profileImg.layer.borderColor = UIColor.white.cgColor
            profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
            profileImg.clipsToBounds = true
        }
    }
    @IBOutlet weak var empCodelbl: UILabel!
    @IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var addresslbl: UILabel!
    @IBOutlet weak var checkTypeImg: UIImageView!
}

class AttendanceSummaryTableViewController: UITableViewController {
    
    var address = [String]()
    var empcode = [String]()
    var time = [String]()
    var markType = [String]()
    let formatter = DateFormatter()
    var img = [String]()
    
    var date = ""
    var user = ""
    @IBOutlet weak var datelbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        datelbl.text = selectedDate
//        
//
        
    }
    override func viewWillAppear(_ animated: Bool) {
        SVProgressHUD.show()
        updateTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    

    @IBAction func dateBtn(_ sender: UIButton) {
        
        
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                
                self.formatter.dateFormat = "dd-MM-yyyy"
                self.datelbl.text = self.formatter.string(from: dt)
                self.formatter.dateFormat = "yyyy-MM-dd"
                self.date = self.formatter.string(from: dt)
                self.updateTable()
               SVProgressHUD.show()
            }
        }
    }
    
    
    
    
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return empcode.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomAttendanceCell
        
        let add = address[indexPath.row]
        cell.addresslbl.text = add
        cell.empCodelbl.text = empcode[indexPath.row]
        cell.timelbl.text = time[indexPath.row]
        if markType[indexPath.row] == "M"{
            cell.checkTypeImg.image = UIImage(named: "smartphone-fingerprint")
        }else if markType[indexPath.row] == "D"{
            cell.checkTypeImg.image = UIImage(named: "imac")
        }
        print("\(LoginDetails.hostedIP)/\(img[indexPath.row])")
        cell.profileImg.sd_setImage(with:  URL(string : ("\(LoginDetails.hostedIP)/\(img[indexPath.row])")), placeholderImage: UIImage(named: "menu-user-icon"))
        return cell
    }
    
    
    
    func updateTable(){
        
        
        
        let atndTrackURL = "\(LoginDetails.hostedIP)/sales/AttendanceTracker"
        let headers : [String:String] = ["username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : user, "datetime" : date]
        
        getAttendanceTrackData(url: atndTrackURL, header: headers)
        
        
    }
    
    
    //MARK: - Networking - ALAMO FIRE
    /***************************************************************/
    
    func getAttendanceTrackData(url : String, header : [String:String]){
        address = [String]()
        empcode = [String]()
        time = [String]()
        markType = [String]()
        img = [String]()
        print (header)
        Alamofire.request(url, method: .get, headers : header).responseJSON{
            response in
            
            let attnData = response.data!
            let attnJSON = response.result.value
            
            if response.result.isSuccess{
                print(attnJSON)
                do{
                    SVProgressHUD.dismiss()
                     let attndTrack = try JSONDecoder().decode(AttendanceTrackRoot.self, from: attnData)
                    //line chart
                    
                    for x in attndTrack.userTracks{
                        if let add = x.address{
                          self.address.append(add)
                        }else{print("Unable to fetch address")}
                        
                        if let emp = x.empCode{
                            self.empcode.append(emp)
                        }else{print("Unable to fetch emp")}
                        
                        if let time = x.checkDate{
                            let formatter = DateFormatter()
                            formatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
                            if let date = formatter.date(from: time){
                                formatter.dateFormat = "hh:mm a"
                                self.time.append(formatter.string(from: date))
                            }
                            
                            
                        }else{print("Unable to fetch address")}
                        
                        if let markT = x.checkTypee{
                            self.markType.append(markT)
                        }else{print("Unable to fetch markType")}
                        
                        if let profile = x.imgURL{
                            self.img.append(profile)
                        }else{print("Unable to fetch profileImage")}
                    }
                    //                    print(self.empName)
                    //                    print(self.leaveType)
                    
                    
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
