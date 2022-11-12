//
//  FirebaseStorage.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 05/10/2022.
//

import Foundation
import FirebaseCore
import FirebaseStorage
import UIKit

enum FirebaseStorageRef{
    case drinks
    
    var ref: String{
        switch self {
        case .drinks:
            return "Drinks"
        }
    }
}

class FirebaseStore {
    
    // MARK: - Subviews
    
    // MARK: - Properties
    let storageRef = Storage.storage().reference()
    static let shared = FirebaseStore()
    
    // MARK: - Lifecycle
    init(){
        
    }
    // MARK: - Navigation

    // MARK: - Action
    
    // MARK: - Helper
}

// MARK: - Drinks
extension FirebaseStore{
    func uploadDrinkImage(category: String, type: String ,image: UIImage, completion: @escaping((String?) -> Void)){
        let uuid = UUID().uuidString

        guard let imageData = image.pngData() else {
            #warning("handle pngData error message")
            completion(nil)
            return
        }
        
        let imagesRef = storageRef.child("images/\(category)/\(type)/\(uuid).png")
        
        
        imagesRef.putData(imageData, metadata: nil) { _, error in
            if error != nil{
                completion(nil)
                return
            }
            completion("images/\(category)/\(type)/\(uuid).png")
        }
    }
    
    func downloadCategoryImageURL(category: Category, completion: @escaping((URL?, String?) -> Void)){
        let imageRef = storageRef.child(category.imagePath)
        imageRef.downloadURL { url, error in
            if let error = error {
                completion(nil, error.localizedDescription)
            } else {
                completion(url, nil)
            }
        }
    }
    
    func downloadEventImageURL(event: Event, completion: @escaping((URL?, String?) -> Void)){
        let imageRef = storageRef.child(event.imagePath)
        imageRef.downloadURL { url, error in
            if let error = error {
                completion(nil, error.localizedDescription)
            } else {
                completion(url, nil)
            }
        }
    }
    
    func downloadImageURL(imagePath: String,completion: @escaping((URL?, String?) -> Void)){
        let imageRef = storageRef.child(imagePath)
        imageRef.downloadURL { url, error in
            if let error = error {
                completion(nil, error.localizedDescription)
            } else {
                completion(url, nil)
            }
        }
    }
}

