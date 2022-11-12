//
//  User.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 30/09/2022.
//

import Foundation

struct User: Codable{
    var id: String?=nil
    let personalInfor: PersonalInfor
    let address: Address
}

struct PersonalInfor: Codable{
    let firstName: String
    let lastName: String
    let appelation: String
    let phoneNumber: String
    let birthday: Birthday
}

struct Birthday: Codable{
    let month: String
    let date: String
}

struct Address: Codable{
    let province: String
    let district: String
    let ward: String
    let addressDetail: String

}



