//
//  Voucher.swift
//  TheCoffeeApp
//
//  Created by Le Viet Anh on 01/11/2022.
//

import Foundation

struct Voucher{
    var id: String?=nil
    let title: String
    let content: String
    let expireDate: String
    var price: Double?=nil
    var percentage: Double?=nil
    var isActive: Bool?=false
    
    mutating func setPercentage(percentage: Double){
        self.percentage = percentage
    }
    
    mutating func setPrice(price: Double){
        self.price = price
    }
}
