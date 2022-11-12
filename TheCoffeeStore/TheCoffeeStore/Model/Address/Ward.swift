//
//  Ward.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 01/10/2022.
//

import Foundation
struct Ward: Codable {
    let name: String
    let code: Int
    let divisionType: String
    let codename: String
    let districtCode: Int

    enum CodingKeys: String, CodingKey {
        case name, code
        case divisionType = "division_type"
        case codename
        case districtCode = "district_code"
    }
}
