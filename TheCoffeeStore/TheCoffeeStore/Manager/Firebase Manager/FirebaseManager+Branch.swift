//
//  FirebaseManager+Branch.swift
//  TheCoffeeApp
//
//  Created by Le Viet Anh on 30/10/2022.
//

import Foundation

extension FirebaseManager{
    func createBranch(branch: Branch, completion: @escaping((Bool, String?) -> Void)){
        let address = branch.address
        let branch = ["name": branch.name,
                      "province": address.province,
                      "district": address.district,
                      "ward": address.ward,
                      "address_detail": address.addressDetail,
                      "time_prepare": branch.timePrepare] as [String: Any]
        let uuid = UUID().uuidString
        db.collection("branches").document(uuid).setData(branch) { err in
            if let err = err{
                completion(false, err.localizedDescription)
                return
            }else{
                completion(true, nil)
            }
        }
    }
    
    func getBranch(branchId: String,completion: @escaping((Branch?, String?) -> Void)){
        db.collection(FirebaseDocument.branches.document).document(branchId).getDocument { querySnapshot, err in
            if let err = err{
                completion(nil, err.localizedDescription)
                return
            }else{
                let data = querySnapshot!.data()!
                let id = querySnapshot!.documentID
                if let name = data["name"] as? String,
                   let province = data["province"] as? String,
                   let district = data["district"] as? String,
                   let ward = data["ward"] as? String,
                   let detail = data["address_detail"] as? String,
                   let timePrepare = data["time_prepare"] as? String{
                    let address = Address(province: province, district: district, ward: ward, addressDetail: detail)
                    let branch = Branch(name: name, address: address, timePrepare: timePrepare, id: id)
                    completion(branch, nil)
                }
            }
        }
    }
    
    func fetchBranches(completion: @escaping(([Branch]?, String?) -> Void)){
        db.collection(FirebaseDocument.branches.document).getDocuments { querySnapshot, err in
            if let err = err{
                completion(nil, err.localizedDescription)
            }else{
                var branches = [Branch]()
                for document in querySnapshot!.documents{
                    let data = document.data()
                    let id = document.documentID
                    if let name = data["name"] as? String,
                       let province = data["province"] as? String,
                       let district = data["district"] as? String,
                       let ward = data["ward"] as? String,
                       let detail = data["address_detail"] as? String,
                       let timePrepare = data["time_prepare"] as? String{
                        let address = Address(province: province, district: district, ward: ward, addressDetail: detail)
                        let branch = Branch(name: name, address: address, timePrepare: timePrepare, id: id)
                        branches.append(branch)
                    }
                }
                completion(branches, nil)
            }
        }
    }
}
