//
//  FirebaseManager+Auth.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 05/10/2022.
//

import UIKit

// MARK: - Authen
extension FirebaseManager{
    func login(email: String, password: String, completion: @escaping( (Bool, String?) -> Void)){
        auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            
            if let authError = error{
                completion(false, authError.localizedDescription)
                return
            }
            completion(true, nil)
        }
    }
    
    func signup(email: String, password: String, completion: @escaping((String?, String?) -> Void)){
        auth.createUser(withEmail: email, password: password){[weak self] authResult, error in
            if let authError = error{
                completion(nil, authError.localizedDescription)
                return
            }
            if let userId = authResult?.user.uid{
                completion(userId, nil)
                return
            }
        }
    }
    
    
    func createUser(userId: String,
                    user: User,
                    completion: @escaping((Bool, String?) -> Void)){
        let user = [
            "appelation": user.personalInfor.appelation,
            "first_name": user.personalInfor.firstName,
            "last_name": user.personalInfor.lastName,
            "province": user.address.province,
            "district": user.address.district,
            "ward": user.address.ward,
            "address_detail": user.address.addressDetail,
            "birthday_date": user.personalInfor.birthday.date,
            "birthday_month": user.personalInfor.birthday.month,
            "phoneNumber": user.personalInfor.phoneNumber,
        ] as [String : Any]
        let uuid = userId
        db.collection("users").document(uuid).setData(user) { err in
            if let err = err{
                completion(false, err.localizedDescription)
                return
            }else{
                completion(true, nil)
                return
            }
        }
    }
    
    func fetchUser(userId: String, completion: @escaping((User?, String?) -> Void)){
        db.collection(FirebaseDocument.users.document).document(userId).getDocument { document, err in
            if let err = err{
                completion(nil, err.localizedDescription)
            }else{
                if let document = document, document.exists{
                    let data = document.data()!
                    let id = document.documentID
                    if let firstName = data["first_name"] as? String,
                       let lastName = data["last_name"] as? String,
                       let birthdayDate = data["birthday_date"] as? String,
                       let birthdayMonth = data["birthday_month"] as? String,
                       let province = data["province"] as? String,
                       let address_detail = data["address_detail"] as? String,
                       let district = data["district"] as? String,
                       let ward = data["ward"] as? String,
                       let phoneNumber = data["phoneNumber"] as? String,
                       let appelation = data["appelation"] as? String{
                        
                        let address = Address(province: province, district: district, ward: ward, addressDetail: address_detail)
                        let birthDay = Birthday(month: birthdayMonth, date: birthdayDate)
                        let personalInfo = PersonalInfor(firstName: firstName,
                                                         lastName: lastName,
                                                         appelation: appelation,
                                                         phoneNumber: phoneNumber,
                                                         birthday: birthDay)
                        let user = User(id: id,personalInfor: personalInfo, address: address)
                        completion(user, nil)
                    }
                }
            }
        }
    }
}
