//
//  Form16ViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 23/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import PDFKit
import DropDown
import Alamofire
import SVProgressHUD
import SimplePDF

@available(iOS 11.0, *)

class Form16ViewController: UIViewController {

    let form16URL = "\(LoginDetails.hostedIP)/sales/FormNo16"
    let date = Date()
    let formatter = DateFormatter()
    var pdf = PDFDocument()
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var form16: PDFView!
    
    let button = UIButton.init(type: .custom)
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        formatter.dateFormat = "yy"
        let year = formatter.string(from: date)
        let currentyear = Int(year)
        
        dateLbl.text = "\(currentyear!)-\(currentyear!+1)"
        

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var downloadPDF: UIButton!
    
    @IBAction func downloadPDF(_ sender: UIButton) {
        
        
        let activityViewController = UIActivityViewController(activityItems: [pdf.dataRepresentation()], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.addToReadingList, .assignToContact]
        present(activityViewController, animated: true, completion: nil)
        
        
    }
    @IBAction func dateBtn(_ sender: UIButton) {
        
        let year = formatter.string(from: date)
        let currentyear = Int(year)
        
        let dropDown = DropDown()
        var assesmentYear = String()
        
        dropDown.dataSource = ["\(currentyear!-1)-\(currentyear!)", "\(currentyear!)-\(currentyear!+1)", "\(currentyear!+1)-\(currentyear!+2)"]
        dropDown.anchorView = dateLbl
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            
         self.dateLbl.text = item
            if index == 0{
                assesmentYear = "\(currentyear!-1)\(currentyear!)"
            }else  if index == 1{
                assesmentYear = "\(currentyear!)\(currentyear!+1)"
            }else if index == 2{
                assesmentYear = "\(currentyear!+1)\(currentyear!+2)"
            }
            
            self.getForm16(assmyr: assesmentYear)
     }
    }
    
    func getForm16(assmyr : String){
        
        let header : [String:String] = ["username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "assmyr" : assmyr, "employeecode" : defaults.string(forKey: "user")!]
        
        
        Alamofire.request(form16URL, method: .get, headers : header).responseJSON{
            response in
            
            let form16Data = response.data!
            let form16JSON = response.result.value
            
            if response.result.isSuccess{
//                               print(form16JSON)
                do{
                    if #available(iOS 11.0, *) {
                    let getFormNo16 = try JSONDecoder().decode(Form16Root.self, from: form16Data)
                    //line chart
                    if let form = getFormNo16.form16{
                        
                        if form == ""{
                            SVProgressHUD.showError(withStatus: "PDF not available.")
                            SVProgressHUD.dismiss(withDelay: 3)
                            self.form16.document = nil
                            self.downloadPDF.isHidden = true
                        }else{
                            let finalurl = URL(string: "\(LoginDetails.hostedIP)\(form)" )
                            self.form16.document = PDFDocument(url: finalurl!)
                            let doc = PDFDocument(url: finalurl!)!
                            self.pdf = doc
                            
                            self.downloadPDF.isHidden = false
                            
                        }
                        
                    }
                    
                    //                    print(self.empName)
                    //                    print(self.leaveType)
                    
                    }else{
                        SVProgressHUD.showError(withStatus: "The feature to view pdf is only availabe in IOS 11.0 and newer versions.")
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
    
  
}
    

