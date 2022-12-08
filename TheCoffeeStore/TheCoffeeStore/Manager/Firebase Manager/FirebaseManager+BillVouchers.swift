//
//  FirebaseManager+BillVouchers.swift
//  TheCoffeeApp
//
//  Created by Le Viet Anh on 16/11/2022.
//

import UIKit
extension FirebaseManager{
    func createBillVouchers(billVoucher: BillVoucher,
                            completion: @escaping((String?) -> Void)){
        let bill = ["user_id": billVoucher.userId,
                    "bill_id": billVoucher.billId,
                    "voucher_id": billVoucher.voucherId] as [String: Any]
        let uuid = UUID().uuidString
        db.collection(FirebaseDocument.bill_vouchers_used.document).document(uuid).setData(bill) { err in
            if let err = err{
                completion(err.localizedDescription)
                return
            }else{
                completion(nil)
            }
        }
    }
    
    func deleteBillVouchers(billVoucher: BillVoucher, completion: @escaping((String?) -> Void)){
        if let id = billVoucher.id{
            db.collection(FirebaseDocument.bill_vouchers_used.document).document(id).delete { err in
                if let err = err{
                    completion(err.localizedDescription)
                }else{
                    completion(nil)
                }
            }
        }
    }
    
    func searchBillVouchers(bill: Bill, completion: @escaping(([BillVoucher]?, String?) -> Void)){
        if let billId = bill.id{
            db.collection(FirebaseDocument.bill_vouchers_used.document)
                .whereField("bill_id", isEqualTo: billId)
                .whereField("user_id", isEqualTo: bill.userId).getDocuments { querySnapshot, err in
                    if let err = err{
                        completion(nil,err.localizedDescription)
                    }else{
                        var billVouchers: [BillVoucher] = [BillVoucher]()
                        for document in querySnapshot!.documents{
                            let data = document.data()
                            let id = document.documentID
                            if let voucherId = document["voucher_id"] as? String{
                                let billVoucher = BillVoucher(id: id, userId: bill.userId, billId: billId, voucherId: voucherId)
                                billVouchers.append(billVoucher)
                            }
                        }
                        
                        completion(billVouchers, nil)
                        
                    }
                }
        }
    }
    
    
}
