//
//  FirebaseManager+AddressRecv.swift
//  TheCoffeeApp
//
//  Created by Le Viet Anh on 30/10/2022.
//

import Foundation

extension FirebaseManager{
    func createAddressRecv(addressRecv: AddressRecv, completion: @escaping((Bool, String?) -> Void)){
        let address = addressRecv.address.address
        let name = addressRecv.address.name
        let detail = addressRecv.address.address.addressDetail
        let timePrepare = addressRecv.address.timePrepare
        let id = addressRecv.userId
        let isDefault = addressRecv.isDefault
        let addressRecv = ["name": name,
                           "province": address.province,
                           "district": address.district,
                           "ward": address.ward,
                           "address_detail": detail,
                           "time_prepare": timePrepare,
                           "user_id": id, "isDefault": isDefault] as [String: Any]
        let uuid = UUID().uuidString
        db.collection("address_recv").document(uuid).setData(addressRecv) { err in
            if let err = err{
                completion(false, err.localizedDescription)
                return
            }else{
                completion(true, nil)
            }
        }
    }
    
    func getAddressRecv(addressRecv id: String, completion: @escaping((AddressRecv?, String?) -> Void)){
        db.collection(FirebaseDocument.addressRecv.document).document(id).getDocument { querySnapshot, err in
            if let err = err {
                completion(nil, err.localizedDescription)
            }else{
                let data = querySnapshot!.data()!
                let id = querySnapshot!.documentID
                var addressRecv: AddressRecv!
                if let name = data["name"] as? String,
                   let province = data["province"] as? String,
                   let district = data["district"] as? String,
                   let ward = data["ward"] as? String,
                   let userId = data["user_id"] as? String,
                   let detail = data["address_detail"] as? String,
                   let isDefault = data["isDefault"] as? Bool{
                    let address = Address(province: province, district: district, ward: ward, addressDetail: detail)
                    let branch = Branch(name: name, address: address, id: id)
                    addressRecv = AddressRecv(address: branch, userId: userId, isDefault: isDefault)
                    completion(addressRecv, nil)
                }
            }
        }
    }
    
    func fetchAddressRecv(userId id: String,completion: @escaping(([AddressRecv]?, String?) -> Void)){
        db.collection(FirebaseDocument.addressRecv.document).whereField("user_id", isEqualTo: id).getDocuments { querySnapshot, err in
            if let err = err{
                completion(nil, err.localizedDescription)
            }else{
                var addressRecves = [AddressRecv]()
                for document in querySnapshot!.documents{
                    let data = document.data()
                    let id = document.documentID
                    if let name = data["name"] as? String,
                       let province = data["province"] as? String,
                       let district = data["district"] as? String,
                       let ward = data["ward"] as? String,
                       let userId = data["user_id"] as? String,
                       let detail = data["address_detail"] as? String,
                       let isDefault = data["isDefault"] as? Bool{
                        let address = Address(province: province, district: district, ward: ward, addressDetail: detail)
                        let branch = Branch(name: name, address: address, id: id)
                        let addressRecv = AddressRecv(address: branch, userId: userId, isDefault: isDefault)
                        addressRecves.append(addressRecv)
                    }
                }
                
                completion(addressRecves, nil)
            }
        }
    }
}

