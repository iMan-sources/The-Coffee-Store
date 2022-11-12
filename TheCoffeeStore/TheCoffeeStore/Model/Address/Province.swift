//
//  Province.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 01/10/2022.
//

import Foundation
struct Province: Codable {
    let name: String
    let code: Int
    let divisionType, codename: String
    let phoneCode: Int
    let districts: [District]
    
    enum CodingKeys: String, CodingKey {
        case name, code
        case divisionType = "division_type"
        case codename
        case phoneCode = "phone_code"
        case districts
    }
}
