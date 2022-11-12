//
//  Cart.swift
//  TheCoffeeApp
//
//  Created by Le Viet Anh on 25/10/2022.
//

import UIKit

struct Cart{
    public private(set) var id: String? = ""
    public private(set) var drink: Drink
    public private(set) var adjusts: [[Adjust]]
    public private(set) var size: [Size]
}
