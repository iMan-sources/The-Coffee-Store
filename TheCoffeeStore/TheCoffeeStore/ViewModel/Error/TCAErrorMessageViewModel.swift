//
//  TCAErrorMessageViewModel.swift
//  TheCoffeeApp
//
//  Created by Le Viet Anh on 03/11/2022.
//

import Foundation

class TCAErrorMessageViewModel{
    
    private var errorMessage: String = ""
    
    init(error: String){
        errorMessage = error
    }
    
    func showError() -> String{
        return errorMessage
    }
}
