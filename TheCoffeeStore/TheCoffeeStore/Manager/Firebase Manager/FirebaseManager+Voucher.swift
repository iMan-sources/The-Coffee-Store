//
//  FirebaseManager+Voucher.swift
//  TheCoffeeApp
//
//  Created by Le Viet Anh on 01/11/2022.
//

import Foundation


extension FirebaseManager{
    func createVoucher(voucher: Voucher, completion: @escaping((Bool, String?) -> Void)){
        var tempVoucher = ["title": voucher.title,
                      "expired_date": voucher.expireDate,
                           "content": voucher.content, "isActive": voucher.isActive ?? false] as [String: Any]
        if let percentage = voucher.percentage{
            tempVoucher["percentage"] = percentage
        }
        
        if let price = voucher.price{
            tempVoucher["price"] = price
        }
        let uuid = UUID().uuidString
        db.collection("vouchers").document(uuid).setData(tempVoucher) { err in
            if let err = err{
                completion(false, err.localizedDescription)
                return
            }else{
                completion(true, nil)
            }
        }
    }
        
    func fetchVouchers(completion: @escaping(([Voucher]?, String?) -> Void)){
        db.collection(FirebaseDocument.vouchers.document).getDocuments { querySnapshot, err in
            if let err = err{
                completion(nil, err.localizedDescription)
            }else{
                var vouchers = [Voucher]()
                for document in querySnapshot!.documents{
                    let data = document.data()
                    let id = document.documentID
                    if let title = data["title"] as? String,
                       let expiredDate = data["expired_date"] as? String,
                       let content = data["content"] as? String{
                        var voucher = Voucher(id: id,title: title, content: content, expireDate: expiredDate)
                        if let price = data["price"] as? Double{
                            voucher.setPrice(price: price)
                        }
                        if let percentage = data["percentage"] as? Double{
                            voucher.setPercentage(percentage: percentage)
                        }
                        vouchers.append(voucher)
                    }
                }
                completion(vouchers, nil)
            }
        }
    }
    
    func getVoucher(voucherId: String, completion: @escaping((Voucher?, String?) -> Void)){
        db.collection(FirebaseDocument.vouchers.document).document(voucherId).getDocument { querySnapshot, err in
            if let err = err{
                completion(nil, err.localizedDescription)
                return
            }else{
                let data = querySnapshot!.data()!
                let id = querySnapshot!.documentID
                if let title = data["title"] as? String,
                   let expiredDate = data["expired_date"] as? String,
                   let content = data["content"] as? String{
                    
                    var voucher = Voucher(id: id,title: title, content: content, expireDate: expiredDate)
                    if let price = data["price"] as? Double{
                        voucher.setPrice(price: price)
                    }
                    if let percentage = data["percentage"] as? Double{
                        voucher.setPercentage(percentage: percentage)
                    }
                    
                    completion(voucher, nil)
                    return
                }
                
            }
        }
    }
}
