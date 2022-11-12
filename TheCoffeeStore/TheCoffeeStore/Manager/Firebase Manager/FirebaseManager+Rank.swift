//
//  FirebaseManager+Rank.swift
//  TheCoffeeApp
//
//  Created by Le Viet Anh on 05/11/2022.
//

import Foundation


extension FirebaseManager{
    func createRank(rank: Rank, completion: @escaping((Bool, String?) -> Void)){
        let tempVoucher = ["name": rank.name,
                           "point_condition": rank.pointCondition] as [String: Any]
        let uuid = UUID().uuidString
        db.collection("ranks").document(uuid).setData(tempVoucher) { err in
            if let err = err{
                completion(false, err.localizedDescription)
                return
            }else{
                completion(true, nil)
            }
        }
    }
    
    func fetchVoucherByRankId(rankId: String,completion: @escaping(([RankVoucher]?, String?) -> Void)){
        db.collection(FirebaseDocument.rank_voucher.document).whereField("rank_id", isEqualTo: rankId).getDocuments { querySnapshot, err in
            if let err = err{
                completion(nil, err.localizedDescription)
            }else{
                var rankVouchers = [RankVoucher]()
                for document in querySnapshot!.documents{
                    let id = document.documentID
                    let data = document.data()
                    
                    if let rankId = data["rank_id"] as? String, let voucherId = data["voucher_id"] as? String{
                        let rankVoucher = RankVoucher(rankId: rankId, voucherId: voucherId)
                        rankVouchers.append(rankVoucher)
                    }
                }
                completion(rankVouchers, nil)
                
            }
        }
    }
    
    func getRankById(rankId: String, completion: @escaping((Rank?, String?) ->Void)){
        db.collection(FirebaseDocument.ranks.document).document(rankId).getDocument { querySnapshot, err in
            if let err = err {
                completion(nil, err.localizedDescription)
            }else{
                let data = querySnapshot!.data()!
                let rankId = querySnapshot?.documentID
                
                if let rankId = rankId,
                   let name = data["name"] as? String,
                   let point = data["point_condition"] as? Int{
                    let rank = Rank(id: rankId, name: name, pointCondition: point)
                    completion(rank, nil)
                }
            }
        }
    }
}
