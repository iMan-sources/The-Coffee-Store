//
//  FirebaseManager+Item.swift
//  TheCoffeeApp
//
//  Created by Le Viet Anh on 12/11/2022.
//

import Foundation

extension FirebaseManager{
    func createItem(item: Item, completion: @escaping((Bool, String?) -> Void)){
        let itemOrder = ["bill_id": item.billId,
                         "size": item.size,
                         "drink_id": item.drinkId,
                         "cream_id": item.creamId ?? "",
                         "milk_id": item.milkId ?? "",
                         "coffee_id": item.coffeeId ?? ""] as [String: Any]
        let uuid = UUID().uuidString
        db.collection(FirebaseDocument.item_oder.document).document(uuid).setData(itemOrder) { err in
            if let err = err{
                completion(false, err.localizedDescription)
                return
            }else{
                completion(true, nil)
            }
        }
    }
}
