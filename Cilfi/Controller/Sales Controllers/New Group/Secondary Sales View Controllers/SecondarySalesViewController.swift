//
//  SecondarySalesViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 23/07/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Eureka

class SecondarySalesViewController: FormViewController {
    let ledger = LedgerAccountModel()
    var address1 = ""
    var address2 = ""
    var address3 = ""
    var city = ""
    var state = ""
    var pincode = ""
    
    
    var flag = false
    override func viewDidLoad() {
        super.viewDidLoad()
        ledger.getCustomerData()
        setForm()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        AddressAndItem.shippingOtherAddress = ""
        if address1 != ""{
            AddressAndItem.shippingOtherAddress.append(address1)
        }
        if address2 != ""{
            AddressAndItem.shippingOtherAddress.append(", \(address2)")
        }
        if address3 != ""{
            AddressAndItem.shippingOtherAddress.append(", \(address3)")
        }
        if city != ""{
            AddressAndItem.shippingOtherAddress.append(", \(city)")
        }
        if state != ""{
            AddressAndItem.shippingOtherAddress.append(", \(state), India")
        }
        if pincode != ""{
            AddressAndItem.shippingOtherAddress.append(" - \(pincode)")
        }
        
        
        print(AddressAndItem.shippingOtherAddress)
    }
    
    
    //    {"itemPost":[{"BillAddress":"ANAND TUBES,108 PRAKASH INDUSTRIAL \nESTATE,ARADHNA CINEMA G.T. ROAD \nSAHIBABAD,-,,SAHIBABAD,UTTAR \nPRADESH,, ","CustomerCode":"16A042","CustomerName":"ANAND TUBES","DespTo":"16A042","Discount":"0.0","GroupCode":"9202","ItemCode":"92020002","ItemName":"ABS BALL VALVE \n(PLASTIC) -¾ \nINCH ","Location":"On Phone","OrderPrice":"380.0","Quantity":"1.0","Remark":"hiii","ShipAddress":"","TotalPrice":"380","TotalQty":"1","UnitPrice":"380.0"}]}
    
