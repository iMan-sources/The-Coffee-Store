//
//  FirebaseManager+Bill.swift
//  TheCoffeeApp
//
//  Created by Le Viet Anh on 12/11/2022.
//

import Foundation

extension FirebaseManager{
    func createBill(bill: Bill, completion: @escaping((String?, String?) -> Void)){
        let bill = ["user_id": bill.userId,
                    "price": bill.price,
                    "time": bill.time,
                    "shipping_address_id": bill.shippingAddress_id ?? "",
                    "branch_id": bill.branch_id ?? "",
                    "is_shipped": bill.isShipped] as [String: Any]
        let uuid = UUID().uuidString
        db.collection(FirebaseDocument.bills.document).document(uuid).setData(bill) { err in
            if let err = err{
                completion(nil, err.localizedDescription)
                return
            }else{
                completion(uuid, nil)
            }
        }
    }
    
    private func convertDataToBillModel(withId id: String, data: [String: Any]) -> Bill?{
        if let branchId = data["branch_id"] as? String,
            let timeReceived = data["time_received"] as? Int,
            let time = data["time"] as? Int,
            let userId = data["user_id"] as? String,
            let isShipped = data["is_shipped"] as? Bool,
            let price = data["price"] as? Double,
            let shippingAddressId = data["shipping_address_id"] as? String{
            
            var bill: Bill?
            if shippingAddressId.isEmpty{
                bill = Bill(id: id,userId: userId, time: time, price: price, branch_id: branchId ,isShipped: isShipped, time_received: timeReceived)
            }else{
                bill = Bill(id: id, userId: userId, time: time, price: price,shippingAddress_id: shippingAddressId ,isShipped: isShipped ,time_received: timeReceived)
            }
            return bill
        }
        
        return nil
    }
    
    func fetchBills(completion: @escaping(([Bill]?, String?) -> Void)){
        db.collection(FirebaseDocument.bills.document).getDocuments { [weak self]documentSnapshot, err in
            guard let self = self else {return}
            guard let snapshot = documentSnapshot else {
                completion(nil, err?.localizedDescription)
                return
            }
            var bills = [Bill]()
            for document in snapshot.documents{
                let data = document.data()
                let id = document.documentID
                if let bill = self.convertDataToBillModel(withId: id, data: data){
                    bills.append(bill)
                }
            }
            bills = bills.sorted(by: {$0.time > $1.time})
            completion(bills, nil)
        }
    }
    
    func updateBill(completion: @escaping((Bill?, String?) -> Void)){
        db.collection(FirebaseDocument.bills.document).addSnapshotListener { [weak self]documentSnapshot, err in
            guard let self = self else {return}
            guard let snapshot = documentSnapshot else {
                completion(nil, err?.localizedDescription)
                return
            }
            
            snapshot.documentChanges.forEach({ diff in
                if diff.type == .added{
                    let document = diff.document
                    let id = document.documentID
                    let data = document.data()
                    let bill = self.convertDataToBillModel(withId: id, data: data)
                    completion(bill, nil)
                }
            })
        }
    }
    
    
    
    
    //
    //
    //    func fetchUserPoint(userId: String,
    //                        completion: @escaping((UserPoint?, String?) -> Void)){
    //        db.collection(FirebaseDocument.user_points.document).whereField("user_id", isEqualTo: userId).getDocuments { querySnapshot, err in
    //            if let err = err{
    //                completion(nil, err.localizedDescription)
    //            }else{
    //                var userPoints = [UserPoint]()
    //                for document in querySnapshot!.documents{
    //                    let id = document.documentID
    //                    let data = document.data()
    //
    //                    if let rankId = data["rank_id"] as? String,
    //                       let userId = data["user_id"] as? String,
    //                       let point = data["point"] as? Int{
    //                        let userPoint = UserPoint(id: id,
    //                                                  rankId: rankId,
    //                                                  userId: userId,
    //                                                  currentPoint: point)
    //                        userPoints.append(userPoint)
    //                    }
    //                }
    //                if let userPoint = userPoints.first{
    //                    completion(userPoint, nil)
    //                }
    //
    //            }
    //        }
    //    }
}
