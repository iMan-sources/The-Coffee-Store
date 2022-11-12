//
//  FirebaseManger+TimeDefaultReceived.swift
//  TheCoffeeApp
//
//  Created by Le Viet Anh on 29/10/2022.
//

import Foundation

extension FirebaseManager{
    func createTimeDefaultReceived(time: TimeDefaultReceived, completion: @escaping((Bool, String?) -> Void)){
        let size = ["minutes": time.minutes] as [String: Any]
        let uuid = UUID().uuidString
        db.collection("times_default_receiced").document(uuid).setData(size) { err in
            if let err = err{
                completion(false, err.localizedDescription)
                return
            }else{
                completion(true, nil)
            }
        }
    }
    
    func fetchTimeDefaultReceived(completion: @escaping(([TimeDefaultReceived]?, String?) -> Void)){
        db.collection(FirebaseDocument.timeDefaultRev.document).getDocuments { querySnapshot, err in
            if let err = err{
                completion(nil, err.localizedDescription)
            }else{
                var times = [TimeDefaultReceived]()
                for document in querySnapshot!.documents{
                    let data = document.data()
                    let id = document.documentID
                    if let minutes = data["minutes"] as? Int{
                        let time = TimeDefaultReceived(minutes: minutes)
                        times.append(time)
                    }
                }
                completion(times, nil)
            }
        }
    }
}
