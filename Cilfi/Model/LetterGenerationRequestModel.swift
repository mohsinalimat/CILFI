//
//  LetterGenerationRequestModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੧੯/੧੧/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import Foundation
import Alamofire

class LetterGenerationRequestModel{
    struct SubTypes{
        var subCategory : String?
        var subName : String?
        var link : String?
        var remark : String?
    }
   
    struct Types{
        var id : String?
        var category : String?
        var name : String?
    }
    
    func getLetterData(completion : @escaping ([String:[String:String]],[String:Any]) -> Void){
    
        
        
        
        var subdata = [String:Any]()
        
        
        var data = [String:[String:String]]()
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/lettertypes", method: .get, headers : headers).responseJSON{
            response in
            
            //            print(header)
            
            let atndData = response.data!
            
            if response.result.isSuccess{
                //                            print (response.result.value)
                do{
                    let atnd = try JSONDecoder().decode(LetterTypeRoot.self, from: atndData)
                    
                    //                    print(response.result.value)
                    for x in atnd.letter {
                        var subType = [Any]()
                        
                        for y in x.subtype{
                            let category = y.subCategory
                            let name = y.subName
                            let link = y.subLink
                            let remark = y.subRemark
                            
                            subType.append(SubTypes(subCategory: category, subName: name, link: link, remark: remark))
                           
                        }
                        
                        if let value = x.id{
                            subdata[value] = subType
                            data[value] = [x.name! : x.category!]
                        }
                        
                        
                        
                    }
                    
//                    print(data)
//                    print("\n\n\n\n\n")
//                    print(subdata)
                    completion(data, subdata)
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
