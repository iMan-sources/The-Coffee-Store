//
//  Size.swift
//  TheCoffeeApp
//
//  Created by Le Viet Anh on 25/10/2022.
//

import Foundation

struct Size{

    public private(set ) var name: String
    public private(set ) var rate: Double
    public private(set ) var isDefault: Bool
    public private(set ) var isSelected: Bool? = false
    
    mutating func setIsSelected(isSelected: Bool){
        self.isSelected = isSelected
    }
}
