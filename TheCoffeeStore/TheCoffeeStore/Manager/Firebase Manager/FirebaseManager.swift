//
//  FirebaseManager.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 03/10/2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
enum FirebaseDocument{
    case categories, users, menus, events, species, categoryCollection, drinks,sizes, timeDefaultRev, branches, addressRecv, vouchers, ranks, rank_voucher, user_points, bills, item_oder
    
    var document: String{
        switch self {
        case .categories:
            return "categories"
        case .users:
            return "users"
        case .menus:
            return "menus"
        case .events:
            return "events"
        case .species:
            return "species"
        case .categoryCollection:
            return "category_collection"
        case .drinks:
            return "drinks"
        case .sizes:
            return "sizes"
        case .timeDefaultRev:
            return "times_default_receiced"
        case .branches:
            return "branches"
        case .addressRecv:
            return "address_recv"
        case .vouchers:
            return "vouchers"
        case .ranks:
            return "ranks"
        case .rank_voucher:
            return "rank_voucher"
        case .user_points:
            return "user_points"
        case .bills:
            return "bills"
        case .item_oder:
            return "item_order"
        }
    }
}

class FirebaseManager{
    
    // MARK: - Subviews
    var auth = Auth.auth()
    // MARK: - Properties
    static let shared = FirebaseManager()
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    // MARK: - Lifecycle
    
    // MARK: - Navigation
    
    // MARK: - Action
    
    // MARK: - Helper

}
