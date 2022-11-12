//
//  District.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 01/10/2022.
//

import Foundation
struct District: Codable {
    let name: String
    let code: Int
    let divisionType, codename: String
    let provinceCode: Int
    let wards: [Ward]
    
    enum CodingKeys: String, CodingKey {
        case name, code
        case divisionType = "division_type"
        case codename
        case provinceCode = "province_code"
        case wards
    }
}
