//
//  FirebaseManager+UserPoint.swift
//  TheCoffeeApp
//
//  Created by Le Viet Anh on 09/11/2022.
//

import Foundation

extension FirebaseManager{
    func createUserPoint(userPoint: UserPoint, completion: @escaping((Bool, String?) -> Void)){
        let tempVoucher = ["rank_id": userPoint.rankId,
                           "user_id": userPoint.userId,
                           "point": userPoint.currentPoint] as [String: Any]
        let uuid = UUID().uuidString
        db.collection("user_points").document(uuid).setData(tempVoucher) { err in
            if let err = err{
                completion(false, err.localizedDescription)
                return
            }else{
                completion(true, nil)
            }
        }
    }
    
    
    func fetchUserPoint(userId: String,
                        completion: @escaping((UserPoint?, String?) -> Void)){
        db.collection(FirebaseDocument.user_points.document).whereField("user_id", isEqualTo: userId).getDocuments { querySnapshot, err in
            if let err = err{
                completion(nil, err.localizedDescription)
            }else{
                var userPoints = [UserPoint]()
                for document in querySnapshot!.documents{
                    let id = document.documentID
                    let data = document.data()
                    
                    if let rankId = data["rank_id"] as? String,
                       let userId = data["user_id"] as? String,
                       let point = data["point"] as? Int{
                        let userPoint = UserPoint(id: id,
                                                  rankId: rankId,
                                                  userId: userId,
                                                  currentPoint: point)
                        userPoints.append(userPoint)
                    }
                }
                if let userPoint = userPoints.first{
                    completion(userPoint, nil)
                }
                
            }
        }
    }
}
