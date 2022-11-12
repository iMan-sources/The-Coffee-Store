//
//  UserDefaultsManager.swift
//  TheCoffeeApp
//
//  Created by Le Viet Anh on 03/11/2022.
//

import UIKit
enum AuthenSetting{
    case isLogged, userId
    
    var key: String{
        switch self {
        case .isLogged:
            return "isLogged"
        case .userId:
            return "user_id"
        }
    }
}
class UserDefaultsManager{
    static let shared = UserDefaultsManager()
    
    let defaults = UserDefaults.standard
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return defaults.object(forKey: key) != nil
    }
    
    
    func saveLogInStatus(isLogged: Bool){
        defaults.set(isLogged, forKey: AuthenSetting.isLogged.key)
    }
    
    func saveUserId(userId: String){
        defaults.set(userId, forKey: AuthenSetting.userId.key)
    }
    
    func logInStatus() -> Bool{
        if !isKeyPresentInUserDefaults(key: AuthenSetting.isLogged.key){
            return false
        }
        
        let status = defaults.bool(forKey: AuthenSetting.isLogged.key)
        return status
    }
    
    func getUserId() -> String?{
        if !isKeyPresentInUserDefaults(key: AuthenSetting.userId.key){
            return nil
        }
        
        let userId = defaults.string(forKey: AuthenSetting.userId.key)
        return userId
    }
}
