//
//  FirebaseManager+Collection.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 13/10/2022.
//

import Foundation

extension FirebaseManager{
    func createCollection(collection: Collection, completion: @escaping((Bool, String?) -> Void)){
        let collection = ["title": collection.title, "category_id": collection.categoryId] as [String: Any]
        
        let uuid = UUID().uuidString
        db.collection("category_collection").document(uuid).setData(collection) { err in
            if let err = err{
                completion(false, err.localizedDescription)
                return
            }else{
                completion(true, nil)
            }
        }
    }
}
