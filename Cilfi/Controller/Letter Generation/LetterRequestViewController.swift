//
//  LetterRequestViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੧੭/੧੧/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import UIKit
import PDFKit
import McPicker
import DropDown
import WebKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import MobileCoreServices


class LetterRequestViewController: UIViewController, UIDocumentPickerDelegate {

    var data = [String:[String:String]]()
    var subData = [String:Any]()
    
    var mainCategory = ""
    var letterName = ""
    var letterID = ""
    var index = -1
    
    var link = ""
    var subName = ""
    var subCategory = ""
    
    var copyType = ""
    
    var attachment = ""
    
    @IBOutlet weak var typeBtn: UIButton!
    @IBAction func typeBtn(_ sender: UIButton) {
        var letterName = [String]()
        var category = [String]()
        var letterID = [String]()
        
        for x in data{
            for y in x.value.keys{
                letterName.append(y)
            }
            for y in x.value.values{
                category.append(y)
            }
        }
        
        for x in data{
            letterID.append(x.key)
        }
        
        let dropDown = DropDown()
        dropDown.dataSource = letterName
        dropDown.anchorView = typeBtn
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            self.letterID = letterID[index]
            self.letterName = item
            self.mainCategory = category[index]
            
            self.nameBtn.setTitle("--- Select ---", for: .normal)
            
            print(letterID[index])
            print(item)
            print(category[index])
            self.typeBtn.setTitle(item, for: .normal)
           
            self.subName = ""
            self.link = ""
            self.subCategory = ""
            self.webView.load(URLRequest(url: URL(string:"about:blank")!))
            self.infoLbl.isHidden = true
            
            
            
        }
    }
    @IBOutlet weak var nameBtn: UIButton!
    @IBAction func nameBtn(_ sender: UIButton) {
       
        var subName = [String]()
        var subCategory = [String]()
        var link = [String]()
        var remarks = [String]()
        
        
        for x in subData{
            if x.key == letterID{
                for y in x.value as! [LetterGenerationRequestModel.SubTypes]{
                    
                    if let value = y.subName{
                        subName.append(value)
                    }
                    
                    if let value = y.subCategory{
                        subCategory.append(value)
                    }
                    
                    if let value = y.link{
                        link.append(value)
                    }
                    
                    if let value = y.remark{
                        remarks.append(value)
                    }
                }
                
            }

        }

        let dropDown = DropDown()
        dropDown.dataSource = subName
        dropDown.anchorView = nameBtn
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
             self.webView.load(URLRequest(url: URL(string:"about:blank")!))
            self.nameBtn.setTitle(item, for: .normal)
            self.link = link[index]
            self.subName = item
            self.subCategory = subCategory[index]
            
//            print(link[index])
//            print(item)
//            print(subCategory[index])
            
            self.getDocument()
            SVProgressHUD.show()
            
            self.infoLbl.isHidden = true
            
        }

    }
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var infoLbl: UILabel!
    
    @IBOutlet weak var hardSoft: UIButton!
    @IBAction func hardSoft(_ sender: UIButton) {
       
      
        
        McPicker.showAsPopover(data:[["Hard Copy", "Soft Copy"]], fromViewController: self, sourceView: sender, doneHandler: { [weak self] (selections: [Int : String]) -> Void in
           
            }, cancelHandler: { () -> Void in
                self.hardSoft.setTitle("--- Select copy type ---", for: .normal)
                self.copyType = ""
        }, selectionChangedHandler: { (selections: [Int:String], componentThatChanged: Int) -> Void  in
            if selections[0] == "Hard Copy"{
                self.copyType = "H"
            }else{
                self.copyType = "S"
            }
            
                self.hardSoft.setTitle(selections[0], for: .normal)
        })
        
    }
    
    @IBOutlet weak var attechmentTF: UITextField!
    @IBAction func attachmentBtn(_ sender: UIButton) {
        let types: [String] = [kUTTypePDF as String]
        let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .popover
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    @IBOutlet weak var remarksTF: UITextField!
    
    
    @IBAction func submitBtn(_ sender: UIButton) {
        
        if letterID != ""{
            if subCategory != ""{
                if copyType != ""{
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    
                    setData(params: ["EmployeeCode": defaults.string(forKey: "user")!,"LetterID":letterID,"LetterMainCategory":mainCategory,"LetterSubCategory":subCategory,"LetterGenerateType":copyType,"Remark":remarksTF.text!,"ApplyDate":formatter.string(from: Date())])
                    
                   
                   
                }else{
                    SVProgressHUD.showError(withStatus: "Please select Copy Type")
                }
            }else{
                SVProgressHUD.showError(withStatus: "Please select Letter Name")
            }
        }else{
            SVProgressHUD.showError(withStatus: "Please select Letter Type")
        }
        
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let letter = LetterGenerationRequestModel()
        letter.getLetterData { (data, subdata) in
            self.data = data
            self.subData = subdata
            
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
            view.frame.origin.y = -250
        }
        else{
            view.frame.origin.y = 0
        }
        
        
    }
    

    func getDocument(){
            
        Alamofire.request("\(LoginDetails.hostedIP)/sales/sampleletter", method: .get, headers : [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "employeeCode")!, "lettername" : link]).responseJSON{
                response in
                
                //            print(header)
                
               if let loginJSON : JSON = JSON(response.result.value){
                
                if response.result.isSuccess{
                   
                        if let value = loginJSON["returnType"].string{
                            let string : NSString = "\(LoginDetails.hostedIP)\(value)" as NSString
                            let nsstring : NSString = string.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue).rawValue)! as NSString
                            let searchURL : NSURL = NSURL(string: nsstring as String)!
                            
                            self.webView.load(URLRequest(url: searchURL as URL))
                            
                            SVProgressHUD.dismiss()
                            self.infoLbl.isHidden = false
                        }
                        
                   
                    
                }else{
                    self.infoLbl.isHidden = true
                    print("Something Went wrong")
            }
            }
        }        
    }
    
        
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // you get from the urls parameter the urls from the files selected
        let urlArr = urls[0].absoluteString.components(separatedBy: "/")
        if let filename = urlArr.last{
            attechmentTF.text = filename
        }
        
        
        let filePath = urls.first //URL of the PDF
        let fileData = try! Data.init(contentsOf: filePath!)
        attachment = fileData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        
        
    }
    

    
    func setData(params : [String:String]){
    
        Alamofire.request("\(LoginDetails.hostedIP)/sales/LetterGeneration" , method : .post,  parameters : params, encoding: JSONEncoding.default , headers: headers).responseJSON{
            response in
            
            let loginJSON : JSON = JSON(response.result.value)
            
            if response.result.isSuccess{
                if loginJSON["returnType"].string == "Letter request successfully"{
                    SVProgressHUD.showSuccess(withStatus: loginJSON["returnType"].string)
                    
                    self.clearAll()
                }else{
                    SVProgressHUD.showError(withStatus: loginJSON["returnType"].string)
                }
            }
        }
    
    
    }
    
    
    
    func clearAll(){
        
        typeBtn.setTitle("--- Select ---", for: .normal)
        nameBtn.setTitle("--- Select ---", for: .normal)
        
        webView.load(URLRequest(url: URL(string:"about:blank")!))
        
        hardSoft.setTitle("--- Select ---", for: .normal)
        
        infoLbl.isHidden = true
        remarksTF.text = ""
        
        mainCategory = ""
        letterName = ""
        letterID = ""
        index = -1
        
        link = ""
        subName = ""
        subCategory = ""
        
        copyType = ""
        
        attachment = ""
    }
    
}
