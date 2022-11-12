//
//  FirebaseManager+Menu.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 06/10/2022.
//

import Foundation

extension FirebaseManager{
    // MARK: - CREATE
    func createMenu(menu: String, completion: @escaping((Bool, String?) -> Void)){
        let menu = ["title": menu] as [String: Any]
        
        let uuid = NSUUID().uuidString
        db.collection(FirebaseDocument.menus.document).document(uuid).setData(menu) { err in
            if let err = err{
                completion(false, err.localizedDescription)
                return
            }else{
                completion(true, nil)
            }
        }
    }
    
    // MARK: - FETCH
    func getMenus(completion: @escaping(([Menu]?, String?) -> Void)){
        db.collection(FirebaseDocument.menus.document).getDocuments { querySnapshot, err in
            var menus: [Menu]?
            if let err = err{
                print("Error fetching menus")
                completion(nil, err.localizedDescription)
            }else{
                menus = [Menu]()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let id = document.documentID
                    if let title = data["title"] as? String{
                        let category = Menu(title: title, id: id)
                        menus!.append(category)
                    }
                }
                completion(menus, nil)
            }
        }
    }
}
