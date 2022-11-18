//
//  Bill.swift
//  TheCoffeeApp
//
//  Created by Le Viet Anh on 11/11/2022.
//

import Foundation

struct Bill: Equatable, Hashable{
    public private(set) var id: String? = ""
    public private(set) var userId: String
    public private(set) var time: Int
    public private(set) var price: Double
    public private(set) var shippingAddress_id: String?
    public private(set) var branch_id: String?
    public private(set) var isShipped: Bool
    public private(set) var time_received: Int
    public private(set) var status: Int
}
