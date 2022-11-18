//
//  Date+Extensions.swift
//  TheCoffeeApp
//
//  Created by Le Viet Anh on 12/11/2022.
//

import UIKit

extension Date {
        
    var millisecondsSince1970:Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    func convertDateToString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = " HH:mm dd-MM-yyyy"
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
