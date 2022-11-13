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
    
    func updateBill(){
        db.collection(FirebaseDocument.bills.document).addSnapshotListener { documentSnapshot, err in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(err!)")
                return
            }
            for document in document.documents{
                print(document.documentID)
                print(document.data())
            }
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
