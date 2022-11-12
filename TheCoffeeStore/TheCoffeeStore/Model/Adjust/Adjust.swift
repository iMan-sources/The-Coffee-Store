//
//  Adjust.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 13/10/2022.
//

import Foundation

struct Adjust{
    public private(set ) var id: String? = ""
    public private(set) var title: String
    public private(set) var type: String
    public private(set) var isDefault: Bool = false
    public private(set) var isSelected: Bool = false
    
    mutating func setIsSelected(isSelected: Bool){
        self.isSelected = isSelected
    }
}
