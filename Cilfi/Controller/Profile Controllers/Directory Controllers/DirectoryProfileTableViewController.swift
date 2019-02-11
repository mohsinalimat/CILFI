//
//  DirectoryProfileTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੪/੧੨/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import UIKit
import TwicketSegmentedControl
import SDWebImage
import GSImageViewerController
import MessageUI
import SVProgressHUD

class DirectoryProfileCell : UITableViewCell{
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
}


class DirectoryKudosCell: UITableViewCell{
    
    
}


class DirectoryPostsCell : UITableViewCell{
    
    @IBOutlet weak var profileImg: UIImageView!{
        didSet{
            profileImg.layer.borderWidth = 1.0
            profileImg.layer.masksToBounds = false
            profileImg.layer.borderColor = UIColor.white.cgColor
            profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
            profileImg.clipsToBounds = true
        }
    }
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var postTV: UITextView!
    @IBOutlet weak var postImg: UIImageView!
    
    @IBOutlet weak var likeImgBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    
    @IBOutlet weak var commentImgBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    
}

class DirectoryProfileTableViewController: UITableViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, TwicketSegmentedControlDelegate {
    
    private struct TableViewData{
        var img = String()
        var title = String()
        var value = String()
        
    }
    
    
    private var tableViewData = [TableViewData]()
    
    private var posts = [String:[String]]()
    
    private var emp = ""
    private var selectedIndex = 0
    
    
    private var profile = [DirectoryModel.ManageProfile]()
    
