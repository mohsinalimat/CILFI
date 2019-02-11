//
//  ProductContainerViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 03/07/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Eureka
class ProductContainerViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        form +++ Section("Product Details"){
            $0.header?.height = {40}
            $0.footer?.height = {0}
            }
            <<< TextRow(){row in
                row.title = "Products"
                row.placeholder = "products"
                row.add(rule: RuleRequired())
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
    }

    
}
