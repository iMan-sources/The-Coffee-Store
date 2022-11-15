//
//  FirebaseManager+Adjust.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 13/10/2022.
//

import Foundation

enum AdjustType: CaseIterable{
    case milk, cream, coffee
    var name: String{
        switch self {
        case .milk:
            return "milk"
        case .cream:
            return "cream"
        case .coffee:
            return "coffee"
        }
    }
    
    var adjustName: String{
        switch self {
        case .milk:
            return "milk_adjust"
        case .cream:
            return "cream_adjust"
        case .coffee:
            return "coffee_adjust"
        }
    }
    
    var subName: String{
        switch self {
        case .milk:
            return "Sữa"
        case .cream:
            return "Kem"
        case .coffee:
            return "Vị cà phê"
        }
    }
}

enum AdjustMilkType{
    case freshMilk, soyaMilk, lessFatMilk, creamMilk
    var id: String{
        switch self {
        case .freshMilk:
            return "D2F04ED1-B06E-4638-A048-FDD338FC0E60"
        case .soyaMilk:
            return "ADFF76EC-DA3D-4193-87C3-6C9F14311DEA"
        case .lessFatMilk:
            return "AB9D2F35-DAF5-4455-9D89-6DFEA3C28F77"
        case .creamMilk:
            return "3FCA614C-A9CC-4A3D-A2C2-70F793321365"
        }
    }
}

enum AdjustCoffeeType{
    case espresso, decaf
    var id: String{
        switch self {
        case .espresso:
            return "2D020150-2310-46CE-8BC3-BDB43805C122"
        case .decaf:
            return "069CEE21-EAB8-46A2-B052-8C9A920D0E7A"
        }
    }
}

enum AdjustCreamType{
    case standard, non
    var id: String{
        switch self {
        case .standard:
            return "61F234ED-1E90-4328-AF3A-6E02A953E07E"
        case .non:
            return "D407E745-4330-4F33-AB4C-883EBBB121CB"
        }
    }
}


extension FirebaseManager{
    func createAdjust(adjustType: AdjustType,adjust: Adjust, completion: @escaping((Bool, String?) -> Void)){
        let adjust = ["title": adjust.title] as [String: Any]
        
        let uuid = UUID().uuidString
        db.collection(adjustType.name).document(uuid).setData(adjust) { err in
            if let err = err{
                completion(false, err.localizedDescription)
                return
            }else{
                completion(true, nil)
            }
        }
    }
    //-----> GET DEFAULT ADJUST ID
    func getDefaultAdjustId(drinkId: String,
                            adjustType type: AdjustType,
                            completion: @escaping((String?, String?) -> Void)){
        
        db.collection(type.adjustName).whereField("drink_id", isEqualTo: drinkId).getDocuments { querySnapshot, err in
            if let err = err{
                print("Error fetching categories")
                completion(nil, err.localizedDescription)
                return
            }else{
                for document in querySnapshot!.documents{
                    let data = document.data()
                    if let drinkDefaultId = data["drink_default_adjust_id"] as? String{
                        completion(drinkDefaultId, nil)
                        return
                    }
                }
                //not find default adjust id
                completion(nil, nil)
                return
                
            }
        }
    }
    //GET DEFAULT ADJUST ID <-----
    
    
    //-----> GET ADJUSTS
    func getAdjusts(drinkDefaultId: String,
                    adjustType type: AdjustType,
                    completion: @escaping(([Adjust]?, String?) -> Void)){
        //[DEFAULT_ID: [ADJUST]]
        var adjusts = [Adjust]()
        
        self.db.collection(type.name).getDocuments { querySnapshot, err in
            if let  err = err{
                completion(nil, err.localizedDescription)
            }else{
                for document in querySnapshot!.documents{
                    let data = document.data()
                    let id = document.documentID
                    if let title = data["title"] as? String,
                        let type =  data["type"] as? String{
                        let adjust = id == drinkDefaultId ? Adjust(id: id,
                                                                   title: title,
                                                                   type: type,
                                                                   isDefault: true) : Adjust(id: id,title: title, type: type)
                        adjusts.append(adjust)
                    }
                }
                completion(adjusts, nil)
            }
        }
        //GET ADJUSTS <-----
    }
    
    func fetchSelectedAdjust(adjustId: String,
                     adjustType type: AdjustType,
                     completion: @escaping((Adjust?, String?) -> Void)){
        
        self.db.collection(type.name).document(adjustId).getDocument { querySnapshot, err in
            if let err = err{
                completion(nil, err.localizedDescription)
            }else{
                let data = querySnapshot!.data()!
                let id = querySnapshot!.documentID
                if let title = data["title"] as? String,
                   let type =  data["type"] as? String{
                    let adjust = Adjust(title: title, type: type)
                    completion(adjust, nil)
                }
            }
        }
    }
}
