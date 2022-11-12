//
//  UIResponder+Extensions.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 24/09/2022.
//

import UIKit

extension UIResponder {
    private struct Static {
        static weak var responder: UIResponder?
    }
    
    static func currentFirst() -> UIResponder?{
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(_trap), to: nil, from: nil, for: nil)
        return Static.responder
    }
    
    @objc private func _trap(){
        Static.responder = self
    }
}
