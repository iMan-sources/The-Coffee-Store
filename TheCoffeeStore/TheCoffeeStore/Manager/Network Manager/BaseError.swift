//
//  BaseError.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 02/10/2022.
//

import Foundation


enum PasswordError{
    case notValid
    case empty
    case matchPassword
    
    var description: String{
        switch self {
        case .notValid:
            return "Vui lòng điển mật khẩu hợp lệ"
        case .empty:
            return "Vui lòng điền mật khẩu"
        case .matchPassword:
            return "Mật khẩu không khớp"
        }
    }
}

enum EmailError{
    case notValid
    case empty
    
    var description: String{
        switch self {
        case .notValid:
            return "Vui lòng điển tài khoản hợp lệ"
        case .empty:
            return "Vui lòng điền tài khoản"
        }
    }
}

enum NameError{
    case empty
    
    var description: String{
        switch self {
        case .empty:
            return "Vui lòng điền "
        }
    }
}

enum PhoneError{
    case empty
    case notValid
    var description: String{
        switch self {
        case .empty:
            return "Vui lòng điền "
        case .notValid:
            return "Vui lòng điền số điện thoại hợp lệ"
        }
    }
}
