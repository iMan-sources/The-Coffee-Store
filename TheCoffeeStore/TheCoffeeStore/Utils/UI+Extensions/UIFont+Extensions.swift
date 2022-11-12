//
//  UIFont+Extensions.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 14/09/2022.
//

import Foundation
import UIKit

enum OpenSansType: String,CaseIterable{
    case bold =  "OpenSans-Bold"
    case semibold = "OpenSans-SemiBold"
    case medium = "OpenSans-Medium"
    case extrabold = "OpenSans-ExtraBold"
    case light = "OpenSans-Light"
}

extension UIFont{
    static func loadOpenSansFont(withType type: OpenSansType,ofSize size: CGFloat) -> UIFont?{
        return UIFont(name: type.rawValue, size: size) ?? UIFont.systemFont(ofSize: 17)
    }
}
