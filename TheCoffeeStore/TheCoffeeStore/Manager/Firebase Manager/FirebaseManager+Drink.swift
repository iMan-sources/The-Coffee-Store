//
//  FirebaseManager+Drink.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 15/10/2022.
//

import Foundation
import UIKit

extension FirebaseManager{
    
    // MARK: - CREATE DRINK ADJUST
    //upload to firebase
    func createDrinkAdjust(adjustType type: AdjustType,
                           adjust: DrinkAdjust,
                           completion: @escaping((String?) -> Void)){
        let uuid = UUID().uuidString
        let adjust  = ["drink_id": adjust.drinkId, "drink_default_adjust_id": adjust.defaultAdjustId] as [String: Any]
        self.db.collection("\(type.name)_adjust").document(uuid).setData(adjust){ err in
            if let err = err{
                completion(err.localizedDescription)
            }else{
                completion(nil)
            }
        }
    }
    
    
    //upload multiple adjusts
    private func createMultipleDrinkAdjusts(drinkId: String,
                                            adjusts: [AdjustType: String],
                                            completion: @escaping((Bool, String?) -> Void)){
        let group = DispatchGroup()
        for type in adjusts.keys{
            if let value = adjusts[type] {
                group.enter()
                let drinkAdjust = DrinkAdjust(drinkId: drinkId, defaultAdjustId: value)
                FirebaseManager.shared.createDrinkAdjust(adjustType: type, adjust: drinkAdjust) { err in
                    if let err = err {
                        group.leave()
                        completion(false, err)
                        return
                    }else{
                        group.leave()
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            completion(true, nil)
        }
    }
    // MARK: - CREATE DRINK IMAGES
    private func uploadDrinkImages(imageReel: DrinkImage,
                                   imageBackground: DrinkImage,
                                   completion: @escaping(((reelImg: String?, backgroundImg: String?),String?) -> Void)){
        //Upload image reel image
        FirebaseStore.shared.uploadDrinkImage(category: "drinks", type: imageReel.imagePath, image: imageReel.image) { url in
            guard let imageReelUrl = url else {return}
            
            //Upload image background image
            
            FirebaseStore.shared.uploadDrinkImage(category: "drinks", type: imageBackground.imagePath, image: imageBackground.image) { url in
                guard let imageBackgroundUrl = url else {return}
                completion((imageReelUrl, imageBackgroundUrl), nil)
            }
        }
    }
    
    // MARK: - CREATE DRINK
    private func createDrink(drink: Drink,
                             completion: @escaping((Bool, String?) -> Void)){
        let data = ["name": drink.name,
                    "price": drink.price,
                    "description": drink.description,
                    "image_reel_path": drink.imageReelPath ?? "",
                    "image_background_path": drink.imageBackgroundPath ?? "",
                    "drink_species_id": drink.drinkSpeciesId,
                    "discount_id": drink.discountId] as [String: Any]
        
        self.db.collection("drinks").document(drink.id ?? "N/A").setData(data) { err in
            if let err = err{
                completion(false, err.localizedDescription)
                return
            }else{
                //Upload milk adjust
                completion(true, nil)
                return
            }
        }
    }
    
    // MARK: - CREATE DRINK + IMAGE + ADJUSTS
    func createDrinkWithImageAndAdjusts(imageReel: DrinkImage,
                                        imageBackground: DrinkImage,
                                        drink: Drink,
                                        adjusts: [AdjustType: String],
                                        completion: @escaping((Bool, String?) -> Void)){
        let drinkId = UUID().uuidString
        
        
        //upload drink image
        uploadDrinkImages(imageReel: imageReel, imageBackground: imageBackground) { [weak self]images, err in
            if let err = err {
                completion(false, err)
            }else{
                guard let self = self else {return}
                print("uploaded images successful")
                //create drink
                
                let drink = Drink(id: drinkId,
                                  name: drink.name,
                                  imageReelPath: images.reelImg,
                                  imageBackgroundPath: images.backgroundImg,
                                  description: drink.description,
                                  drinkSpeciesId: drink.drinkSpeciesId,
                                  price: drink.price,
                                  discountId: drink.discountId)
                
                self.createDrink(drink: drink) { [weak self]isSuccess, err in
                    if let err = err{
                        print("upload drink failed at Firebase drink \(err))")
                    }else{
                        //creat adjusts related to drink
                        guard let self = self else {return}
                        
                        print("uploaded drink successful")
                        self.createMultipleDrinkAdjusts(drinkId: drinkId, adjusts: adjusts) { isSuccess, err in
                            if let err = err{
                                completion(isSuccess, err)
                                return
                            }else{
                                print("uploaded adjusts successful")
                                completion(isSuccess, nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - SEARCH DRINKS BY SPECIES ID
    
    private func convertDataToDrink(drinkId: String, data: [String: Any]) -> Drink?{
        if let name = data["name"] as? String,
           let imageReelPath = data["image_reel_path"] as? String,
           let imageBackgroundPath = data["image_background_path"] as? String,
           let description = data["description"] as? String,
           let discountId = data["discount_id"] as? String,
           let price = data["price"] as? Double,
            let drinkSpeciesId = data["drink_species_id"] as? String{
            let drink = Drink(id: drinkId,
                              name: name,
                              imageReelPath: imageReelPath,
                              imageBackgroundPath: imageBackgroundPath,
                              description: description,
                              drinkSpeciesId: drinkSpeciesId,
                              price: price,
                              discountId: discountId)
            return drink
            }
        return nil
    }
    
    func fetchDrink(drinkId: String, completion: @escaping((Drink?, String?) -> Void)){
        db.collection(FirebaseDocument.drinks.document).document(drinkId).getDocument { querySnapshot, err in
            if let err = err{
                completion(nil, err.localizedDescription)
            }else{
                let drinkId = querySnapshot!.documentID
                let data = querySnapshot!.data()!
                
                guard let drink = self.convertDataToDrink(drinkId: drinkId, data: data) else {return}
                completion(drink, nil)
            }
        }
    }
    
    func fetchNameDrink(drinkId: String, completion: @escaping((String?, String?) -> Void)){
        db.collection(FirebaseDocument.drinks.document).document(drinkId).getDocument { querySnapshot, err in
            if let err = err{
                completion(nil, err.localizedDescription)
            }else{
                let drinkId = querySnapshot!.documentID
                let data = querySnapshot!.data()!
                
                if let name = data["name"] as? String{
                    completion(name, nil)
                }
            }
        }
    }
    
    
    
    func searchDrink(speciesId: String, completion: @escaping(([Drink]?, String?) -> Void)){
        db.collection(FirebaseDocument.drinks.document).whereField("drink_species_id", isEqualTo: speciesId).getDocuments { querySnapshot, err in
            var drinks: [Drink]?
            if let err = err{
                print("Error fetching categories")
                completion(nil, err.localizedDescription)
            }else{
                drinks = [Drink]()
                for document in querySnapshot!.documents{
                    let drinkId = document.documentID
                    let data = document.data()
                    if let name = data["name"] as? String,
                       let imageReelPath = data["image_reel_path"] as? String,
                       let imageBackgroundPath = data["image_background_path"] as? String,
                       let description = data["description"] as? String,
                       let discountId = data["discount_id"] as? String,
                       let price = data["price"] as? Double,
                       let drinkSpeciesId = data["drink_species_id"] as? String{
                        
                        let drink = Drink(id: drinkId,
                                          name: name,
                                          imageReelPath: imageReelPath,
                                          imageBackgroundPath: imageBackgroundPath,
                                          description: description,
                                          drinkSpeciesId: drinkSpeciesId,
                                          price: price,
                                          discountId: discountId)
                        
                        drinks?.append(drink)
                    }
                }
                completion(drinks, nil)
            }
        }
    }
}