    func setForm(){
        //        var index = 0
        var baddress = ""
        var saddress = ""
        
        form +++ Section("Address Information"){
            $0.header?.height = {40}
            $0.footer?.height = {0}
            }
            
            +++ Section("Billing Address"){
                $0.header?.height = {10}
                $0.footer?.height = {0}
            }
            
            <<< PushRow<String>(""){
                $0.tag = "comp"
                $0.title = "Select a Company"
                $0.options = custName
                $0.reload()
                $0.onChange({ (value) in
                    
                    
                    
                    guard let index = value.options?.index(of: value.value!) else {return}
                    
                    AddressAndItem.billingcustomerCode = self.ledger.custCode[index]
                    
                    
                    let add1 = self.ledger.address1[index]
                    let add2 = self.ledger.address2[index]
                    let add3 = self.ledger.address3[index]
                    let city = self.ledger.city[index]
                    let state = self.ledger.state[index]
                    let pin = self.ledger.pincode[index]
                    
                    if add1 != ""{
                        baddress.append(add1)
                    }
                    if add2 != ""{
                        baddress.append(", \(add2)")
                    }
                    if add3 != ""{
                        baddress.append(", \(add3)")
                    }
                    if city != ""{
                        baddress.append(", \(city)")
                    }
                    if state != ""{
                        baddress.append(", \(state), India")
                    }
                    if pin != ""{
                        baddress.append("- \(pin)")
                    }
                    
                })
                }.cellUpdate({ (cell, row) in
                    
                    AddressAndItem.billingAddress = baddress
                    
                    let bAdd : TextAreaRow? = self.form.rowBy(tag: "bAddress")
                    if let value = row.value{
                        
                        AddressAndItem.billingcustomerName = value
                        
                        bAdd?.value = "\nADDRESS : \n\(baddress)"
                        bAdd?.reload()
                        self.form.rowBy(tag: "bAddress")?.updateCell()
                    }
                    
                    let sAddSwitch : SwitchRow? = self.form.rowBy(tag: "sAddressSwitch")
                    if sAddSwitch?.value == true{
                        let sAdd : TextAreaRow? = self.form.rowBy(tag: "sAddress")
                        if let value = row.value{
                            
                            sAdd?.value = "\nADDRESS : \n\(baddress)"
                            sAdd?.reload()
                            self.form.rowBy(tag: "sAddress")?.updateCell()
                        }
                    }
                    
                    
                    
                })
            
            
            <<< TextAreaRow(""){
                $0.tag = "bAddress"
                $0.title = "Billing Address"
                }.cellSetup({ (cell, row) in
                    cell.isUserInteractionEnabled = false
                    cell.textView.font = cell.textView.font?.withSize(12)
                    row.hidden = true
                    cell.height = {100}
                    cell.textView.textAlignment = .center
                    cell.textView.backgroundColor = UIColor.flatSand
                })
            
            
            
            
            +++ Section("Shipping Address"){
                $0.header?.height = {20}
                $0.footer?.height = {0}
            }
            
            <<< SwitchRow(""){
                
                $0.tag = "sAddressSwitch"
                $0.title = "Same as above"
                $0.value = true
                
                }.onChange({ (value) in
                    if value.value == true{
                        
                        Group.sameAsAbove = true
                        
                        let bAdd : TextAreaRow? = self.form.rowBy(tag: "bAddress")
                        
                        
                        let sAdd : TextAreaRow? = self.form.rowBy(tag: "sAddress")
                        sAdd?.value = "\nADDRESS : \n\(baddress)"
                        sAdd?.reload()
                        self.form.rowBy(tag: "sAddress")?.updateCell()
                        
                        print(baddress)
                        
                        let s = self.form.sectionBy(tag: "s")
                        s?.hidden = true
                        s?.evaluateHidden()
                        
                    }else{
                        
                        Group.sameAsAbove = false
                        
                        let oAdd : SwitchRow? = self.form.rowBy(tag: "oAddressSwitch")
                        oAdd?.value = false
                        oAdd?.updateCell()
                        
                        let s = self.form.sectionBy(tag: "s")
                        s?.hidden = false
                        s?.evaluateHidden()
                        
                        
                        
                    }
                })
            
            +++ Section(){
                $0.tag = "s"
                $0.hidden = true
                $0.header?.height = {10}
                $0.footer?.height = {0}
            }
            
            
            
            <<< PushRow<String>(""){
                $0.tag = "shipcomp"
                $0.title = "Select a Company"
                $0.options = custName
                $0.reload()
                $0.onChange({ (value) in
                    
                    
                    
                    guard let index = value.options?.index(of: value.value!) else {return}
                    
                    AddressAndItem.shippingcustomerCode = self.ledger.custCode[index]
                    
                    
                    let add1 = self.ledger.address1[index]
                    let add2 = self.ledger.address2[index]
                    let add3 = self.ledger.address3[index]
                    let city = self.ledger.city[index]
                    let state = self.ledger.state[index]
                    let pin = self.ledger.pincode[index]
                    
                    if add1 != ""{
                        saddress.append(add1)
                    }
                    if add2 != ""{
                        saddress.append(", \(add2)")
                    }
                    if add3 != ""{
                        saddress.append(", \(add3)")
                    }
                    if city != ""{
                        saddress.append(", \(city)")
                    }
                    if state != ""{
                        saddress.append(", \(state), India")
                    }
                    if pin != ""{
                        saddress.append("- \(pin)")
                    }
                    
                })
                }.cellUpdate({ (cell, row) in
                    
                    
                    AddressAndItem.shippingAddress = saddress
                    
                    let sAdd : TextAreaRow? = self.form.rowBy(tag: "sAddress")
                    if let value = row.value{
                        
                        AddressAndItem.shippingcustomerName = value
                        print("sname = \(AddressAndItem.shippingcustomerName)")
                        sAdd?.value = "\nADDRESS : \n\(saddress)"
                        sAdd?.reload()
                        self.form.rowBy(tag: "sAddress")?.updateCell()
                    }
                    
                    
                })
            
            
            <<< TextAreaRow(""){
                $0.tag = "sAddress"
                $0.title = "Shipping Address"
                }.cellSetup({ (cell, row) in
                    cell.isUserInteractionEnabled = false
                    cell.textView.font = cell.textView.font?.withSize(12)
                    row.hidden = true
                    cell.height = {100}
                    cell.textView.textAlignment = .center
                    cell.textView.backgroundColor = UIColor.flatSand
                })
            
            +++ Section("Location & Remarks(if any)"){
                
                $0.header?.height = {30}
                $0.footer?.height = {0}
            }
            
            <<< ActionSheetRow<String>(""){
                $0.title = "Ordered On : "
                $0.options = ["On Phone", "On Location"]
                $0.value = "--- Select ---"
                
                }.onChange({ (value) in
                    AddressAndItem.location = value.value!
                })
            
            <<< TextAreaRow(){
                
                $0.title = "Remarks (if any)"
                }.cellSetup({ (cell, row) in
                    
                    cell.textView.font = cell.textView.font?.withSize(12)
                    
                    cell.height = {100}
                    cell.textView.textAlignment = .center
                    cell.textView.backgroundColor = UIColor.flatSand
                }).cellUpdate({ (cell, row) in
                    if let value = row.value{
                        if value == ""{
                            AddressAndItem.remarks = ""
                        }else{
                            AddressAndItem.remarks = value
                        }
                    }
                    
                })
            
            +++ Section("Other Address Information"){
                
                $0.header?.height = {30}
                $0.footer?.height = {0}
            }
            
            
            
            <<< SwitchRow(""){
                
                $0.tag = "oAddressSwitch"
                $0.title = "Other Address Information"
                $0.value = false
                }.onChange({ (value) in
                    if value.value == true{
                        
                        Group.otherAddress = true
                        
                        let sAdd : SwitchRow? = self.form.rowBy(tag: "sAddressSwitch")
                        sAdd?.value = true
                        sAdd?.updateCell()
                        
                        let oAdd = self.form.sectionBy(tag: "o")
                        oAdd?.hidden = false
                        oAdd?.evaluateHidden()
                        
                    }else{
                        self.address1 = ""
                        self.address2 = ""
                        self.address3 = ""
                        self.city = ""
                        self.state = ""
                        self.pincode = ""
                        
                        Group.otherAddress = false
                        let oAdd = self.form.sectionBy(tag: "o")
                        oAdd?.hidden = true
                        oAdd?.evaluateHidden()
                        //                        let sAdd : SwitchRow? = self.form.rowBy(tag: "sAddressSwitch")
                        //                        sAdd?.value = false
                        //                        sAdd?.updateCell()
                        
                        
                    }
                })
            
            +++ Section("Other Address Info"){
                $0.tag = "o"
                $0.hidden = true
                $0.header?.height = {10}
                $0.header?.height = {0}
            }
            <<< TextRow(){
                $0.title = "Address 1"
                
                }.cellUpdate({ (cell, row) in
                    if let value = row.value{
                        if value != ""{
                            self.address1 = value
                        }else{
                            self.address1 = ""
                        }
                    }
                })
            
            <<< TextRow(){
                $0.title = "Address 2"
                
                }.cellUpdate({ (cell, row) in
                    if let value = row.value{
                        if value != ""{
                            self.address2 = value
                        }else{
                            self.address2 = ""
                        }
                    }
                })
            
            <<< TextRow(){
                $0.title = "Address 3"
                
                }.cellUpdate({ (cell, row) in
                    if let value = row.value{
                        if value != ""{
                            self.address3 = value
                        }else{
                            self.address3 = ""
                        }
                    }
                })
            
            <<< TextRow(){
                $0.title = "City"
                
                
                }.cellUpdate({ (cell, row) in
                    if let value = row.value{
                        if value != ""{
                            self.city = value
                        }else{
                            self.city = ""
                        }
                    }
                })
            
            <<< TextRow(){
                $0.title = "State"
                
                }.cellUpdate({ (cell, row) in
                    if let value = row.value{
                        if value != ""{
                            self.state = value
                        }else{
                            self.state = ""
                        }
                    }
                })
            <<< TextRow(){
                $0.title = "Pincode"
                
                }.cellUpdate({ (cell, row) in
                    if let value = row.value{
                        if value != ""{
                            self.pincode = value
                        }else{
                            self.pincode = ""
                        }
                    }
                })
        
    }

}
