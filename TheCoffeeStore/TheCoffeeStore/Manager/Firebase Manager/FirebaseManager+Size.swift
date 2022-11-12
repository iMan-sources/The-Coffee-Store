//
//  FirebaseManager+Size.swift
//  TheCoffeeApp
//
//  Created by Le Viet Anh on 25/10/2022.
//

import Foundation

extension FirebaseManager{
    func createSize(size: Size, completion: @escaping((Bool, String?) -> Void)){
        let size = ["name": size.name, "rate": size.rate] as [String: Any]
        let uuid = UUID().uuidString
        db.collection("sizes").document(uuid).setData(size) { err in
            if let err = err{
                completion(false, err.localizedDescription)
                return
            }else{
                completion(true, nil)
            }
        }
    }
    
    func fetchSize(completion: @escaping(([Size]?, String?) -> Void)){
        db.collection(FirebaseDocument.sizes.document).getDocuments { querySnapshot, err in
            if let err = err{
                completion(nil, err.localizedDescription)
            }else{
                var sizes = [Size]()
                for document in querySnapshot!.documents{
                    let data = document.data()
                    let id = document.documentID
                    if let name = data["name"] as? String,
                       let isDefault = data["isDefault"] as? Bool,
                        let rate = data["rate"] as? Double{
                        let size = Size(name: name, rate: rate, isDefault: isDefault)
                        sizes.append(size)
                    }
                }
                completion(sizes, nil)
            }
        }
    }
}
