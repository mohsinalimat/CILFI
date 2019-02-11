//
//  LetterStatusTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੨੧/੧੧/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class LetterStatusCell : UITableViewCell{
    
    @IBOutlet weak var letterTypeLbl: UILabel!
    @IBOutlet weak var letterNameLbl: UILabel!
    @IBOutlet weak var copyTypeLbl: UILabel!
    @IBOutlet weak var applyDateLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var remarkLbl: UILabel!
    @IBOutlet weak var mgrRemarkLbl: UILabel!
    @IBOutlet weak var linkLbl: UILabel!
    
    
    
    
    
}


class LetterStatusTableViewController: UITableViewController {

    var name = [String]()
    var subName = [String]()
    var type  = [String]()
    var applyDate  = [String]()
    var status  = [String]()
    var remark  = [String]()
    var mgrRemark  = [String]()
    var link  = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        getData()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return name.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lsCell", for: indexPath) as! LetterStatusCell
        
        
        
        cell.letterTypeLbl.text = name[indexPath.row]
        cell.letterNameLbl.text = subName[indexPath.row]
        cell.copyTypeLbl.text = type[indexPath.row]
        cell.applyDateLbl.text = applyDate[indexPath.row]
        
        if status[indexPath.row] == "Pending"{
            cell.statusLbl.textColor = UIColor.flatOrange
        }else if status[indexPath.row] == "Approved"{
            cell.statusLbl.textColor = UIColor.flatGreen
        }else if status[indexPath.row] == "Rejected"{
            cell.statusLbl.textColor = UIColor.flatRed
        }
        cell.statusLbl.text = status[indexPath.row]
        cell.remarkLbl.text = remark[indexPath.row]
        cell.mgrRemarkLbl.text = mgrRemark[indexPath.row]
        cell.linkLbl.text = link[indexPath.row]
        
        return cell
    }

    func getData(){
        
        name = [String]()
        subName = [String]()
        type  = [String]()
        applyDate  = [String]()
        status  = [String]()
        remark  = [String]()
        mgrRemark  = [String]()
        link  = [String]()
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/LetterGeneration", method: .get, headers : headers).responseJSON{
            response in
            
            if response.result.isSuccess{
               
                do{
                    let letter = try JSONDecoder().decode(LetterStatusRoot.self, from: response.data!)
                    
                    //                    print(response.result.value)
                    for x in letter.letter {
                        
                        if let value = x.mainName{
                            self.name.append(value)
                        }
                        if let value = x.subName{
                            self.subName.append(value)
                        }

                        if let value = x.generateType{
                            self.type.append(value)
                        }

                        if let value = x.trDate{
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                            if let date = formatter.date(from: value){
                                formatter.dateFormat = "dd MMMM yyyy"
                                self.applyDate.append(formatter.string(from: date))
                            }
                            
                        }

                        
                        
                        if let value = x.mgrStatus{
                            self.status.append(value)
                        }
                        if let value = x.remark{
                            self.remark.append(value)
                        }

                        if let value = x.mgrRemark{
                            self.mgrRemark.append(value)
                        }
                        if let value = x.attachment{
                            self.link.append("\(LoginDetails.hostedIP)\(value)")
                        }
                    }
                    
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                }
                catch{
                    print (error)
                }
                
            }else{
                print("Something Went wrong")
            }
        }
        
        
    }
    
}
