//
//  CompanyContainerViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 04/07/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Eureka
import CoreLocation
import GooglePlaces
import GooglePlacePicker
import GoogleMaps

class CompanyContainerViewController: FormViewController, CLLocationManagerDelegate{
    
    
    
    let placesClient = GMSPlacesClient()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formUpdate()
        
        
    }
    
    
    
    
}
extension CompanyContainerViewController{
    
    func formUpdate(){
        form +++ Section("Firm Info"){
            $0.header?.height = {40}
            $0.footer?.height = {0}
            }
            
            <<< TextRow ().cellSetup{ (cell, row) in
                row.title = "PAN of the firm"
                row.placeholder = "enter PAN number"
                row.add(rule: RuleRequired())
                row.add(rule: RuleExactLength(exactLength: 10))
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
                $0.value = "----- Select -----"     // initially selected
                $0.onChange({ (srInfo) in
                    if let sri = srInfo.value{
                        
                        if sri == "Proprietorship"{
                            Company.fType = "H"
                        }else if sri == "Partnership"{
                            Company.fType = "P"
                        }else if sri == "Others"{
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
                
                $0.header?.height = {20}
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
            
            <<< SegmentedRow<String>().cellSetup{ (cell, row)in
                row.title = "Shop Ownership"
                row.options = ["Rented","Owned"]
                row.onChange({ (ownership) in
                    if let ownerships = ownership.value{
                        if ownerships == "Rented"{
                            Company.godownOwnerShip = "R"
                        }else if ownerships == "Owned"{
                            Company.godownOwnerShip = "O"
                        }
                        
                    }
                    
                })
                }
            
            
            <<< IntRow ().cellSetup{ (cell, row) in
                row.title = "Godown Area"
                row.placeholder = "in Sq.Mtrs"
                row.add(rule: RuleRequired())
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
            
            <<< SegmentedRow<String>(){
                $0.title = "Gowdown Ownership"
                $0.options = ["Rented","Owned"]
                $0.onChange({ (ownership) in
                    if let ownerships = ownership.value{
                        if ownerships == "Rented"{
                            Company.godownOwnerShip = "R"
                        }else if ownerships == "Owned"{
                            Company.godownOwnerShip = "O"
                        }
                        
                    }
                    
                })
            }
            
            +++ Section("Remarks (if any)"){
                $0.header?.height = {30}
                $0.footer?.height = {0}
            }
            
            <<< TextAreaRow().cellSetup({ (cell, row) in
                row.placeholder = "Remarks"
                row.onChange({ (remark) in
                    if (remark.value?.count)! <= 1{
                        Company.remarks = ""
                    }else{
                        Company.remarks = remark.value!
                    }
                })
               
            })
            
            
            +++ Section("current addresss"){
                $0.header?.height = {30}
                $0.footer?.height = {0}
            }
        
            <<< TextAreaRow().cellSetup({ (cell, row) in
                row.tag = "address"
                
                row.value = currentAddress
                row.baseCell.isUserInteractionEnabled = false
               
                
                cell.height = {60}
                cell.textView.textAlignment = .center
                cell.textView.isEditable = false
                
                
            })
        
                    
        
    }
}
