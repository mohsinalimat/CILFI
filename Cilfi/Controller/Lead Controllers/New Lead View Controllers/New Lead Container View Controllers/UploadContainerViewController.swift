//
//  UploadContainerViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 04/07/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Eureka
import ImageRow

class UploadContainerViewController: FormViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()

        form +++ Section("Upload Images"){
            $0.header?.height = {40}
            $0.footer?.height = {0}
            }
            
            <<< ImageRow() {
                $0.title = "Visiting Card"
                $0.placeholderImage = UIImage(named: "form-camera")
                $0.sourceTypes = [.Camera ,.PhotoLibrary]
                $0.clearAction = .yes(style: UIAlertAction.Style.destructive)
                $0.onChange({ (image) in
                    
                   Upload.visitinCard = self.img64(image: image)
                    
                })
                }.cellSetup({ (cell, row) in
                    cell.height = {50}
                    cell.accessoryView?.layer.cornerRadius = 20
                })
            
            <<< ImageRow() {
                $0.title = "Front Shop"
                $0.placeholderImage = UIImage(named: "form-camera")
                $0.sourceTypes = [.Camera ,.PhotoLibrary]
                $0.clearAction = .yes(style: UIAlertAction.Style.destructive)
                $0.onChange({ (image) in
                   
                    Upload.frontOfShop = self.img64(image: image)
                    
                })
                }.cellSetup({ (cell, row) in
                    cell.height = {50}
                    cell.accessoryView?.layer.cornerRadius = 20
                })
            
            <<< ImageRow() {
                $0.title = "Stock in Godown"
                $0.placeholderImage = UIImage(named: "form-camera")
                $0.sourceTypes = [.Camera ,.PhotoLibrary]
                $0.clearAction = .yes(style: UIAlertAction.Style.destructive)
                $0.onChange({ (image) in
                   
                    Upload.godownStock = self.img64(image: image)
                
                })
                }.cellSetup({ (cell, row) in
                    cell.height = {50}
                    cell.accessoryView?.layer.cornerRadius = 20
                })
            
            <<< ImageRow() {
                $0.title = "Adjoining Shops"
                $0.placeholderImage = UIImage(named: "form-camera")
                $0.sourceTypes = [.Camera ,.PhotoLibrary]
                $0.clearAction = .yes(style: UIAlertAction.Style.destructive)
                $0.onChange({ (image) in
                    
                    Upload.adjoiningShop = self.img64(image: image)
                    
                })
                }.cellSetup({ (cell, row) in
                    cell.height = {50}
                    cell.accessoryView?.layer.cornerRadius = 20
                })
            
            
            
            +++ Section("Other"){
                $0.header?.height = {20}
                $0.footer?.height = {0}
            }
            
            <<< ImageRow() {
                $0.title = "Other (images)"
                $0.placeholderImage = UIImage(named: "form-attatch")
                $0.sourceTypes = [ .Camera ,.PhotoLibrary]
                $0.clearAction = .yes(style: UIAlertAction.Style.destructive)
                $0.onChange({ (image) in
                   
                    Upload.other = self.img64(image: image)
                    
                })
                }.cellSetup({ (cell, row) in
                    cell.height = {50}
                    cell.accessoryView?.layer.cornerRadius = 20
                })
    
        
      
    
    
    }

    func img64(image : ImageRow) -> String{
        var strBase64 = ""
        if let img = image.value{
            if let imageData:NSData = img.jpegData(compressionQuality: 0) as! NSData{
                strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            }
        }
        return strBase64
    }

}
