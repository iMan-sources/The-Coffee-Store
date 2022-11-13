//
//  TCAOrderDoingViewModel.swift
//  TheCoffeeStore
//
//  Created by Le Viet Anh on 13/11/2022.
//

import Foundation

class TCAOrderDoingViewModel{
    
    //MARK: - Subviews
    
    //MARK: - Properties

    //MARK: - Life cycle
    init(){}
    
    //MARK: - Action
    
    //MARK: - API
    
    //MARK: - Helper
    func orderLatest(){
        FirebaseManager.shared.updateBill()
        
    }
}

extension TCAOrderDoingViewModel {
    private func setup(){
        
    }
    
    private func layout(){
        
    }
}
