//
//  ApplyStationaryViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੨੪/੧੦/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import SearchTextField
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ApplyStationaryCell : MGSwipeTableCell{
    
    @IBOutlet weak var assetNameLbl: UILabel!
    @IBOutlet weak var assetQuantLbl: UILabel!
    @IBOutlet weak var remarkLbl: UILabel!
    
}
class ApplyStationaryViewController: UIViewController{

    struct Stationary{
        
        let name : String?
        let quant : String?
        let remark : String?
        let code : String?
    }
    
    var code = ""
    
    var stationaryName = [String]()
    var stationaryCode = [String]()
    
    var stationaryList = [Stationary]()
    
    @IBOutlet weak var stationaryTF: SearchTextField!
    @IBOutlet weak var quantityTF: UITextField!
    @IBAction func quantityTF(_ sender: UITextField) {
        if quantityTF.text != ""{
            if Int(quantityTF.text!)! > 0 && Int(quantityTF.text!)! < 99{
                
            }else{
                SVProgressHUD.showInfo(withStatus: "Quantity can't be more than 99")
                quantityTF.text = ""
                quantityTF.becomeFirstResponder()
            }
        }else{
            SVProgressHUD.showInfo(withStatus: "Please enter valid Quantity")
        }
    }
    @IBOutlet weak var remarksTF: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func clearBtn(_ sender: UIButton) {
        clearAll()
    }
    
    @IBAction func addBtn(_ sender: UIButton) {
        if stationaryList.count < 11{
            if stationaryTF.text != "" && quantityTF.text != ""{
                if stationaryName.contains(stationaryTF.text!){
                    if let remark = remarksTF.text{
                        stationaryList.append(Stationary(name: "\(stationaryTF.text!)", quant: "\(quantityTF.text!)", remark: "\(remark)" , code: "\(self.code)"))
                        tableView.reloadData()
                        quantityTF.text = ""
                        remarksTF.text = ""
                        stationaryTF.text = ""
                        checkForAssets()
                        
                        //scroll to last row
                        let lastRow: Int = self.tableView.numberOfRows(inSection: 0) - 1
                        let indexPath = IndexPath(row: lastRow, section: 0);
                        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                    }
                }else{
                    SVProgressHUD.showInfo(withStatus: "Please add valid asset")
                    stationaryTF.becomeFirstResponder()
                }
            }
        }else{
            SVProgressHUD.showInfo(withStatus: "You can not ask for more than 10 assets at a time")
        }
    }
    
    @IBOutlet weak var itemsLbl: UILabel!
    
    @IBAction func submitBtn(_ sender: UIButton) {
        getParams { (params) in
            
            let parameter = ["assetsData":params]
            var header =  [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "employeeCode")!, "assetsType" : "T"]
            
            Alamofire.request("\(LoginDetails.hostedIP)/sales/AssetsData", method : .post,  parameters : parameter, encoding: JSONEncoding.default , headers: header).responseJSON{
                response in
                
                print(parameter)
                
                let loginJSON : JSON = JSON(response.result.value)
                
                if response.result.isSuccess{
                    
                    
                    if (loginJSON["returnType"].string?.contains("Applied"))!{
                        SVProgressHUD.showSuccess(withStatus: loginJSON["returnType"].string)
                        self.clearAll()
                    }
                    
                    
                    
                }
                    
                else{
                    //print("Error: \(response.result.error!)")
                    print(loginJSON)
                }
                
            }
        }
    }
    
    @IBOutlet weak var totalItemStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let stationary = StationaryTypeModel()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        stationary.getStationaryType { (code, name) in
            self.stationaryCode = code
            self.stationaryName = name
            self.stationaryTF.filterStrings(name)
            
        }
        
        
        
        hideKeyboardWhenTappedAround()
        // MARK:-  Listen for keyBoard Events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    
    @objc func keyboardWillChange(notification: Notification){
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -50
        }
        else{
            view.frame.origin.y = 0
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        stationaryTF.startVisible = true
        stationaryTF.theme = SearchTextFieldTheme.lightTheme()
        
        stationaryTF.itemSelectionHandler = { filteredResults, itemPosition in
            // Just in case you need the item position
            self.code = self.stationaryCode[itemPosition]
            
            
            // Do whatever you want with the picked item
            self.stationaryTF.text = filteredResults[itemPosition].title
        }
        
        // Set the max number of results. By default it's not limited
        stationaryTF.maxNumberOfResults = 5
        
        stationaryTF.theme.font = UIFont.systemFont(ofSize: 12)
    }
}


extension ApplyStationaryViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationaryList.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reject = MGSwipeButton(title: "Delete",icon: UIImage(named:"table-error"), backgroundColor: UIColor.flatRed) {
            (sender: MGSwipeTableCell!) -> Bool in
            self.stationaryList.remove(at: indexPath.row)
            self.tableView.reloadData()
            self.checkForAssets()
            return true
        }
        reject.centerIconOverText()
        let cell = tableView.dequeueReusableCell(withIdentifier: "ascell", for: indexPath) as! ApplyStationaryCell
        
        cell.rightButtons = [reject]
        
        cell.assetNameLbl.text = stationaryList[indexPath.row].name
        cell.assetQuantLbl.text = stationaryList[indexPath.row].quant
        cell.remarkLbl.text = stationaryList[indexPath.row].remark
        return cell
    }
    
    func checkForAssets(){
        
        if !stationaryList.isEmpty{
            totalItemStack.isHidden = false
            var total = 0
            for x in stationaryList{
                total += Int(x.quant!)!
                itemsLbl.text = String(total)
                
            }
        }else{
            
            totalItemStack.isHidden = true
            itemsLbl.text = ""
        }
        
    }
    
    
    func getParams(completion : @escaping (([Any])->Void)){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var params = [Any]()
        
        for x in stationaryList{
            params.append(["EmployeeCode": defaults.string(forKey: "employeeCode")! ,"ApplyQuantity": Int(x.quant!)!,"ApplyProduct": x.code!, "ApplyDate": formatter.string(from: Date()),"Remark": x.remark!])
        }
        
        completion(params)
        
    }
    
    
    func clearAll(){
        
        code = ""
        
        stationaryTF.text = ""
        quantityTF.text = ""
        remarksTF.text = ""
        
        stationaryList = [Stationary]()
        
        tableView.reloadData()
        checkForAssets()
    }
    
}
