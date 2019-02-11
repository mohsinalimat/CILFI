//
//  ApplyAssetsViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੧੮/੧੦/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import SearchTextField
import Alamofire
import SwiftyJSON
import SVProgressHUD
class ApplyAssetsCell : MGSwipeTableCell{
    
    @IBOutlet weak var assetNameLbl: UILabel!
    @IBOutlet weak var assetQuantLbl: UILabel!
    @IBOutlet weak var remarkLbl: UILabel!
}




class ApplyAssetsViewController: UIViewController {
    
    struct Assets{
        
        let name : String?
        let quant : String?
        let remark : String?
        let code : String?
    }
    
    var code = ""
    
    var assetName = [String]()
    var assetCode = [String]()
    
    var assetList = [Assets]()
    
    @IBOutlet weak var assetTF: SearchTextField!
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
    @IBOutlet weak var remarkTF: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func clearBtn(_ sender: UIButton) {
        clearAll()
    }
    
    @IBAction func addBtn(_ sender: UIButton) {
        if assetList.count < 11{
            if assetTF.text != "" && quantityTF.text != ""{
                if assetName.contains(assetTF.text!){
                    if let remark = remarkTF.text{
                        assetList.append(Assets(name: "\(assetTF.text!)", quant: "\(quantityTF.text!)", remark: "\(remark)" , code: "\(self.code)"))
                        tableView.reloadData()
                        quantityTF.text = ""
                        remarkTF.text = ""
                        assetTF.text = ""
                        checkForAssets()
                        
                        //scroll to last row
                        let lastRow: Int = self.tableView.numberOfRows(inSection: 0) - 1
                        let indexPath = IndexPath(row: lastRow, section: 0);
                        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                    }
                }else{
                    SVProgressHUD.showInfo(withStatus: "Please add valid asset")
                    assetTF.becomeFirstResponder()
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
            var header =  [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "employeeCode")!, "assetsType" : "A"]
            
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
        
        let asset = AssetTypeModel()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        asset.getAssetType { (code, name) in
            self.assetCode = code
            self.assetName = name
            self.assetTF.filterStrings(name)
            
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
        assetTF.startVisible = true
        assetTF.theme = SearchTextFieldTheme.lightTheme()
        
        assetTF.itemSelectionHandler = { filteredResults, itemPosition in
            // Just in case you need the item position
            self.code = self.assetCode[itemPosition]
            
            
            // Do whatever you want with the picked item
            self.assetTF.text = filteredResults[itemPosition].title
            
            
        }
        // Set the max number of results. By default it's not limited
        assetTF.maxNumberOfResults = 5
        
        assetTF.theme.font = UIFont.systemFont(ofSize: 12)
    }
    
}

extension ApplyAssetsViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetList.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reject = MGSwipeButton(title: "Delete",icon: UIImage(named:"table-error"), backgroundColor: UIColor.flatRed) {
            (sender: MGSwipeTableCell!) -> Bool in
            self.assetList.remove(at: indexPath.row)
            self.tableView.reloadData()
            self.checkForAssets()
            return true
        }
        reject.centerIconOverText()
        let cell = tableView.dequeueReusableCell(withIdentifier: "aacell", for: indexPath) as! ApplyAssetsCell
        
        cell.rightButtons = [reject]
        
        cell.assetNameLbl.text = assetList[indexPath.row].name
        cell.assetQuantLbl.text = assetList[indexPath.row].quant
        cell.remarkLbl.text = assetList[indexPath.row].remark
        return cell
    }
    
    func checkForAssets(){
        
        if !assetList.isEmpty{
            totalItemStack.isHidden = false
            var total = 0
            for x in assetList{
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
        
        for x in assetList{
            params.append(["EmployeeCode": defaults.string(forKey: "employeeCode")! ,"ApplyQuantity": Int(x.quant!)!,"ApplyProduct": x.code!, "ApplyDate": formatter.string(from: Date()),"Remark": x.remark!])
        }
        
        completion(params)
        
    }
    
    
    func clearAll(){
        
        code = ""
        
        assetTF.text = ""
        quantityTF.text = ""
        remarkTF.text = ""
        
        assetList = [Assets]()
        
        tableView.reloadData()
        checkForAssets()
    }
    
}
