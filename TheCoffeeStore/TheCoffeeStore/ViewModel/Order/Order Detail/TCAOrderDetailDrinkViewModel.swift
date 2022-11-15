//
//  TCAOrderDetailDrinkViewModel.swift
//  TheCoffeeStore
//
//  Created by Le Viet Anh on 15/11/2022.
//

import Foundation
import RxCocoa
import RxRelay
import RxSwift
class TCAOrderDetailDrinkViewModel {
    
    //MARK: - Subviews
    
    //MARK: - Properties
    private var drink: Drink!
    private var adjusts: [Adjust]!
    //MARK: - Life cycle
    init(drink: Drink, adjusts: [Adjust]){
        self.drink = drink
        self.adjusts = adjusts
    }
    //MARK: - Action
    
    //MARK: - API
    func getDrinkName() -> String{
        return drink.name
    }
    
    func getPrice() -> String{
        return "\(drink.price)"
    }
    //MARK: - Helper
}

extension TCAOrderDetailDrinkViewModel {
    private func setup(){
        
    }
    
    private func layout(){
        
    }
}
