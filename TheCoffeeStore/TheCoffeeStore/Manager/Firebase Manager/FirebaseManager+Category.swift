//
//  FirebaseManager+Category.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 05/10/2022.
//

import Foundation

extension FirebaseManager{
    // MARK: - CREATE
    func createCategory(category: Category, completion: @escaping((Bool, String?) -> Void)){
        let category = ["title": category.title,
                        "image_path": category.imagePath,
                        "menu_id": category.menuId] as [String: Any]
        
        
        let uuid = UUID().uuidString
        db.collection("categories").document(uuid).setData(category) { err in
            if let err = err{
                completion(false, err.localizedDescription)
                return
            }else{
                completion(true, nil)
            }
        }
    }
    
    // MARK: - FETCH
    func getCategories(completion: @escaping(([Category]?, String?) -> Void)){
        db.collection(FirebaseDocument.categories.document).getDocuments { querySnapshot, err in
            var categories: [Category]?
            if let err = err{
                print("Error fetching categories")
                completion(nil, err.localizedDescription)
            }else{
                categories = [Category]()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let id = document.documentID
                    if let title = data["title"] as? String, let imagePath = data["image_path"] as? String, let menuId = data["menu_id"] as? String{
                        let category = Category(id: id,title: title, imagePath: imagePath, menuId: menuId)
                        categories!.append(category)
                    }
                }
                completion(categories, nil)
            }
        }
    }
    
    // MARK: - SEARCH
    func searchCategoryByMenuId(menuId: String, completion: @escaping(([Category]?, String?) -> Void)){
        db.collection(FirebaseDocument.categories.document).whereField("menu_id", isEqualTo: menuId).getDocuments { querySnapshot, err in
            var categories: [Category]?
            if let err = err{
                print("Error fetching categories")
                completion(nil, err.localizedDescription)
            }else{
                categories = [Category]()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let id = document.documentID
                    if let title = data["title"] as? String, let imagePath = data["image_path"] as? String, let menuId = data["menu_id"] as? String{
                        let category = Category(id:id ,title: title, imagePath: imagePath, menuId: menuId)
                        categories!.append(category)
                    }
                }
                completion(categories, nil)
            }
        }
    }
    
    func searchCategoryById(documentPath: String, completion: @escaping((Category?, String?) -> Void)){
        db.collection(FirebaseDocument.categories.document).document(documentPath).getDocument { document, err in
            if let err = err{
                completion(nil, err.localizedDescription)
                return
            }
            if let document = document, document.exists{
                let data = document.data()!
                if let title = data["title"] as? String, let imagePath = data["image_path"] as? String, let menuId = data["menu_id"] as? String{
                    let category = Category(title: title, imagePath: imagePath, menuId: menuId)
                    
                    completion(category, nil)
                }
            }
            
        }
    }
}
