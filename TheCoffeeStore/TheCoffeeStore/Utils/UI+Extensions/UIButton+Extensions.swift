//
//  UIButton+Extensions.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 22/09/2022.
//

import Foundation
import UIKit


extension UIButton{
    
    func createButton(withButtonAttrs attrs: TCAButtonAttributes){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.tintColor = attrs.tintColor ?? .gray
        self.contentHorizontalAlignment = .fill
        self.contentVerticalAlignment = .fill
        self.imageView?.contentMode = .scaleAspectFit
        if let image = attrs.image {
            self.setImage(image, for: .normal)
        }
        
        if let title = attrs.text, let textColor = attrs.textColor  {
            self.setTitle(title, for: .normal)
            self.setTitleColor(textColor, for: .normal)
        }
        self.titleLabel?.font = .loadOpenSansFont(withType: .medium, ofSize: .regularSize)
    }
    
    func animateInOut(){
        UIView.animate(withDuration: CGFloat.kTimingAnimation, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: [.curveEaseIn], animations: {
            self.transform = CGAffineTransform.identity.scaledBy(x: 0.7, y: 0.7)
            self.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: [.curveEaseInOut], animations: {
                self.transform = .identity
                self.alpha = 1
            }, completion: nil)
        })
    }
    
}
