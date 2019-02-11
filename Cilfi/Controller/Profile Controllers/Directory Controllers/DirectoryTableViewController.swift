//
//  DirectoryTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੨੮/੧੧/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD


struct Directory {
    
    var name : String?
    var code : String?
    var designation : String?
    var department : String?
    
    var mobile : String?
    var image : String?
    
    var email: String?
    var facebook : String?
    var instagram : String?
    var linkedin : String?
    var skype : String?
    var twiter : String?
    
    var manager : String?
    
}

class DirectoryCell : UITableViewCell{
    
    @IBOutlet weak var imgView: UIImageView!{
        didSet{
            imgView.layer.borderWidth = 1.0
            imgView.layer.masksToBounds = false
            imgView.layer.borderColor = UIColor.white.cgColor
            imgView.layer.cornerRadius = imgView.frame.size.width / 2
            imgView.clipsToBounds = true
            
        }
    }
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var designationLbl: UILabel!
    
}


class DirectoryTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    
   
    
    
    var directory = [Directory]()
    var searching = false
    
    var searchDirectory = [Directory]()
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        getDirectoryData()
        
        SVProgressHUD.show()
        
    }

    // MARK: - Table view data source

   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searching{
            return searchDirectory.count ?? 1
        }else{
            return directory.count ?? 1
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dCell", for: indexPath) as! DirectoryCell
        
        if searching{
        cell.imgView.sd_setImage(with: URL(string: "\(LoginDetails.hostedIP)\(searchDirectory[indexPath.row].image!)"))
        
        cell.nameLbl.text = searchDirectory[indexPath.row].name
        cell.designationLbl.text = searchDirectory[indexPath.row].designation
        }else{
            cell.imgView.sd_setImage(with: URL(string: "\(LoginDetails.hostedIP)\(directory[indexPath.row].image!)"))
            
            cell.nameLbl.text = directory[indexPath.row].name
            cell.designationLbl.text = directory[indexPath.row].designation
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToDirectoryProfile", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDirectoryProfile"{
            let index = tableView.indexPathForSelectedRow![1]
            let vc = segue.destination as! DirectoryProfileTableViewController
            vc.directory = [self.directory[index]]
            
        }
    }

    func getDirectoryData(){
        directory = [Directory]()
        Alamofire.request("\(LoginDetails.hostedIP)/sales/profiledirectory", method: .get, headers : headers).responseJSON{
            response in
            
            let dashData = response.data!
            let dashJSON = response.result.value
            
            if response.result.isSuccess{
//                print("dashJSON: \(dashJSON)")
                do{
                    let directory = try JSONDecoder().decode(ProfileDirectoryRoot.self, from: dashData)
                    
                    for x in directory.directory{
                        self.directory.append(Directory(name: x.name, code: x.code, designation: x.designation, department: x.department, mobile: x.mobile, image: x.img, email: x.emailID, facebook: x.facebookID, instagram: x.instagramID, linkedin: x.linkedinID, skype: x.skypeID, twiter: x.twitterID, manager : x.managerName))
                    }
                    SVProgressHUD.dismiss()
                    self.tableView.reloadData()
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


extension DirectoryTableViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchDirectory = directory.filter({ $0.name!.lowercased().prefix(searchText.count) == searchText.lowercased() })
        searching = true
        self.tableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        self.tableView.reloadData()
        dismissKeyboard()
    }
    
    
    
}
