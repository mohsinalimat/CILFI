//
//  MenuTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 20/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

var menuNameForIndex = ""

class MenuCell : UITableViewCell{
    
    @IBOutlet weak var menuImg: UIImageView!
    @IBOutlet weak var menuName: UILabel!
}

@available(iOS 10.0, *)
class MenuTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    struct CellData {
        
        var opened = Bool()
        var title = String()
        var sectionData = [String]()
       
    }
    
    
    var gotoo = ""
    var tableViewData = [CellData]()
    
    @IBOutlet weak var menuTableView: UITableView!
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func viewDidLoad() {
       
//        print("menu headers \(headers)")
        setImage()
        nameLbl.text = defaults.string(forKey: "name")!
        
        super.viewDidLoad()
        
        
        profileImg.layer.borderWidth = 1.0
        profileImg.layer.masksToBounds = false
        profileImg.layer.borderColor = UIColor.white.cgColor
        profileImg.layer.cornerRadius = self.profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        
        if mainMenuList.count != 0 {
            for x in 1...mainMenuList.count{
                for (key, value) in fullmenu {
                    
                    if mainMenuList[x-1] == key{
                        tableViewData.append(CellData(opened: false, title: mainMenuList[x-1], sectionData: value as! [String]))
                    }
                    
                }
            }
            
//           print(mainMenuList)
//                  print(tableViewData)
        }
        
        menuTableView.dataSource = self
        menuTableView.delegate = self
    }
    
        override func viewDidAppear(_ animated: Bool) {
           
            
//            menuTableView.dataSource = self
//            menuTableView.delegate = self
        }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableViewData[section].opened == true{
            return tableViewData[section].sectionData.count + 1
        }else{
            return 1
        }
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dataIndex = indexPath.row - 1
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuCell
            cell.menuName.text = tableViewData[indexPath.section].title
            cell.backgroundColor = UIColor.flatWhite
            cell.accessoryType = .none
            cell.menuImg.image = UIImage(named: "menu-\(tableViewData[indexPath.section].title)-icon")
            cell.editingAccessoryType = .disclosureIndicator
            cell.menuName.font = cell.menuName.font.withSize(15)
            cell.menuImg.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuCell
            cell.menuName.text = tableViewData[indexPath.section].sectionData[dataIndex]
            cell.backgroundColor = UIColor.clear
            cell.accessoryType = .disclosureIndicator
            cell.menuName.font = cell.menuName.font.withSize(12)
            cell.menuImg.image = nil
            cell.menuImg.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
            
            return cell
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            if tableViewData[indexPath.section].opened == true {
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                menuTableView.reloadSections(sections, with: .none)
            }else{
                
                if tableViewData[indexPath.section].title == "Exit"{
                    exit(0)
                }else if tableViewData[indexPath.section].title == "About"{
                    tableViewData[indexPath.section].opened = false
                    goToPage(goto: "About")
                }else{
                    tableViewData[indexPath.section].opened = true
                    let sections = IndexSet.init(integer: indexPath.section)
                    menuTableView.reloadSections(sections, with: .none)
                }
                
                
            }
            
            
            
        }else{
            let option : String = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
            menuNameForIndex = option
            let trimmedString = option.replacingOccurrences(of: " ", with: "")
            
            goToPage(goto: trimmedString)
            
            AppDelegate.menuBool = false
        }
        
    }
    
    func goToPage(goto : String){
        
        
        switch goto{
        case "UserTracking":
            segue(goto: goto)
        case "AttendanceSummary":
            segue(goto: goto)
        case "RegularizeAttendance":
            segue(goto: goto)
        case "RegularizeAttendanceApproval":
            segue(goto: goto)
        case "RegularizeAttendanceStatus":
            segue(goto: goto)
        case "MyLeaves":
            segue(goto: goto)
        case "LeavesApproval":
            segue(goto: goto)
        case "SalaryLedger":
            segue(goto: goto)
        case "FormNo.16":
            segue(goto: goto)
        case  "ReimbursementClaim":
            segue(goto: goto)
        case  "ReimbursementStatus":
            segue(goto: goto)
        case  "ReimbursementApproval":
            segue(goto: goto)
        case  "ApproveRequest":
            segue(goto: goto)
        case  "ViewStatus":
            segue(goto: goto)
        case  "HelpDesk":
            segue(goto: goto)
        case  "NewLead":
            segue(goto: goto)
        case  "NearbyLead":
            segue(goto: goto)
        case  "LeadStatus":
            segue(goto: goto)
        case  "AssignLead":
            segue(goto: goto)
        case "LedgerAccount":
            segue(goto: goto)
        case "PrimarySale":
            segue(goto: goto)
        case "SecondarySale":
            segue(goto: goto)
        case "CustomerOutstanding":
            segue(goto: goto)
        case "Target":
            segue(goto: goto)
        case "Reporting":
            segue(goto: goto)
        case "MyVisit":
            segue(goto: goto)
        case "TeamVisit":
            segue(goto: goto)
        case "ReimbursementReport":
            segue(goto: goto)
        case "TrackAll":
            segue(goto: goto)
        case "EmployeeProfile":
            segue(goto: goto)
        case "FamilyDetails":
            segue(goto: goto)
        case "ReimbursementLedger":
            segue(goto: goto)
        case "TeamReimbursementLedger":
            segue(goto: goto)
        case "Absent>=3Days":
            segue(goto: goto)
        case "AttendanceDashboard":
            segue(goto: goto)
        case "LeavesSummary":
            segue(goto: goto)
        case "TeamLeavesSummary":
            segue(goto: goto)
        case "AttendanceReport":
            segue(goto: goto)
        case "TeamAttendanceReport":
            segue(goto: goto)
        case "TeamEmployeeProfile":
            segue(goto: goto)
        case "TeamFamilyDetails":
            segue(goto: goto)
        case "MeetingWithManager":
            segue(goto: goto)
        case "SalaryDetails":
            segue(goto: goto)
        case "TeamSalaryDetails":
            segue(goto: goto)
        case "TeamAttendanceSummary":
            segue(goto: goto)
        case "ApplyLoan":
            segue(goto: goto)
        case "LoanStatus":
            segue(goto: goto)
        case "LoanApproval":
            segue(goto: goto)
        case "ApplyAssets":
            segue(goto: goto)
        case "AssetsStatus":
            segue(goto: goto)
        case "AssetsApproval":
            segue(goto: goto)
        case "AssetsIssue":
            segue(goto: goto)
        case "ApplyStationery":
            segue(goto: goto)
        case "StationeryStatus":
            segue(goto: goto)
        case "StationeryIssue":
            segue(goto: goto)
        case "Request":
            segue(goto: goto)
        case "LetterStatus":
            segue(goto: goto)
        case "PaySlip":
            segue(goto: goto)
        case "LeaveRequest":
            segue(goto: goto)
        case "MarkAttendance":
            segue(goto: goto)
        case "NewsLetter":
            segue(goto: goto)
        default:
            SVProgressHUD.showInfo(withStatus: "Sorry, This feature isn't available yet.")
            SVProgressHUD.dismiss(withDelay: 1)
        }
    }
    
    func segue(goto : String){
        performSegue(withIdentifier: "goTo\(goto)", sender: self)
        
    }
    
    func setImage(){
        
        if let imgurl = defaults.string(forKey: "imgURL"){
            if imgurl != ""{
                profileImg.sd_setImage(with: URL(string: "\(LoginDetails.hostedIP)\(imgurl)"))
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTeamAttendanceSummary"{
            let vc = segue.destination as! AttendanceSummariesViewController
            
            vc.manager = "Y"
        }
    }
}

