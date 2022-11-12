//
//  FirebaseManager+Type.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 08/10/2022.
//

import Foundation
enum BrewSpecies{
    case coldBrew, icedCoffee
    var folderName: String{
        switch self {
        case .coldBrew:
            return "cold_brew&nitro"
        case .icedCoffee:
            return "iced_coffee"
        }
    }
    
    var specyId: String{
        switch self {
        case .coldBrew:
            return "00DA5DC0-A970-4267-83D5-64E982F96F50"
        case .icedCoffee:
            return "4F3929E6-E6DA-4E1D-9145-2414362399BA"
        }
    }
}


enum FrappuccinoBlendedSpecies{
    case blendedJuice, blendedCoffee, blendedCream
    var folderName: String{
        switch self {
        case .blendedJuice:
            return "blended_juice"
        case .blendedCoffee:
            return "blended_coffee"
        case .blendedCream:
            return "blended_cream"
        }
    }
    
    var specyId: String{
        switch self {
        case .blendedJuice:
            return "17CD9637-5F81-404A-821F-4BAEEC829427"
        case .blendedCoffee:
            return "38B9E9EB-FDBD-4002-AB27-E33BB725DCD2"
        case .blendedCream:
            return "F1780EEC-BC45-41C8-B084-29C61EE5983F"
        }
    }
}

enum EspressoSpecies{
    case espressoHot, espressoCold
    
    var folderName: String{
        switch self {
        case .espressoHot:
            return "espresso_hot"
        case .espressoCold:
            return "espresso_cold"
        }
    }
    
    var specyId: String{
        switch self {

        case .espressoHot:
            return "E3807F7D-60D5-4758-A417-F6A9D19DD6E8"
        case .espressoCold:
            return "A4A0C1D6-AF7A-42E3-81FF-4938F84C74BE"
        }
    }
}

enum OtherSpecies{
    case hot, cold
    
    var folderName: String{
        switch self {
        case .hot:
            return "hot"
        case .cold:
            return "cold"
        }
    }
    
    var specyId: String{
        switch self {
        case .hot:
            return "D8A27880-4A71-4F88-A780-DEF02F47E378"
        case .cold:
            return "BF60AC99-5A57-45BE-B3B5-A33E9A8CF7DE"
        }
    }
}

enum CollectionType{
    case frappucinno, brewed, espresso, other
    var name: String{
        switch self {
        case .frappucinno:
            return "frappucinno_collection"
        case .brewed:
            return "brewed_collection"
        case .espresso:
            return "espresso_collection"
        case .other:
            return "other_collection"
        }
    }
    
    var imageFolderName: String{
        switch self {
        case .frappucinno:
            return "frappuccino_blended_beverage"
        case .brewed:
            return "brewed_coffee"
        case .espresso:
            return "espresso&coffee"
        case .other:
            return "other"
        }
    }
}


extension FirebaseManager{
    func createSpecy(specy: Specy, completion: @escaping((Bool, String?) -> Void)){
        let specy = ["title": specy.title,
                     "category_id": specy.categoryId] as [String: Any]
        
        
        let uuid = UUID().uuidString
        db.collection("species").document(uuid).setData(specy) { err in
            if let err = err{
                completion(false, err.localizedDescription)
                return
            }else{
                completion(true, nil)
            }
        }
    }
    
    func getSpeciesByCategoryId(categoryId: String,completion: @escaping(([Specy]?, String?) -> Void)){
        db.collection(FirebaseDocument.species.document).whereField("category_id", isEqualTo: categoryId).getDocuments { querySnapshot, err in
            if let err = err{
                completion(nil, err.localizedDescription)
            }else{
                var species = [Specy]()
                for document in querySnapshot!.documents{
                    let data = document.data()
                    let id = document.documentID
                    if let title = data["title"] as? String, let categoryId = data["category_id"] as? String{
                        let specy = Specy(id: id,title: title, categoryId: categoryId)
                        species.append(specy)
                    }
                }
                completion(species, nil)
            }
        }
    }
}
