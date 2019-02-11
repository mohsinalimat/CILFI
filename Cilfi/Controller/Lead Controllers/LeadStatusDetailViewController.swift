//
//  LeadStatusDetailViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 10/07/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Eureka
import Alamofire
import ImageRow
import SVProgressHUD
import SwiftyJSON

class LeadStatusDetailViewController:  FormViewController{
    
    let leadDataURL = "\(LoginDetails.hostedIP)/Sales/LeadDataUpdate"
    var leadId = ""
    
    override func viewDidLoad() {
       getStatusData()
        super.viewDidLoad()
        SVProgressHUD.show()
        
        // Do any additional setup after loading the view.
    }

    
    func getStatusData(){
        
        
        
        Alamofire.request("\(LoginDetails.hostedIP)/Sales/LeadData", method: .get, headers : headers).responseJSON{
            response in
            
            let leadData = response.data!
            let leadJSON = response.result.value
            if response.result.isSuccess{
                //                    print("UserTrackJSON: \(leadJSON)")
                do{
                    let lead = try JSONDecoder().decode(LeadDataRoot.self, from: leadData)
                    
                    for x in lead.leadData{
                       
                        if x.leadID! == self.leadId{
                           
                            if let lat = x.lat{
                                Lead.lat = lat
                            }
                            if let lng = x.lat{
                                Lead.lng = lng
                            }
                            
                            
                            self.form +++ Section("Lead"){
                                $0.header?.height = {20}
                                $0.footer?.height = {0}
                                SVProgressHUD.dismiss()
                                }
                                +++ Section("Employee Info"){
                                    $0.header?.height = {20}
                                    $0.footer?.height = {0}
                                }
                                <<< LabelRow().cellSetup{(cell, row) in
                                    row.title = "Created By Code"
                                    if let value = x.createdByCode{
                                        row.value = value
                                        Lead.createByCode = value
                                    }
                                }
                                
                                <<< LabelRow().cellSetup{(cell, row) in
                                    row.title = "Created By Name"
                                    if let value = x.createdByName{
                                        row.value = value
                                        Lead.createdByName = value
                                    }
                                    
                                }
                                <<< LabelRow().cellSetup{(cell, row) in
                                    row.title = "Salesman Code"
                                    if let value = x.code{
                                        row.value = value
                                        Lead.salesmanCode = value
                                    }
                                }
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
                                    if let value = x.leadType{
                                        if value == ""
                                        {
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
                                            cell.isUserInteractionEnabled = true
                                        }
                                        else {
                                            
                                            
                                            if value == "Primary Lead"{
                                                Lead.leadType = "P"
                                                row.value = "Primary"
                                                 cell.isUserInteractionEnabled = false
                                            }else if value == "Secondary Lead"{
                                                Lead.leadType = "S"
                                                row.value = "Secondary"
                                                 cell.isUserInteractionEnabled = false
                                            }else{
                                                
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
                                                cell.isUserInteractionEnabled = true
                                            
                                            }
                                            
                                           
                                        }
                                    }
                                })
                                
                                <<< PickerInlineRow<String>().cellSetup({ (cell, row) in
                                    row.title = "Lead Status"
                                    row.options = ["New","Follow Up","Converted","Lost"]
                                    
                                    if let value = x.status{
                                    
                                        if value == ""
                                        {
                                            row.value = "----- Select -----"
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
                                            cell.isUserInteractionEnabled = true
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
                                            
                                            cell.isUserInteractionEnabled = false
                                        }
                                    }
                                })
                                
                                
                                <<< DateInlineRow().cellSetup({ (cell, row) in
                                    row.title = "Visit Date"
                                    
                                    if let value = x.visitDate{
                                        if value == ""
                                        {
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            row.value = Date()
                                            row.onChange({ (date) in
                                                cell.textLabel?.textColor = UIColor.black
                                                row.dateFormatter?.dateFormat = "MM/dd/yyyy"
                                                Lead.visitDate = row.dateFormatter!.string(from: date.value!)
                                            })
                                            cell.isUserInteractionEnabled = true
                                        }
                                        else {
                                            row.dateFormatter?.dateFormat = "dd/MM/yyyy"
                                            if let date = row.dateFormatter!.date(from: value){
                                                row.value = date
                                                row.dateFormatter!.dateFormat = "yyyy/MM/dd"
                                                Lead.visitDate = row.dateFormatter!.string(from: date)
                                            }
                                           
                                            
                                            cell.isUserInteractionEnabled = false
                                        }
                                    }
                                })
                                
                                <<< LabelRow(){row in
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
                                            cell.isUserInteractionEnabled = true
                                        }
                                        else {
                                            row.value = value
                                            Lead.state = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                    }
                                })
                                
                                +++ Section("Dealer/Distributor Info"){
                                    $0.header?.height = {20}
                                    $0.footer?.height = {0}
                                    
                                }
                                
                                <<< TextRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "Dealer/Distributor Firm"
                                    if let value = x.fname{
                                        if value == ""{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Lead.ddFirm = ""
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                            
                                        }else{
                                            if let value = row.value{
                                                Lead.ddFirm = value
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                            
                                        }
                                    })
                                
                                <<< TextRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "Address"
                                    if let value = x.firmAddress{
                                        if value == ""{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Lead.address = ""
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                        }else{
                                            if let value = row.value{
                                                Lead.address = value
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                        }
                                    })
                                
                                <<< TextRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "State"
                                    if let value = x.firmState{
                                        if value == ""{
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Lead.state = ""
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                        }else{
                                            if let value = row.value{
                                                Lead.state = value
                                            }
                                            
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                        }
                                    })
                                
                                <<< TextRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "City"
                                    if let value = x.fcity{
                                        if value == ""{
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Lead.city = ""
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                        }else{
                                            if let value = row.value{
                                                Lead.city = value
                                            }
                                            
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                        }
                                    })
                                
                                
                                <<< TextRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "Country"
                                    if let value = x.country{
                                        if value == ""{
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Lead.country = ""
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                        }else{
                                            if let value = row.value{
                                                Lead.country = value
                                            }
                                            
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                        }
                                    })
                                
                                <<< PhoneRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.add(rule: RuleExactLength(exactLength: 6))
                                    row.title = "Pincode"
                                    if let value = x.pin{
                                         if value == "" || value == "0"{
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Lead.pincode = ""
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                        }else{
                                            if let value = row.value{
                                                if value != ""{
                                                    
                                                        Lead.pincode = value
                                                    
                                                }
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                        }
                                    })
                                
                                <<< TextRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "Website"
                                    if let value = x.fweb{
                                        if value == ""{
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Lead.website = ""
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                        }else{
                                            if let value = row.value{
                                                Lead.website = value
                                            }
                                            
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                        }
                                    })
                                
                                
                                +++ Section(){
                                    $0.header?.height = {20}
                                    $0.footer?.height = {0}
                                }
                                
                                <<< TextRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "Contact Person's Name"
                                    if let value = x.fcontactPerson{
                                        if value == ""{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Lead.contactPersonName = ""
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                            
                                        }else{
                                            if let value = row.value{
                                                Lead.contactPersonName = value
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                            
                                        }
                                    })
                                
                                <<< TextRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "Designation"
                                    if let value = x.firmcontactPersonDesg{
                                        if value == ""{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Lead.designation = ""
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                            
                                        }else{
                                            if let value = row.value{
                                                Lead.designation = value
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                            
                                        }
                                    })
                                
                                <<< PhoneRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.add(rule: RuleExactLength(exactLength: 10))
                                    row.title = "Contact Person's Mobile"
                                    if let value = x.firmContactPersonMobile{
                                        if value == "" || value == "0"{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Lead.mobileNo = ""
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                            
                                        }else{
                                            if let value = row.value{
                                                if value != ""{
                                                   
                                                        Lead.mobileNo = value
                                                    
                                                }
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                            
                                        }
                                    })
                                
                                <<< EmailRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.add(rule: RuleEmail())
                                    row.title = "Contact Person's Email"
                                    if let value = x.fcontactPersonEmail{
                                        if value == ""{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Lead.contactPersonEmailID = ""
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                            
                                        }else{
                                            if let value = row.value{
                                                Lead.contactPersonEmailID = value
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                            
                                        }
                                    })
                                
                                
                                <<< DateInlineRow().cellSetup({ (cell, row) in
                                    row.title = "Next Visit Date"
                                    
                                    if let value = x.nextDate{
                                        if value == ""
                                        {
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            row.value = Date()
                                            row.onChange({ (date) in
                                                cell.textLabel?.textColor = UIColor.black
                                                row.dateFormatter?.dateFormat = "yyyy/MM/dd"
                                                Lead.nextFollowUpDate = row.dateFormatter!.string(from: date.value!)
                                            })
                                            cell.isUserInteractionEnabled = true
                                        }
                                        else {
                                            row.dateFormatter?.dateFormat = "dd/MM/yyyy hh:mm:ss a"
                                            if let date = row.dateFormatter!.date(from: value){
                                                row.dateFormatter?.dateFormat = "dd/MM/yyyy"
                                                if let dateString = row.dateFormatter?.string(from: date){
                                                    row.dateFormatter?.dateFormat = "dd/MM/yyyy"
                                                    row.value = row.dateFormatter!.date(from: dateString)
                                                    Lead.nextFollowUpDate = dateString
                                                }
                                            }
                                            
                                            cell.isUserInteractionEnabled = false
                                        }
                                    }
                                })
                                
                                <<< TimeInlineRow().cellSetup({ (cell, row) in
                                    row.title = "Next Visit Time"
                                    
                                    if let value = x.nextDate{
                                        if value == ""
                                        {
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            row.value = Date()
                                            row.onChange({ (date) in
                                                cell.textLabel?.textColor = UIColor.black
                                                row.dateFormatter?.dateFormat = "hh:mm a"
                                                Lead.nextFollowUpTime = row.dateFormatter!.string(from: date.value!)
                                            })
                                            cell.isUserInteractionEnabled = true
                                        }
                                        else {
                                            row.dateFormatter?.dateFormat = "dd/MM/yyyy hh:mm:ss a"
                                            if let date = row.dateFormatter!.date(from: value){
                                                row.dateFormatter?.dateFormat = "hh:mm:ss a"
                                                if let dateString = row.dateFormatter?.string(from: date){
                                                    row.dateFormatter?.dateFormat = "hh:mm:ss a"
                                                     row.value = row.dateFormatter!.date(from: dateString)
                                                    Lead.nextFollowUpTime = dateString
                                                }
                                            }
                                           
                                            
                                            cell.isUserInteractionEnabled = false
                                        }
                                    }
                                })
                                
                                +++ Section("Firm Info"){
                                    $0.header?.height = {20}
                                    $0.footer?.height = {0}
                                }
                                
                                <<< TextRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "Pan"
                                    if let value = x.fpan{
                                        if value == ""{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Company.pan = ""
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                            
                                        }else{
                                            if let value = row.value{
                                                Company.pan = value
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                            
                                        }
                                    })
                                
                                <<< TextRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "GSTIN"
                                    if let value = x.fgstin{
                                        if value == ""{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Company.gstin = ""
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                            
                                        }else{
                                            if let value = row.value{
                                                Company.gstin = value
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                            
                                        }
                                    })
                                
                                
                                <<< PickerInlineRow<String>().cellSetup({ (cell, row) in
                                    row.title = "Firm Type"
                                    row.options = ["Proprietorship", "Partnership", "Others"]
                                    if let value = x.ftype{
                                        if value == ""
                                        {
                                            row.value = "----- Select -----"
                                            row.onChange({ (status) in
                                                if let stat = status.value{
                                                    if stat == "Proprietorship"{
                                                        Company.fType = "H"
                                                    }else if stat == "Partnership"{
                                                        Company.fType = "P"
                                                    }else if stat == "Others"{
                                                        Company.fType = "O"
                                                    }
                                                    
                                                }
                                            })
                                            cell.isUserInteractionEnabled = true
                                        }
                                        else {
                                            Company.fType = value
                                            if value == "H"{
                                                row.value = "Proprietorship"
                                            }else if value == "P"{
                                                row.value = "Partnership"
                                            }else if value == "O"{
                                                row.value = "Others"
                                            }
                                            
                                            cell.isUserInteractionEnabled = false
                                        }
                                    }
                                })
                                
                                
                                
                                <<< PhoneRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.add(rule: RuleMaxLength(maxLength: 3))
                                    row.title = "Year(s) in business"
                                    if let value = x.fage{
                                        if value == "" || value == "0" || value == "0.00"{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        Company.yearsInBusiness = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Company.yearsInBusiness = "0"
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                            
                                        }else{
                                            if let value = row.value{
                                                if value != ""{
                                                    
                                                        Company.yearsInBusiness = value
                                                   
                                                    
                                                }
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                            
                                        }
                                    })
                                
                                +++ Section("Annual Turnovers"){
                                    
                                    $0.header?.height = {20}
                                    $0.footer?.height = {0}
                                    
                                }
                                +++ Section("Turnover 16-17"){
                                    $0.header?.height = {15}
                                    $0.footer?.height = {0}
                                }
                                
                                <<< PhoneRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "Annual Turnover"
                                    if let value = x.turnOver1{
                                        if  value == "" || value == "0" || value == "0.00"{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        Company.annualTurnover1 = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Company.annualTurnover1 = "0"
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                            
                                        }else{
                                            if let value = row.value{
                                                if value != ""{
                                                    
                                                        Company.annualTurnover1 = value
                                                    
                                                    
                                                }
                                                
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                            
                                        }
                                    })
                                +++ Section("Turnover 15-16"){
                                    $0.header?.height = {15}
                                    $0.footer?.height = {0}
                                }
                                <<< PhoneRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "Annual Turnover"
                                    if let value = x.turnOver2{
                                        if value == "" || value == "0" || value == "0.00"{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        Company.annualTurnover2 = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Company.annualTurnover2 = "0"
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                            
                                        }else{
                                            if let value = row.value{
                                                if value != ""{
                                                    
                                                        Company.annualTurnover2 = value
                                                    
                                                }
                                                
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                            
                                        }
                                    })
                                
                                +++ Section("Turnover 14-15"){
                                    $0.header?.height = {15}
                                    $0.footer?.height = {0}
                                }
                                <<< PhoneRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "Annual Turnover"
                                    if let value = x.turnOver3{
                                        if  value == "" || value == "0" || value == "0.00"{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        Company.annualTurnover3 = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Company.annualTurnover3 = "0"
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                            
                                        }else{
                                            if let value = row.value{
                                                if value != ""{
                                                   
                                                        Company.annualTurnover3 = value
                                                   
                                                }
                                                
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                            
                                        }
                                    })
                                
                                +++ Section("Shop/Godown Info"){
                                    $0.header?.height = {20}
                                    $0.footer?.height = {0}
                                }
                                <<< PhoneRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "Shop Area"
                                    if let value = x.farea{
                                        if  value == "" || value == "0" || value == "0.00"{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        Company.shopArea = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Company.shopArea = "0"
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                            
                                        }else{
                                            if let value = row.value{
                                                if value != ""{
                                                   
                                                        Company.shopArea = value
                                        
                                                }
                                                
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                            
                                        }
                                    })
                                
                                
                                <<< SegmentedRow<String>().cellSetup({ (cell, row) in
                                    row.title = "Shop Property Type"
                                    row.options = ["Rented", "Owned"]
                                    if let value = x.fpropType{
                                        if value == ""
                                        {
                                            
                                            row.onChange({ (status) in
                                                if let stat = status.value{
                                                    if stat == "Rented"{
                                                        Company.shopOwnership = "R"
                                                    }else if stat == "Owned"{
                                                        Company.shopOwnership = "O"
                                                    }
                                                    
                                                }
                                            })
                                            cell.isUserInteractionEnabled = true
                                        }
                                        else {
                                            
                                            Company.shopOwnership = value
                                            
                                            if value == "R"{
                                                row.value = "Rented"
                                                
                                            }else if value == "O"{
                                                row.value = "Owned"
                                                
                                            }
                                            
                                            cell.isUserInteractionEnabled = false
                                        }
                                    }
                                })
                                
                                <<< PhoneRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "Godown Area"
                                    if let value = x.fGodown{
                                        if  value == "" || value == "0" || value == "0.00"{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        Company.godownArea = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Company.godownArea = "0"
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                            
                                        }else{
                                            if let value = row.value{
                                                if value != ""{
                                                    
                                                        Company.godownArea = value
                                                    
                                                }
                                                
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                            
                                        }
                                    })
                                
                                
                                <<< SegmentedRow<String>().cellSetup({ (cell, row) in
                                    row.title = "Godown Property Type"
                                    row.options = ["Rented", "Owned"]
                                    if let value = x.fGodownPropType{
                                        
                                        if value == ""
                                        {
                                            
                                            row.onChange({ (status) in
                                                if let stat = status.value{
                                                    if stat == "Rented"{
                                                        Company.godownOwnerShip = "R"
                                                    }else if stat == "Owned"{
                                                        Company.godownOwnerShip = "O"
                                                    }
                                                    
                                                }
                                            })
                                            cell.isUserInteractionEnabled = true
                                        }
                                        else {
                                            Company.godownOwnerShip = value
                                            
                                            if value == "R"{
                                                row.value = "Rented"
                                                
                                            }else if value == "O"{
                                                row.value = "Owned"
                                                
                                            }
                                            
                                            cell.isUserInteractionEnabled = false
                                        }
                                    }
                                })
                                
                                +++ Section("Product Details"){
                                    $0.header?.height = {40}
                                    $0.footer?.height = {0}
                                }
                                
                                <<< TextRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "Products Deals In"
                                    if let value = x.prodDealsIn{
                                        if value == ""{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Product.products = ""
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                            
                                        }else{
                                            if let value = row.value{
                                                Product.products = value
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                            
                                        }
                                    })
                                
                                
                                <<< TextRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "Other Dealership"
                                    if let value = x.otherDistributor{
                                        if value == ""{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Product.otherDealership = ""
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                            
                                        }else{
                                            if let value = row.value{
                                                Product.otherDealership = value
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                            
                                        }
                                    })
                                
                                +++ Section("Trade References (any three)"){
                                    $0.header?.height = {20}
                                    $0.footer?.height = {0}
                                    
                                }
                                +++ Section("reference - 1"){
                                    $0.header?.height = {15}
                                    $0.footer?.height = {0}
                                }
                                
                                <<< TextRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "Firm Name"
                                    if let value = x.tfnRef1{
                                        if value == ""{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Product.firmname1 = ""
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                            
                                        }else{
                                            if let value = row.value{
                                                Product.firmname1 = value
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                            
                                        }
                                    })
                                
                                <<< TextRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "Person's Name"
                                    if let value = x.tpnRef1{
                                        if value == ""{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Product.personname1 = ""
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                            
                                        }else{
                                            if let value = row.value{
                                                Product.personname1 = value
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                            
                                        }
                                    })
                                
                                
                                <<< PhoneRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "Mobile Number"
                                    if let value = x.tmnRef1{
                                        if value == "" || value == "0"{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Product.mobileno1 = ""
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                            
                                        }else{
                                            if let value = row.value{
                                                if value != ""{
                                                    if let intVal = Int(value){
                                                        Product.mobileno1 = value
                                                    }
                                                }
                                                
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                            
                                        }
                                    })
                                
                                +++ Section("reference - 2"){
                                    $0.header?.height = {15}
                                    $0.footer?.height = {0}
                                }
                                <<< TextRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "Firm Name"
                                    if let value = x.tfnRef2{
                                        if value == ""{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Product.firmname2 = ""
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                            
                                        }else{
                                            if let value = row.value{
                                                Product.firmname2 = value
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                            
                                        }
                                    })
                                
                                <<< TextRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "Person's Name"
                                    if let value = x.tpnRef2{
                                        if value == ""{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Product.personname2 = ""
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                            
                                        }else{
                                            if let value = row.value{
                                                Product.personname2 = value
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                            
                                        }
                                    })
                                
                                
                                <<< PhoneRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "Mobile Number"
                                    if let value = x.tmnRef2{
                                        if value == "" || value == "0"{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Product.mobileno2 = ""
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                            
                                        }else{
                                            if let value = row.value{
                                                if value != ""{
                                                    if let intVal = Int(value){
                                                        Product.mobileno2 = value
                                                    }
                                                }
                                                
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                            
                                        }
                                    })
                                
                                
                                +++ Section("reference - 3"){
                                    $0.header?.height = {15}
                                    $0.footer?.height = {0}
                                }
                                
                                <<< TextRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "Firm Name"
                                    if let value = x.tfnRef3{
                                        if value == ""{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Product.firmname3 = ""
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                            
                                        }else{
                                            if let value = row.value{
                                                Product.firmname3 = value
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                            
                                        }
                                    })
                                
                                <<< TextRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "Person's Name"
                                    if let value = x.tpnRef3{
                                        if value == ""{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Product.personname3 = ""
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                            
                                        }else{
                                            if let value = row.value{
                                                Product.personname3 = value
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                            
                                        }
                                    })
                                
                                
                                <<< PhoneRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "Mobile Number"
                                    if let value = x.tmnRef3{
                                        if value == "" || value == "0"{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Product.mobileno3 = ""
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                            
                                        }else{
                                            if let value = row.value{
                                                if value != ""{
                                                    if let intVal = Int(value){
                                                        Product.mobileno3 = value
                                                    }
                                                }
                                                
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                            
                                        }
                                    })
                                
                                +++ Section("Other Details"){
                                    $0.header?.height = {20}
                                    $0.footer?.height = {0}
                                }
                                
                                <<< TextRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "Billing Software Used"
                                    if let value = x.soft{
                                        if value == ""{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Product.billingSoft = ""
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                            
                                        }else{
                                            if let value = row.value{
                                                Product.billingSoft = value
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                            
                                        }
                                    })
                                
                                
                                <<< TextRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "Intrested Products"
                                    if let value = x.prod{
                                        if value == ""{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Product.interestedProducts = ""
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                            
                                        }else{
                                            if let value = row.value{
                                                Product.interestedProducts = value
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                            
                                        }
                                    })
                                
                                
                                
                                <<< PhoneRow ().cellSetup{ (cell, row) in
                                    row.add(rule: RuleRequired())
                                    row.title = "Sales Commit (monthly)"
                                    if let value = x.salesCommit{
                                         if value == "" || value == "0" || value == "0.00"{
                                            
                                            cell.isUserInteractionEnabled = true
                                        }else {
                                            
                                            row.value = value
                                            cell.isUserInteractionEnabled = false
                                        }
                                        Product.salesCommitedMonthly = value
                                    }
                                    }.cellUpdate({ (cell, row) in
                                        if !row.isValid{
                                            Product.salesCommitedMonthly = "0.00"
                                            cell.textLabel?.textColor = UIColor.flatRed
                                            cell.textField.textColor = UIColor.flatRed
                                            
                                        }else{
                                            if let value = row.value{
                                                if value != ""{
                                                    
                                                        Product.salesCommitedMonthly = value
                                                    
                                                }
                                                
                                            }
                                            cell.textLabel?.textColor = UIColor.black
                                            cell.textField.textColor = UIColor.black
                                            
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
        
        let parameters : [String: Any] = ["Code": defaults.string(forKey: "employeeCode")!, "CommitSales": String(Product.salesCommitedMonthly), "Country": Lead.country, "CreatedByCode": defaults.string(forKey: "employeeCode")!,"ExecutiveName": defaults.string(forKey: "name")!, "FirmAddress": Lead.address, "FirmAge": Company.yearsInBusiness, "FirmArea": Company.shopArea, "FirmCity": Lead.city, "FirmContactPerson":Lead.contactPersonName , "FirmContactPersonDesg": Lead.designation, "FirmContactPersonEmail": Lead.contactPersonEmailID, "FirmContactPersonMobile": String(Lead.mobileNo), "FirmGstn": Company.gstin, "FirmName": Lead.ddFirm, "FirmPan": Company.pan, "FirmPropType": String(Company.shopOwnership), "FirmState": Lead.state, "FirmType": Company.fType, "FirmWeb":Lead.website, "GodownArea":String(Company.godownArea), "GodownPropType":Company.godownOwnerShip, "Lat": String(Lead.lat) , "Lng": String(Lead.lng), "NextDate": followupDate, "OtherDistributor": Product.otherDealership, "PinCode": String(Lead.pincode), "Product": Product.interestedProducts , "ProductDealsIn": Product.products, "ReffSource":Lead.srName, "ReffSourceTitle": Lead.srInfo, "Software": Product.billingSoft, "Status": Lead.leadStatus, "TradeRef1FirmName": Product.firmname1, "TradeRef1MobileNo": String(Product.mobileno1), "TradeRef1PersonName": Product.personname1, "TradeRef2FirmName": Product.firmname2, "TradeRef2MobileNo": String(Product.mobileno2), "TradeRef2PersonName": Product.personname2, "TradeRef3FirmName": Product.firmname3, "TradeRef3MobileNo": String(Product.mobileno3), "TradeRef3PersonName": Product.personname3, "TurnOver1": String(Company.annualTurnover1), "TurnOver2": String(Company.annualTurnover2), "TurnOver3": String(Company.annualTurnover3), "VisitDate": Lead.visitDate,  "VisitingCardImage":Upload.visitinCard,  "FrontOfShopImage": Upload.frontOfShop, "StockInGodownImage": Upload.godownStock,  "AdjoiningShopsImage": Upload.adjoiningShop,  "AttachData": Upload.other,  "AttachType":"" , "LeadID": leadId, "LeadType": Lead.leadType, "Remarks": Company.remarks]
        
        
       

        print(parameters)
        
         addLead(url: leadDataURL, parameter: parameters)
        
    }
    
    
    
    
    func addLead(url: String , parameter: [String:Any]){
        
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON{
            response in
            
            let loginJSON : JSON = JSON(response.result.value)
            
            if response.result.isSuccess{
                print("Success! Posting the Leave Request data")
                
                print(loginJSON)
                if (loginJSON["returnType"].string?.contains("Lead Updated Successfully"))!{
                    SVProgressHUD.showSuccess(withStatus: loginJSON["returnType"].string)
                    
                    clearValues()
                    self.performSegue(withIdentifier: "goBackToLeadStatus", sender: self)
                    
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
