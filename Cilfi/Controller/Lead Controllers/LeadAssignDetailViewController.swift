//
//  LeadAssignDetailViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 13/07/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Eureka
import Alamofire
import SVProgressHUD
import GooglePlaces
import ImageRow
import SwiftyJSON

class LeadAssignDetailViewController: FormViewController {

    let placePickerController = GMSAutocompleteViewController()
    
    var teamDetail = [String:String]()
    
    var id = ""
    var code = [String]()
    var name = [String]()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       SVProgressHUD.show()
        createForm()
    }

    
    
    func createForm(){
       
        
        Alamofire.request("\(LoginDetails.hostedIP)/Sales/leadapproval", method: .get, headers : headers).responseJSON{
            response in
            
            let leadData = response.data!
            let leadJSON = response.result.value
            if response.result.isSuccess{
                //                    print("UserTrackJSON: \(leadJSON)")
                do{
                    let lead = try JSONDecoder().decode(LeadDataRoot.self, from: leadData)
                    if self.id != ""{
                    for x in lead.leadData{
                        
                        if x.leadID == self.id{
                            
                            self.form +++ Section("Employee Info"){
                                $0.header?.height = {40}
                                $0.footer?.height = {0}
                                SVProgressHUD.dismiss()
                                }
                                
                                <<< LabelRow().cellSetup({ (cell, row) in
                                        row.title = "Created By Code"
                                        if let value = x.createdByCode{
                                            row.value = value
                                            Lead.createByCode = value
                                        }
                                    
                                })
                            
                                <<< LabelRow().cellSetup({ (cell, row) in
                                    row.title = "Created By Name"
                                    if let value = x.createdByName{
                                        row.value = value
                                        Lead.createdByName = value
                                    }
                                    
                                })
                            
                                <<< LabelRow().cellSetup{(cell, row) in
                                    row.title = "Lead ID"
                                    if let value = x.leadID{
                                        row.value = value
                                        Lead.leadID = value
                                    }
                                    
                            }
                            
                                <<< PickerInlineRow<String>().cellSetup({ (cell, row) in
                                    row.title = "Lead Type"
                                    row.options = ["Primary","Secondary"]
                                    row.value = "----- Select -----"
                                    row.onChange({ (status) in
                                        if let stat = status.value{
                                            if stat == "Secondary"{
                                                Lead.leadType = "S"
                                            }else if stat == "Primary"{
                                                Lead.leadType = "P"
                                            }
                                        }
                                    })
                                    if let value = x.leadType{
                                        if value != ""
                                        {
                                                if value == "Primary Lead"{
                                                    Lead.leadType = "P"
                                                    row.value = "Primary"
                                                
                                                }else if value == "Secondary Lead"{
                                                    Lead.leadType = "S"
                                                    row.value = "Secondary"
                                                   
                                                }
                                            }
                                        }
                                    })
                            
                            
                                <<< PickerInlineRow<String>().cellSetup({ (cell, row) in
                                    row.title = "Lead Status"
                                    row.options = ["New","Follow Up","Converted","Lost"]
                                    row.onChange({ (status) in
                                        if let stat = status.value{
                                            if stat == "New"{
                                                Lead.leadStatus = "N"
                                            }else if stat == "Follow Up"{
                                                Lead.leadStatus = "F"
                                            }else if stat == "Converted"{
                                                Lead.leadStatus = "C"
                                            }else if stat == "Lost"{
                                                Lead.leadStatus = "L"
                                            }
                                            
                                        }
                                    })
                                    if let value = x.status{
                                        
                                        if value == ""
                                        {
                                            row.value = "----- Select -----"
                                            
                                        }
                                        else {
                                            if value == "New"{
                                                Lead.leadStatus = "N"
                                                row.value = "New"
                                            }else if value == "Follow Up"{
                                                Lead.leadStatus = "F"
                                                row.value = "Follow Up"
                                            }else if value == "Converted"{
                                                Lead.leadStatus = "C"
                                                row.value = "Converted"
                                            }else if value == "Lost"{
                                                Lead.leadStatus = "L"
                                                row.value = "Lost"
                                            }
                                        }
                                    }
                                })
                            
                                <<< DateInlineRow().cellSetup({ (cell, row) in
                                    row.title = "Visit Date"
                                    row.onChange({ (date) in
                                        row.dateFormatter!.dateFormat = "dd/MM/yyyy"
                                        row.value = date.value!
                                        cell.textLabel?.textColor = UIColor.black
                                        row.dateFormatter!.dateFormat = "yyyy/MM/dd"
                                        Lead.visitDate = row.dateFormatter!.string(from: date.value!)
                                    })
                                    if let value = x.visitDate{
                                        if value != ""
                                        {
                                            row.dateFormatter!.dateFormat = "dd/MM/yyyy"
                                            if let date = row.dateFormatter!.date(from: value){
                                                row.dateFormatter?.dateFormat = "dd/MM/yyyy"
                                                row.value = date
                                                row.minimumDate = date
                                                row.dateFormatter?.dateFormat = "yyyy/MM/dd"
                                                Lead.visitDate = (row.dateFormatter?.string(from: date))!
                                            }
                                            
                                            
                                            
                                            
                                        }else{
                                            Lead.visitDate = ""
                                        }
                                    }
                                    print(row.value)
                                    print(Lead.visitDate)
                                })
                            
                                +++ Section("Assign another executive to this lead (optional)"){
                                    $0.header?.height = {20}
                                    $0.footer?.height = {0}
                                    
                                }
                                <<< PickerInlineRow<String>().cellSetup({ (cell, row) in
                                    row.title = "Change Executive"
                                    row.value = "--- Select ---"
                                    row.options = self.code
                                    row.onChange({ (status) in
                                        if let eName: LabelRow = self.form.rowBy(tag: "eName"){
                                            if let index = row.options.index(of: status.value!){
                                                eName.value = self.name[index]
                                                Lead.executiveName = self.name[index]
                                                eName.reload()
                                            }
                                            
                                        }
                                        if let sCode: LabelRow = self.form.rowBy(tag: "sCode"){
                                            print()
                                            sCode.value = status.value
                                            Lead.salesmanCode = status.value!
                                            sCode.reload()
                                        }
                                        
                                    })
                                        
                                    })
                                
                                +++ Section(""){
                                    $0.header?.height = {0}
                                    $0.footer?.height = {0}
                                   
                                }
                                
                                <<< LabelRow().cellSetup({ (cell, row) in
                                    row.title = "Salesman Code"
                                    row.tag = "sCode"
                                    if let value = x.createdByCode{
                                        row.value = value
                                        Lead.salesmanCode = value
                                    }
                                    
                                })
                                
                                <<< LabelRow(){row in
                                    row.tag = "eName"
                                    row.title = "Executive Name"
                                    if let value = x.executiveName{
                                        row.value = value
                                        Lead.executiveName = value
                                    }
                            }
                            
                            
                                <<< PickerInlineRow<String>().cellSetup({ (cell, row) in
                                    row.title = "Source / Ref. Information"
                                    row.options = ["Director","Colleague","Customer Referance","Print Media", "Others"]
                                    if let value = x.reffsourceTitle{
                                        if value == ""
                                        {
                                            row.value = "----- Select -----"
                                            row.onChange({ (val) in
                                                if let stat = val.value{
                                                    Lead.srInfo = stat
                                                    
                                                }
                                            })
                                            
                                        }
                                        else {
                                            row.value = value
                                            Lead.srInfo = value
                                        }
                                    }
                                })
                                
                                <<< TextRow(){ row in
                                    row.title = "Source/Ref. Name"
                                    row.placeholder = "if any"
                                   
                                    if let value = x.reffSource{
                                        row.value = value
                                        Lead.srName = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Lead.srName = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Lead.srName = value
                                            }
                                        }
                                    })
                            
                                +++ Section("Employee Info"){
                                    $0.header?.height = {30}
                                    $0.footer?.height = {0}
                            }
                            
                                <<< TextRow(){row in
                                    row.title = "Dealer/Distributor Firm"
                                    row.placeholder = "enter name"
                                    row.add(rule: RuleRequired())
                                    if let value = x.fname{
                                        row.value = value
                                        Lead.ddFirm = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Lead.ddFirm = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Lead.ddFirm = value
                                            }
                                        }
                                    })
                                
                                
                                
                                <<< TextRow(){row in
                                    row.title = "Address"
                                    row.placeholder = "enter address"
                                    row.add(rule: RuleRequired())
                                    if let value = x.firmAddress{
                                        row.value = value
                                        Lead.address = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Lead.address = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Lead.address = value
                                            }
                                        }
                                    })
                                
                                
                                <<< TextRow(){row in
                                    row.title = "City"
                                    row.placeholder = "enter city"
                                    row.add(rule: RuleRequired())
                                    if let value = x.fcity{
                                        row.value = value
                                        Lead.city = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Lead.city = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Lead.city = value
                                            }
                                        }
                                    })
                                
                                <<< TextRow(){row in
                                    row.title = "State"
                                    row.placeholder = "enter state"
                                    row.add(rule: RuleRequired())
                                    if let value = x.firmState{
                                        row.value = value
                                        Lead.state = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Lead.state = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Lead.state = value
                                            }
                                        }
                                    })
                                
                                <<< TextRow(){row in
                                    row.title = "Country"
                                    row.placeholder = "enter address"
                                    row.add(rule: RuleRequired())
                                    if let value = x.country{
                                        row.value = value
                                        Lead.country = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Lead.country = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Lead.country = value
                                            }
                                        }
                                    })
                                
                                <<< PhoneRow(){row in
                                    row.title = "Pincode"
                                    row.tag = "pin"
                                    row.add(rule: RuleRequired())
                                    row.add(rule: RuleExactLength(exactLength: 6))
                                    if let value = x.pin{
                                        row.value = value
                                        Lead.pincode = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Lead.pincode = ""
                                            
                                            
                                            
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Lead.pincode = value
                                                
                                            }
                                        }
                                    })
                                
                               
                                
                                <<< TextRow(){row in
                                    row.title = "Website"
                                    row.placeholder = "website"
                                    row.add(rule: RuleRequired())
                                    if let value = x.fweb{
                                        row.value = value
                                        Lead.website = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Lead.website = ""
                                         }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Lead.website = value
                                                
                                            }
                                        }
                                    })
                                
                                +++ Section(){
                                    $0.header?.height = {30}
                                    $0.footer?.height = {0}
                            }
                            
                                <<< TextRow(){row in
                                    row.title = "Contact Person Name"
                                    row.placeholder = "name"
                                    row.add(rule: RuleRequired())
                                    if let value = x.fcontactPerson{
                                        row.value = value
                                        Lead.contactPersonName = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Lead.contactPersonName = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Lead.contactPersonName = value
                                            }
                                        }
                                    })
                                
                                <<< TextRow(){row in
                                    row.title = "Designation"
                                    row.placeholder = "designation"
                                    row.add(rule: RuleRequired())
                                    if let value = x.firmcontactPersonDesg{
                                        row.value = value
                                        Lead.designation = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Lead.designation = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Lead.designation = value
                                            }
                                        }
                                    })
                                
                                
                                <<< PhoneRow(){row in
                                    row.title = "Mobile Number"
                                    row.placeholder = "XXXXX"
                                    row.add(rule: RuleExactLength(exactLength: 10))
                                    row.add(rule: RuleRequired())
                                    if let value = x.firmContactPersonMobile{
                                        row.value = value
                                        Lead.mobileNo = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Lead.mobileNo = ""
                                            
                                            
                                            
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Lead.mobileNo = value
                                                
                                            }
                                        }
                                    })
                                
                                
                                <<< EmailRow().cellSetup{cell, row in
                                    row.title = "Email ID"
                                    row.placeholder = "xyz@abc.com"
                                    row.add(rule: RuleRequired())
                                    row.add(rule: RuleEmail())
                                    if let value = x.fcontactPersonEmail{
                                        row.value = value
                                        Lead.emailID = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Lead.contactPersonEmailID = ""
                                            
                                            
                                            
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Lead.contactPersonEmailID = value
                                                
                                            }
                                        }
                                    })
                                
                                
                                
                                <<< DateInlineRow(){ row in
                                    
                                    row.title = "Next Follow-up Date"
                                    row.dateFormatter?.dateFormat = "MM/dd/yyyy"
                                    
                                    if let value = x.nextDate{
                                        row.dateFormatter?.dateFormat = "dd/MM/yyyy hh:mm:ss a"
                                        if let date = row.dateFormatter!.date(from: value){
                                            row.dateFormatter?.dateFormat = "dd/MM/yyyy"
                                            if let dateString = row.dateFormatter?.string(from: date){
                                                row.dateFormatter?.dateFormat = "dd/MM/yyyy"
                                                row.value = row.dateFormatter!.date(from: dateString)
                                                Lead.nextFollowUpDate = dateString
                                            }
                                        }
                                    }
                                    row.onChange({ (visitDate) in
                                        visitDate.dateFormatter?.dateFormat = "yyyy/MM/dd"
                                        Lead.nextFollowUpDate = row.dateFormatter!.string(from: visitDate.value!)
                                    })
                                }
                                
                                <<< TimeInlineRow(){ row in
                                    row.title = "Next Follow-up Time"
                                    if let value = x.nextDate{
                                        row.dateFormatter?.dateFormat = "dd/MM/yyyy hh:mm:ss a"
                                        if let date = row.dateFormatter!.date(from: value){
                                            row.dateFormatter?.dateFormat = "hh:mm:ss a"
                                            if let dateString = row.dateFormatter?.string(from: date){
                                                row.dateFormatter?.dateFormat = "hh:mm:ss a"
                                                row.value = row.dateFormatter!.date(from: dateString)
                                                Lead.nextFollowUpTime = dateString
                                            }
                                        }
                                    }
                                    row.onChange({ (visitTime) in
                                        Lead.nextFollowUpTime = visitTime.dateFormatter!.string(from: visitTime.value!)
                                    })
                                    
                            }
                        
                                +++ Section("Firm Info"){
                                    $0.header?.height = {30}
                                    $0.footer?.height = {0}
                                }
                                
                                <<< TextRow ().cellSetup{ (cell, row) in
                                    row.title = "PAN of the firm"
                                    row.placeholder = "enter PAN number"
                                    row.add(rule: RuleRequired())
                                    row.add(rule: RuleExactLength(exactLength: 10))
                                    if let value = x.fpan{
                                        row.value = value
                                        Company.pan = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Company.pan = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Company.pan = value
                                            }
                                        }
                                    })
                                
                                <<< TextRow ().cellSetup{ (cell, row) in
                                    row.title = "GSTIN of firm"
                                    row.placeholder = "enter GSTIN number"
                                    row.add(rule: RuleRequired())
                                    row.add(rule: RuleExactLength(exactLength: 15))
                                    if let value = x.fgstin{
                                        row.value = value
                                        Company.gstin = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Company.gstin = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Company.gstin = value
                                            }
                                        }
                                    })
                            
                                <<< PickerInlineRow<String>() {
                                    $0.title = "Firm Type"
                                    $0.options = ["Proprietorship", "Partnership", "Others"]
                                    
                                    if let value = x.ftype{
                                        
                                        if value == ""
                                        {
                                            $0.value = "----- Select -----"
                                            
                                        }
                                        else {
                                            Company.fType = value
                                            if value == "H"{
                                               $0.value = "Proprietorship"
                                            }else if value == "P"{
                                                $0.value = "Partnership"
                                            }else if value == "Others"{
                                                $0.value = "O"
                                            }
                                        }
                                    }
                                    
                                    $0.onChange({ (firmtype) in
                                        if let ftype = firmtype.value{
                                            if ftype == "Proprietorship"{
                                                Company.fType = "H"
                                            }else if ftype == "Partnership"{
                                                Company.fType = "P"
                                            }else if ftype == "Others"{
                                                Company.fType = "O"
                                            }
                                            
                                        }
                                        
                                    })
                            }
                            
                            
                                <<< PhoneRow(){row in
                                    row.title = "Years In Business"
                                    row.placeholder = "no. of yrs"
                                    row.add(rule: RuleRequired())
                                    row.add(rule: RuleMaxLength(maxLength: 3))
                                    if let value = x.fage{
                                        row.value = value
                                        Company.yearsInBusiness = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Company.yearsInBusiness = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                
                                                Company.yearsInBusiness = value
                                            }
                                        }
                                    })
                            
                                +++ Section("Annual Turnovers"){
                                    
                                    $0.header?.height = {30}
                                    $0.footer?.height = {0}
                                    
                                }
                                +++ Section("Turnover 16-17"){
                                    $0.header?.height = {10}
                                    $0.footer?.height = {0}
                                }
                                
                                <<< IntRow().cellSetup{ (cell, row) in
                                    row.title = "Annual Turnover (16-17)"
                                    row.placeholder = "estimate in ₹"
                                    row.add(rule: RuleRequired())
                                    if let value = x.turnOver1{
                                        row.value = Int(value)
                                        Company.annualTurnover1 = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Company.annualTurnover1 = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Company.annualTurnover1 = String(value)
                                            }
                                        }
                                    })
                                
                                +++ Section("Turnover 15-16"){
                                    $0.header?.height = {10}
                                    $0.footer?.height = {0}
                                }
                                
                                <<< IntRow().cellSetup{ (cell, row) in
                                    row.title = "Annual Turnover (15-16)"
                                    row.placeholder = "estimate in ₹"
                                    row.add(rule: RuleRequired())
                                    if let value = x.turnOver2{
                                        row.value = Int(value)
                                        Company.annualTurnover2 = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Company.annualTurnover2 = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Company.annualTurnover2 = String(value)
                                            }
                                        }
                                    })
                                
                                +++ Section("Turnover 14-15"){
                                    $0.header?.height = {10}
                                    $0.footer?.height = {0}
                                }
                                
                                <<< IntRow().cellSetup{ (cell, row) in
                                    row.title = "Annual Turnover (14-15)"
                                    row.placeholder = "estimate in ₹"
                                    row.add(rule: RuleRequired())
                                    if let value = x.turnOver3{
                                        row.value = Int(value)
                                        Company.annualTurnover3 = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Company.annualTurnover3 = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Company.annualTurnover3 = String(value)
                                            }
                                        }
                                    })
                                
                                
                            
                                +++ Section("Shop Info"){
                                    $0.header?.height = {30}
                                    $0.footer?.height = {0}
                                }
                                
                                <<< IntRow().cellSetup{ (cell, row) in
                                    row.title = "Shop Area"
                                    row.placeholder = "in Sq.Mtrs"
                                    row.add(rule: RuleRequired())
                                    if let value = x.farea{
                                        row.value = Int(value)
                                        Company.shopArea = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Company.shopArea = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Company.shopArea = String(value)
                                            }
                                        }
                                    })
                            
                                <<< SegmentedRow<String>().cellSetup({ (cell, row) in
                                    row.title = "Shop Property Type"
                                    row.options = ["Rented", "Owned"]
                                    row.onChange({ (status) in
                                        if let stat = status.value{
                                            if stat == "Rented"{
                                                Company.shopOwnership = "R"
                                            }else if stat == "Owned"{
                                                Company.shopOwnership = "O"
                                            }
                                            
                                        }
                                    })
                                    if let value = x.fpropType{
                                        
                                            Company.shopOwnership = value
                                            
                                            if value == "R"{
                                                row.value = "Rented"
                                                
                                            }else if value == "O"{
                                                row.value = "Owned"
                                                
                                            }
                                            
                                        }
                                    })
                            
                            
                                <<< IntRow ().cellSetup{ (cell, row) in
                                    row.title = "Godown Area"
                                    row.placeholder = "in Sq.Mtrs"
                                    row.add(rule: RuleRequired())
                                    if let value = x.fGodown{
                                        row.value = Int(value)
                                        Company.godownArea = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Company.godownArea = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Company.godownArea = String(value)
                                            }
                                        }
                                    })
                            
                                <<< SegmentedRow<String>().cellSetup({ (cell, row) in
                                    row.title = "Godown Property Type"
                                    row.options = ["Rented", "Owned"]
                                    row.onChange({ (status) in
                                        if let stat = status.value{
                                            if stat == "Rented"{
                                                Company.godownOwnerShip = "R"
                                            }else if stat == "Owned"{
                                                Company.godownOwnerShip = "O"
                                            }
                                            
                                        }
                                    })
                                    
                                    if let value = x.fGodownPropType{
                                        
                                       
                                            Company.godownOwnerShip = value
                                            
                                            if value == "R"{
                                                row.value = "Rented"
                                                
                                            }else if value == "O"{
                                                row.value = "Owned"
                                                
                                            }
                                            
                                           
                                        }
                                })
                            
                            
                                +++ Section("Remarks (if any)"){
                                    $0.header?.height = {10}
                                    $0.footer?.height = {0}
                                }
                                
                                <<< TextAreaRow().cellSetup({ (cell, row) in
                                    row.placeholder = "Remarks"
                                    if let value = x.remarks{
                                        row.value = value
                                        Company.remarks = value
                                    }
                                    row.onChange({ (remark) in
                                        if (remark.value?.count)! <= 1{
                                            Company.remarks = ""
                                        }else{
                                            Company.remarks = remark.value!
                                        }
                                    })
                                    
                                })
                            
                        
                                +++ Section("Product Details"){
                                    $0.header?.height = {30}
                                    $0.footer?.height = {0}
                                }
                                <<< TextRow(){row in
                                    row.title = "Products"
                                    row.placeholder = "products"
                                    row.add(rule: RuleRequired())
                                    if let value = x.prodDealsIn{
                                        row.value = value
                                        Product.products = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Product.products = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Product.products = value
                                            }
                                        }
                                    })
                                <<< TextRow(){row in
                                    row.title = "Other DealerShip"
                                    row.placeholder = "dealership detail"
                                    row.add(rule: RuleRequired())
                                    if let value = x.otherDistributor{
                                        row.value = value
                                        Product.otherDealership = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Product.otherDealership = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Product.otherDealership = value
                                            }
                                        }
                                    })
                            
                                +++ Section("Trade References (any three)"){
                                    $0.header?.height = {20}
                                    $0.footer?.height = {0}
                                    
                                }
                                +++ Section("reference - 1"){
                                    $0.header?.height = {03}
                                    $0.footer?.height = {0}
                                }
                                <<< TextRow(){row in
                                    row.title = "Firm Name"
                                    row.placeholder = "firm - 1"
                                    row.add(rule: RuleRequired())
                                    if let value = x.tfnRef1{
                                        row.value = value
                                        Product.firmname1 = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Product.firmname1 = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Product.firmname1 = value
                                            }
                                        }
                                    })
                                
                                <<< TextRow(){row in
                                    row.title = "Person's Name"
                                    row.placeholder = "person - 1"
                                    row.add(rule: RuleRequired())
                                    if let value = x.tpnRef1{
                                        row.value = value
                                        Product.personname1 = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Product.personname1 = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Product.personname1 = value
                                            }
                                        }
                                    })
                                
                                <<< PhoneRow(){row in
                                    row.title = "Mobile Number"
                                    row.placeholder = "mobile number - 1"
                                    row.add(rule: RuleRequired())
                                    row.add(rule: RuleExactLength(exactLength: 10))
                                    if let value = x.tmnRef1{
                                        row.value = value
                                        Product.mobileno1 = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Product.mobileno1 = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Product.mobileno1 = value
                                            }
                                        }
                                    })
                            
                                +++ Section("Reference - 2"){
                                    $0.header?.height = {08}
                                    $0.footer?.height = {0}
                                }
                                <<< NameRow(){row in
                                    row.title = "Firm Name"
                                    row.placeholder = "firm - 2"
                                    row.add(rule: RuleRequired())
                                    if let value = x.tfnRef2{
                                        row.value = value
                                        Product.firmname2 = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Product.firmname2 = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Product.firmname2 = value
                                            }
                                        }
                                    })
                                <<< NameRow(){row in
                                    row.title = "Person's Name"
                                    row.placeholder = "person - 2"
                                    row.add(rule: RuleRequired())
                                    if let value = x.tpnRef1{
                                        row.value = value
                                        Product.personname2 = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Product.personname2 = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Product.personname2 = value
                                            }
                                        }
                                    })
                                
                                <<< PhoneRow(){row in
                                    row.title = "Mobile Number"
                                    row.placeholder = "mobile number - 2"
                                    row.add(rule: RuleRequired())
                                    row.add(rule: RuleExactLength(exactLength: 10))
                                    if let value = x.tmnRef2{
                                        row.value = value
                                        Product.mobileno2 = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Product.mobileno2 = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Product.mobileno2 = value
                                            }
                                        }
                                    })
                                
                                +++ Section("Reference - 3"){
                                    $0.header?.height = {08}
                                    $0.footer?.height = {0}
                                }
                                <<< NameRow(){row in
                                    row.title = "Firm Name"
                                    row.placeholder = "firm - 3"
                                    row.add(rule: RuleRequired())
                                    if let value = x.tfnRef3{
                                        row.value = value
                                        Product.firmname3 = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Product.firmname3 = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Product.firmname3 = value
                                            }
                                        }
                                    })
                                
                                <<< NameRow(){row in
                                    row.title = "Person's Name"
                                    row.placeholder = "person - 3"
                                    row.add(rule: RuleRequired())
                                    if let value = x.tpnRef3{
                                        row.value = value
                                        Product.personname3 = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Product.personname3 = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Product.personname3 = value
                                            }
                                        }
                                    })
                                
                                <<< PhoneRow(){row in
                                    row.title = "Mobile Number"
                                    row.placeholder = "mobile number - 3"
                                    row.add(rule: RuleExactLength(exactLength: 10))
                                    row.add(rule: RuleRequired())
                                    if let value = x.tmnRef3{
                                        row.value = value
                                        Product.mobileno3 = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Product.mobileno3 = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Product.mobileno3 = value
                                            }
                                        }
                                    })
                            
                                +++ Section("Other Details"){
                                    $0.header?.height = {20}
                                    $0.footer?.height = {0}
                                }
                                <<< TextRow(){row in
                                    row.title = "Billing Software Used"
                                    row.placeholder = "software"
                                    row.add(rule: RuleRequired())
                                    if let value = x.soft{
                                        row.value = value
                                        Product.billingSoft = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Product.billingSoft = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Product.billingSoft = value
                                            }
                                        }
                                    })
                                
                                <<< TextRow(){row in
                                    row.title = "Interested Products"
                                    row.placeholder = "products"
                                    row.add(rule: RuleRequired())
                                    if let value = x.prod{
                                        row.value = value
                                        Product.interestedProducts = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Product.interestedProducts = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Product.interestedProducts = value
                                            }
                                        }
                                    })
                                
                                <<< IntRow(){row in
                                    row.title = "Sales Commited (monthly)"
                                    row.placeholder = "no. of sales commited"
                                    row.add(rule: RuleRequired())
                                    if let value = x.tmnRef3{
                                        row.value = Int(value)
                                        Product.mobileno3 = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid {
                                            cell.textField.textColor = UIColor.flatRed
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            Product.salesCommitedMonthly = ""
                                        }else if row.isValid{
                                            cell.textField.textColor = .black
                                            cell.textLabel?.textColor = .black
                                            if let value = row.value{
                                                Product.salesCommitedMonthly = String(value)
                                            }
                                        }
                                    })
                            
                                +++ Section("Upload Images"){
                                    $0.header?.height = {20}
                                    $0.footer?.height = {0}
                                }
                                
                                
                                <<< ImageRow().cellSetup{ cell, row in
                                    row.title = "Visiting Card"
                                    row.placeholderImage = UIImage(named: "form-camera")
                                    row.sourceTypes = [ .Camera ,.PhotoLibrary]
                                    row.clearAction = .yes(style: UIAlertAction.Style.destructive)
                                    cell.height = {50}
                                    cell.accessoryView?.layer.cornerRadius = 20
                                    row.onChange({ (image) in
                                        Upload.visitinCard = self.img64(image: image)
                                        
                                    })
                                    if let value = x.vcImg{
                                        DispatchQueue.global(qos: .background).async {
                                            do
                                            {
                                                if value != ""{
                                                    let url : URL = URL(string: "\(LoginDetails.hostedIP)\(value)")!
                                                    if let data = try? Data(contentsOf: url)
                                                    {
                                                        let image: UIImage = UIImage(data: data)!
                                                        row.value = image
                                                    }
                                                }
                                            } catch { return }
                                        }
                                    }
                                }
                                
                                <<< ImageRow().cellSetup{ cell, row in
                                    row.title = "Front of Shop"
                                    row.placeholderImage = UIImage(named: "form-camera")
                                    row.sourceTypes = [ .Camera ,.PhotoLibrary]
                                    row.clearAction = .yes(style: UIAlertAction.Style.destructive)
                                    cell.height = {50}
                                    cell.accessoryView?.layer.cornerRadius = 20
                                    row.onChange({ (image) in
                                        Upload.frontOfShop = self.img64(image: image)
                                        
                                    })
                                    if let value = x.fsImg{
                                        DispatchQueue.global(qos: .background).async {
                                            do
                                            {
                                                if value != ""{
                                                    let url : URL = URL(string: "\(LoginDetails.hostedIP)\(value)")!
                                                    if let data = try? Data(contentsOf: url)
                                                    {
                                                        let image: UIImage = UIImage(data: data)!
                                                        row.value = image
                                                    }
                                                }
                                            } catch { return }
                                        }
                                    }
                                }
                                
                                <<< ImageRow().cellSetup{ cell, row in
                                    row.title = "Stock in Godown"
                                    row.placeholderImage = UIImage(named: "form-camera")
                                    row.sourceTypes = [ .Camera ,.PhotoLibrary]
                                    row.clearAction = .yes(style: UIAlertAction.Style.destructive)
                                    cell.height = {50}
                                    cell.accessoryView?.layer.cornerRadius = 20
                                    row.onChange({ (image) in
                                        Upload.godownStock = self.img64(image: image)
                                        
                                    })
                                    if let value = x.stockinGodownImg{
                                        DispatchQueue.global(qos: .background).async {
                                            do
                                            {
                                                if value != ""{
                                                    let url : URL = URL(string: "\(LoginDetails.hostedIP)\(value)")!
                                                    if let data = try? Data(contentsOf: url)
                                                    {
                                                        let image: UIImage = UIImage(data: data)!
                                                        row.value = image
                                                    }
                                                }
                                            } catch { return }
                                        }
                                    }
                                }
                                
                                <<< ImageRow().cellSetup{ cell, row in
                                    row.title = "Adjoining Shop(s)"
                                    row.placeholderImage = UIImage(named: "form-camera")
                                    row.sourceTypes = [ .Camera ,.PhotoLibrary]
                                    row.clearAction = .yes(style: UIAlertAction.Style.destructive)
                                    cell.height = {50}
                                    cell.accessoryView?.layer.cornerRadius = 20
                                    row.onChange({ (image) in
                                        Upload.adjoiningShop = self.img64(image: image)
                                        
                                    })
                                    if let value = x.adjShopsImg{
                                        DispatchQueue.global(qos: .background).async {
                                            do
                                            {
                                                if value != ""{
                                                    let url : URL = URL(string: "\(LoginDetails.hostedIP)\(value)")!
                                                    if let data = try? Data(contentsOf: url)
                                                    {
                                                        let image: UIImage = UIImage(data: data)!
                                                        row.value = image
                                                    }
                                                }
                                            } catch { return }
                                        }
                                    }
                                }
                                
                                +++ Section("Other"){
                                    $0.header?.height = {10}
                                    $0.footer?.height = {0}
                                }
                                
                                
                                <<< ImageRow().cellSetup{ cell, row in
                                    row.title = "Other Images"
                                    row.placeholderImage = UIImage(named: "form-camera")
                                    row.sourceTypes = [ .Camera ,.PhotoLibrary]
                                    row.clearAction = .yes(style: UIAlertAction.Style.destructive)
                                    cell.height = {50}
                                    cell.accessoryView?.layer.cornerRadius = 20
                                    row.onChange({ (image) in
                                        Upload.other = self.img64(image: image)
                                        
                                    })
                                    if let value = x.attatchData{
                                        DispatchQueue.global(qos: .background).async {
                                            do
                                            {
                                                if value != ""{
                                                    let url : URL = URL(string: "\(LoginDetails.hostedIP)\(value)")!
                                                    if let data = try? Data(contentsOf: url)
                                                    {
                                                        let image: UIImage = UIImage(data: data)!
                                                        row.value = image
                                                    }
                                                }
                                            } catch { return }
                                        }
                                    }
                                }
                                
                                
                                +++ Section("Save Changes"){
                                    $0.header?.height = {40}
                                    $0.footer?.height = {0}
                                }
                                
                                <<< ButtonRow(){
                                    $0.title = "Commit"
                                    $0.onCellSelection(self.buttonTapped)
                            }
                            
                            
                        
                        }
                    }
                    
                    }else{
                        SVProgressHUD.showError(withStatus: "Lead ID not found.")
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
    
    
    func img64(image : ImageRow) -> String{
        var strBase64 = ""
        if let img = image.value{
            if let imageData:NSData = img.jpegData(compressionQuality: 0) as! NSData{
                strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            }
        }
        
        return strBase64
    }
    
    
    func buttonTapped(cell: ButtonCellOf<String>, row: ButtonRow) {
        
        var followupDate = ""
        if Lead.nextFollowUpDate != ""{
            followupDate = "\(Lead.nextFollowUpDate) \(Lead.nextFollowUpTime)"
        }
        
        let parameters : [String: Any] = ["Code": Lead.salesmanCode, "CommitSales": String(Product.salesCommitedMonthly), "Country": Lead.country, "CreatedByCode": defaults.string(forKey: "employeeCode")!,"ExecutiveName": Lead.executiveName, "FirmAddress": Lead.address, "FirmAge": Company.yearsInBusiness, "FirmArea": Company.shopArea, "FirmCity": Lead.city, "FirmContactPerson":Lead.contactPersonName , "FirmContactPersonDesg": Lead.designation, "FirmContactPersonEmail": Lead.contactPersonEmailID, "FirmContactPersonMobile": String(Lead.mobileNo), "FirmGstn": Company.gstin, "FirmName": Lead.ddFirm, "FirmPan": Company.pan, "FirmPropType": String(Company.shopOwnership), "FirmState": Lead.state, "FirmType": Company.fType, "FirmWeb":Lead.website, "GodownArea":String(Company.godownArea), "GodownPropType":Company.godownOwnerShip, "Lat": String(Lead.lat) , "Lng": String(Lead.lng), "NextDate": followupDate, "OtherDistributor": Product.otherDealership, "PinCode": String(Lead.pincode), "Product": Product.interestedProducts , "ProductDealsIn": Product.products, "ReffSource":Lead.srName, "ReffSourceTitle": Lead.srInfo, "Software": Product.billingSoft, "Status": Lead.leadStatus, "TradeRef1FirmName": Product.firmname1, "TradeRef1MobileNo": String(Product.mobileno1), "TradeRef1PersonName": Product.personname1, "TradeRef2FirmName": Product.firmname2, "TradeRef2MobileNo": String(Product.mobileno2), "TradeRef2PersonName": Product.personname2, "TradeRef3FirmName": Product.firmname3, "TradeRef3MobileNo": String(Product.mobileno3), "TradeRef3PersonName": Product.personname3, "TurnOver1": String(Company.annualTurnover1), "TurnOver2": String(Company.annualTurnover2), "TurnOver3": String(Company.annualTurnover3), "VisitDate": Lead.visitDate,  "VisitingCardImage":Upload.visitinCard,  "FrontOfShopImage": Upload.frontOfShop, "StockInGodownImage": Upload.godownStock,  "AdjoiningShopsImage": Upload.adjoiningShop,  "AttachData": Upload.other,  "AttachType":"" , "LeadID": id, "LeadType": Lead.leadType, "Remarks": Company.remarks]
        
        
        
        
        print(parameters)
        
        addLead(url: "\(LoginDetails.hostedIP)/Sales/leadapproval", parameter: parameters)
        
    }
    
    
    
    
    func addLead(url: String , parameter: [String:Any]){
        
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON{
            response in
            
            let loginJSON : JSON = JSON(response.result.value)
            
            if response.result.isSuccess{
                print("Success! Posting the Leave Request data")
                
                print(loginJSON)
                if (loginJSON["returnType"].string?.contains("Lead Approve Successfully"))!{
                    SVProgressHUD.showSuccess(withStatus: loginJSON["returnType"].string)
                    
                    clearValues()
                    self.performSegue(withIdentifier: "goBackToLeadAssign", sender: self)
                    
                }else {
                    SVProgressHUD.showError(withStatus: loginJSON["returnType"].string)
                    SVProgressHUD.dismiss(withDelay: 3)
                }
                
            }
                
            else{
                
                print(loginJSON)
                
            }
        }
        
    }
        
    }
   

