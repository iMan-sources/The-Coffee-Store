//
//  String+Extensions.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 25/09/2022.
//

import UIKit


extension String{
    func getSize(withAttrs attrs: [NSAttributedString.Key: Any]) -> CGSize{
        let textSize = (self as NSString).size(withAttributes: attrs)
        return textSize
    }
}