    var header = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!]
    
    let directoryModel = DirectoryModel()
    
    
    @IBOutlet weak private var mainView: UIView!
    
    var profileImage : UIImage?
    
    
    @IBOutlet weak private var bannerImg: UIImageView!{
        didSet{
            bannerImg.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapCover))
            bannerImg.addGestureRecognizer(tap)
        }
    }
    
    @objc private func didTapCover(){
        
        let imageInfo      = GSImageInfo(image: UIImage(named: "sample")!, imageMode: .aspectFit, imageHD: nil)
        let transitionInfo = GSTransitionInfo(fromView: self.tableView)
        let imageViewer    = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        present(imageViewer, animated: true, completion: nil)
        
    }
    
    
    @IBOutlet weak private var profileImg: UIImageView!{
        didSet{
            profileImg.layer.borderWidth = 1.0
            profileImg.layer.masksToBounds = false
            profileImg.layer.borderColor = UIColor.white.cgColor
            profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
            profileImg.clipsToBounds = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapImage))
            profileImg.addGestureRecognizer(tap)
            
        }
    }
    
    @objc private func didTapImage() {
        
        //1:02
        
        if let img = profileImage{
            let imageInfo      = GSImageInfo(image: img, imageMode: .aspectFit, imageHD: nil)
            let transitionInfo = GSTransitionInfo(fromView: self.tableView)
            let imageViewer    = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
            present(imageViewer, animated: true, completion: nil)
        }
        
        
    }
    
    
    @IBOutlet weak private var followBtn: UIButton!
    @IBAction private func followBtn(_ sender: UIButton) {
        
    }
    @IBOutlet weak private var nameLbl: UILabel!
    @IBOutlet weak private var designationLbl: UILabel!
    @IBOutlet weak private var managerLbl: UILabel!
    
    
    
    @IBOutlet weak var segmentView: TwicketSegmentedControl!{
        didSet{
            segmentView.setSegmentItems(["Profile", "Posts", "Kudos"])
            segmentView.sliderBackgroundColor = UIColor.init(hexString: "22B0D7")!
            
        }
    }
    
    @IBOutlet weak var phoneBtn: UIButton!
    @IBAction func phoneBtn(_ sender: UIButton) {
        if directory.first?.mobile != ""{
            let phoneNumber: String = "tel://\(directory.first!.mobile!)"
            UIApplication.shared.openURL(URL(string: phoneNumber)!)
        }else{
            SVProgressHUD.showInfo(withStatus: "Number not found")
        }
    }
    
    @IBOutlet weak var messageBtn: UIButton!
    @IBAction func messageBtn(_ sender: UIButton) {
        
        if directory.first?.mobile != ""{
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                controller.body = "Sent from Cilfi App!"
                controller.recipients = ([directory.first?.mobile] as! [String])
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            }
            
        }else{
            SVProgressHUD.showInfo(withStatus: "Number not found")
        }
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var mailBtn: UIButton!
    @IBAction func mailBtn(_ sender: UIButton) {
        if directory.first?.email != ""{
            if !MFMailComposeViewController.canSendMail() {
                SVProgressHUD.showInfo(withStatus: "Your phone doesn't have the mail app.")
                return
            }else{
                let composeVC = MFMailComposeViewController()
                composeVC.mailComposeDelegate = self
                
                // Configure the fields of the interface.
                composeVC.setToRecipients(["address@example.com"])
                composeVC.setSubject("Hello!")
                composeVC.setMessageBody("Hello from California!", isHTML: false)
                
                // Present the view controller modally.
                self.present(composeVC, animated: true, completion: nil)
            }
        }else{
            SVProgressHUD.showInfo(withStatus: "Email ID not found")
        }
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBOutlet weak var linkedInBtn: UIButton!
    @IBAction func linkedInBtn(_ sender: UIButton) {
        
        if directory.first?.linkedin != ""{
            
            let username = directory.first!.linkedin
            
            let webURL = URL(string: "https://www.linkedin.com/in/\(username)/")!
            
            let appURL = URL(string: "linkedin://profile/\(username)")!
            
            if UIApplication.shared.canOpenURL(appURL) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
            }
        }else{
            SVProgressHUD.showInfo(withStatus: "LinkedIn ID not found")
        }
    }
    
    @IBOutlet weak var twiterBtn: UIButton!
    @IBAction func twiterBtn(_ sender: UIButton) {
        
        if directory.first?.twiter != ""{
            
            let username = directory.first!.twiter
            let appURL = NSURL(string: "twitter:///user?screen_name=\(username)")!
            let webURL = NSURL(string: "https://twitter.com/\(username)")!
            let application = UIApplication.shared
            if application.canOpenURL(appURL as URL) {
                application.open(appURL as URL)
            } else {
                // if Instagram app is not installed, open URL inside Safari
                application.open(webURL as URL)
            }
            
        }else{
            SVProgressHUD.showInfo(withStatus: "Twitter ID not found")
        }
    }
    
    @IBOutlet weak var postTF: UITextField!{
        didSet{
            let button = UIButton(type: .custom)
            button.imageView?.contentMode = .scaleAspectFit
            button.setImage(UIImage(named: "directory-postsTF-icon"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            button.frame = CGRect(x: CGFloat(postTF.frame.size.width - 25), y: CGFloat(5), width: CGFloat(15), height: CGFloat(15))
            button.addTarget(self, action: #selector(self.sendPost), for: .touchUpInside)
            postTF.rightView = button
            postTF.rightViewMode = .always
        }
    }
    
    @objc func sendPost(){
        print("hello")
        
    }
    
    @IBOutlet weak var kudosTF: UITextField!{
        didSet{
            let button = UIButton(type: .custom)
            button.imageView?.contentMode = .scaleAspectFit
            button.setImage(UIImage(named: "directory-kudos-icon"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            button.frame = CGRect(x: CGFloat(kudosTF.frame.size.width - 25), y: CGFloat(5), width: CGFloat(15), height: CGFloat(15))
            button.addTarget(self, action: #selector(self.sendPost), for: .touchUpInside)
            kudosTF.rightView = button
            kudosTF.rightViewMode = .always
        }
    }
    
    var directory =  [Directory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        header["employeecode"] = directory.first?.code
        
        print(header)
        
        if let imageUrl:URL = URL(string: "\(LoginDetails.hostedIP)\(directory.first!.image!)"){
            profileImg.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "menu-user-icon"))
            if let imageData:NSData = NSData(contentsOf: imageUrl){
                profileImage = UIImage(data: imageData as Data)
            }
            
        }
        
        
        
        nameLbl.text = directory.first!.name
        designationLbl.text = directory.first!.designation
        
        managerLbl.text = "\(directory.first!.manager!) - \(directory.first!.department!)"
        
        
        SVProgressHUD.dismiss(withDelay: 3)
        
        segmentView.delegate = self
        
        hideKeyboardWhenTappedAround()
        
        
       
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        getProfileData()
    }
    
    
    func didSelect(_ segmentIndex: Int) {
        
        selectedIndex = segmentIndex
        
        if segmentIndex == 0{
            self.mainView.frame = CGRect(x: 0, y: 0, width: self.mainView.frame.width, height: 378)
            postTF.isHidden = true
            kudosTF.isHidden = true
//            self.mainView.layoutIfNeeded()
//            self.view.layoutIfNeeded()
//            self.tableView.layoutIfNeeded()
            getProfileData()
        }else if segmentIndex == 2{
            self.mainView.frame = CGRect(x: 0, y: 0, width: self.mainView.frame.width, height: 430)
            postTF.isHidden = true
            kudosTF.isHidden = false
//            self.mainView.layoutIfNeeded()
//            self.view.layoutIfNeeded()
//            self.tableView.layoutIfNeeded()
        }else if segmentIndex == 1{
            self.mainView.frame = CGRect(x: 0, y: 0, width: self.mainView.frame.width, height: 430)
            postTF.isHidden = false
            kudosTF.isHidden = true
//            self.mainView.layoutIfNeeded()
//            self.view.layoutIfNeeded()
//            self.tableView.layoutIfNeeded()
            getPostsData()
        }
        
        
        
        
        //        self.tableView.reloadData()
    }
    
    
    
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedIndex == 0{
            return tableViewData.count
        }else if selectedIndex == 1{
            return posts["rowSeq"]?.count ?? 1
        }else{
            return 1
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if selectedIndex == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "dpCell", for: indexPath) as! DirectoryProfileCell
            cell.heading.text = tableViewData[indexPath.row].value
            cell.img.image = UIImage(named: tableViewData[indexPath.row].img)
            //            print(tableViewData[indexPath.row].value)
            cell.backgroundColor = UIColor.flatWhite
            cell.accessoryType = .none
            //                cell.menuImg.image = UIImage(named: "menu-\(tableViewData[indexPath.section].title.replacingOccurrences(of: " ", with: ""))-icon")
            cell.editingAccessoryType = .disclosureIndicator
            //                cell.menuName.font = cell.menuName.font.withSize(15)
            //                cell.menuImg.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            return cell
            
            
        }else if selectedIndex == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "DPCell", for: indexPath) as! DirectoryPostsCell
            cell.dateLbl.text = posts["date"]![indexPath.row]
            cell.nameLbl.text = posts["remarksBy"]![indexPath.row]
            
                return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dkCell", for: indexPath) as! DirectoryKudosCell
            
            return cell
        }
        
        
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    func getProfileData(){
        
        self.directoryModel.getManageProfile(header: self.header) { (profile) in
            self.tableViewData = [TableViewData]()
            for x in profile{
                
                
                for y in x.experience{
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    let fDate = formatter.date(from: y.fromDate!)
                    let tDate = formatter.date(from: y.toDate!)
                    formatter.dateFormat = "MMMM yyyy"
                    
                    self.tableViewData.append(TableViewData(img: "directory-experience-icon", title: "Certificates", value: "\(y.company!)\n\(y.designation!)\n\(formatter.string(from: fDate!)) - \(formatter.string(from: tDate!))"))
                    
                }
                
                
                
                for y in x.education{
                    
                    self.tableViewData.append(TableViewData(img: "directory-education-icon", title: "Certificates", value: "\(y.degree!)\n\(y.year!)\n\(y.university!)"))
                    
                }
                
                for y in x.certificate{
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    let fDate = formatter.date(from: y.fromDate!)
                    let tDate = formatter.date(from: y.toDate!)
                    formatter.dateFormat = "MMMM yyyy"
                    
                    self.tableViewData.append(TableViewData(img: "directory-certificates-icon", title: "Certificates", value: "\(y.name!)\n\(y.auth!)\n\(formatter.string(from: fDate!)) - \(formatter.string(from: tDate!))"))
                    
                }
               
                //
                //
                //                self.tableViewData.append(TableViewData(opened: false, title: "Education", value: "", sectionData: education ))
                //                self.tableViewData.append(TableViewData(opened: false, title: "Experince", value: "", sectionData: experince))
                                self.tableViewData.append(TableViewData(img: "", title: "Manager Head",  value: x.managerHead!))
                                self.tableViewData.append(TableViewData(img: "", title: "About", value: x.aboutMe!))
                                self.tableViewData.append(TableViewData(img: "", title: "Address", value: x.address!))
                                self.tableViewData.append(TableViewData(img: "", title: "Department", value: x.department!))
                                self.tableViewData.append(TableViewData(img: "", title: "Hobbies", value: x.hobbies!))
                                self.tableViewData.append(TableViewData(img: "", title: "Skills", value: x.skills!))
                //
               
            }
            
        }
     
//        print(tableViewData)
        tableView.reloadData()
    }
    
    
    
    func getPostsData(){
    
        self.directoryModel.getEmployeeFeedback(header: header) { (post) in
            self.posts = post as! [String:[String]]
            self.tableView.reloadData()
        }
    
    
    
    
    
    }
    
    
}
