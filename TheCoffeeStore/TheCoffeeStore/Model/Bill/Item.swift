//
//  Item.swift
//  TheCoffeeApp
//
//  Created by Le Viet Anh on 11/11/2022.
//

import Foundation

struct Item{
    public private(set) var id: String? = ""
    public private(set) var billId: String = ""
    public private(set) var size: String = ""
    public private(set) var drinkId: String = ""
    public private(set) var creamId: String?=nil
    public private(set) var milkId: String?=nil
    public private(set) var coffeeId: String?=nil
    
    mutating func setCreamId(creamId: String){
        self.creamId = creamId
    }
    
    mutating func setMilkId(milkId: String){
        self.milkId = milkId
    }
    
    mutating func setCoffeeId(coffeeId: String){
        self.coffeeId = coffeeId
    }
    
    mutating func setBillId(billId: String){
        self.billId = billId
    }
    
    mutating func setSize(size: String){
        self.size = size
    }
    
    mutating func setDrinkId(drinkId: String){
        self.drinkId = drinkId
    }
    
}
