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
           let status = data["status"] as? Int,
            let shippingAddressId = data["shipping_address_id"] as? String{
            
            var bill: Bill?
            if shippingAddressId.isEmpty{
                bill = Bill(id: id,userId: userId, time: time, price: price, branch_id: branchId ,isShipped: isShipped, time_received: timeReceived, status: status)
            }else{
                bill = Bill(id: id, userId: userId, time: time, price: price,shippingAddress_id: shippingAddressId ,isShipped: isShipped ,time_received: timeReceived, status: status)
            }
            return bill
        }
        
        return nil
    }
    
    private func defineStartReceiveOrder() -> Int64{
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let timeStart = "\(day)-\(month)-\(year) 08:00"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let startDate = dateFormatter.date(from: timeStart)
        let miliSeconds: Int64 = Int64((startDate!.timeIntervalSince1970 * 1000.0).rounded())
        return miliSeconds
    }
    
    func fetchBills(completion: @escaping(([Bill]?, String?) -> Void)){
        /*
         Only fetch bill not finshed & time is greater than open hour (08:00)
         
         */
        db.collection(FirebaseDocument.bills.document).whereField("time", isGreaterThanOrEqualTo: defineStartReceiveOrder()).getDocuments { [weak self]documentSnapshot, err in
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
        db.collection(FirebaseDocument.bills.document).whereField("time", isGreaterThanOrEqualTo: defineStartReceiveOrder()).addSnapshotListener { [weak self]documentSnapshot, err in
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
    
    /* status
     0: not confirmed
     1: confirmed & prepared
     3: finished
     4: canceled
     */
    
    func updateStatusBill(billId: String, completion: @escaping((Int?, String?) -> Void)){
        db.collection(FirebaseDocument.bills.document).document(billId).addSnapshotListener { querySnapshot, error in
            if let error = error{
                completion(nil, error.localizedDescription)
            }else{
                guard let data = querySnapshot?.data() else {return}
                if let status = data["status"] as? Int{
                    completion(status, nil)
                }
            }
        }
    }
    
    func changeStatusBill(billId: String,
                          statusCode code: Int,
                          completion: @escaping((String?) -> Void)){
        db.collection(FirebaseDocument.bills.document).document(billId).updateData([
            "status": code
        ]){ err in
            if let err = err{
                completion(err.localizedDescription)
            }else{
                completion(nil)
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
