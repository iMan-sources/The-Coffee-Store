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
    
    private func convertDataToItem(billId: String,
                                   itemId: String,
                                   data: [String: Any]) -> Item?{
        if let coffeeId = data["coffee_id"] as? String,
           let creamId = data["cream_id"] as? String,
           let drink_id = data["drink_id"] as? String,
           let milkId = data["milk_id"] as? String,
           let size = data["size"] as? String{
            let item = Item(id: itemId, billId: billId,size: size, drinkId: drink_id, creamId: creamId, milkId: milkId, coffeeId: coffeeId)
            return item
        }
        return nil
    }
    
    func fetchItems(billId: String, completion: @escaping(([Item]?, String?) -> Void)){
        db.collection(FirebaseDocument.item_oder.document).whereField("bill_id", isEqualTo: billId).getDocuments { [weak self] querySnapshot, err in
            guard let self = self else {return}
            if let err = err{
                completion(nil, err.localizedDescription)
            }else{
                var items = [Item]()
                for document in querySnapshot!.documents{
                    let data = document.data()
                    let id = document.documentID
                    if let item = self.convertDataToItem(billId: billId, itemId: id, data: data){
                        items.append(item)
                    }
                }
                completion(items, nil)
            }
        }
    }
}
