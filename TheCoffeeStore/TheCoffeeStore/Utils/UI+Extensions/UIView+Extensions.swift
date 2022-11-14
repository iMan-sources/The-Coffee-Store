//
//  UIView+Extensions.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 17/09/2022.
//

import Foundation
import UIKit

extension UIView{
    static func scaleDownBeforeBackIdentityAnim(subviews: [UIView]){
        /*
         set alpha = 0 & scale = 0.7 at first with duration = 0.3s,
         the other animation [set alpha = 1 & scale = 1] will appear after 0.1s
         anim1
         |---------------|
         anim2
         |-------------|
         */
        
        UIView.animate(withDuration: CGFloat.kTimingAnimation, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: [.curveEaseIn], animations: {
            for subview in subviews {
                subview.transform = CGAffineTransform.identity.scaledBy(x: 0.7, y: 0.7)
                subview.alpha = 0
            }
            UIView.animate(withDuration: CGFloat.kTimingAnimation + 0.2, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: [.curveEaseInOut], animations: {
                for subview in subviews {
                    subview.transform = .identity
                    subview.alpha = 1
                }
            }, completion: nil)
        })
    }
    
    static func create() -> UIView{
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
}

extension UIView {
    func addTopShadow(shadowColor : UIColor, shadowOpacity : Float, shadowRadius : Float,offset:CGSize){
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = CGFloat(shadowRadius)
        self.clipsToBounds = false
    }
    
    func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: -1, height: 2)
        self.layer.shadowRadius = 1.8
        self.layer.shadowOpacity = 0.3
    }
    
    func animateInOutView(){
        UIView.animate(withDuration: CGFloat.kTimingAnimation, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: [.curveEaseIn], animations: {
            self.transform = CGAffineTransform.identity.scaledBy(x: 0.7, y: 0.7)
            self.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: [.curveEaseInOut], animations: {
                self.transform = .identity
                self.alpha = 1
            }, completion: nil)
        })
    }
    
    func getStatusBarHeight() -> CGFloat{
        var statusBarHeight: CGFloat = 0
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        return statusBarHeight
    }
    
}
