//
//  FetchDatesOfAMonth.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੩੧/੧੦/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import Foundation

class FetchDatesOfAMonth{
    
    func getDates(year : Int, month : Int) -> Int{
        
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        print(numDays)
        
        return numDays
    }
    
   
    
}


