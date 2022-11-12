//
//  UIViewController+Extensions.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 22/09/2022.
//

import Foundation
import UIKit

extension UIViewController{
    
    //-----> PRESENT LIST POPUP PICKER
    func presentPopUpPickerOnMainThread(titles: [String],
                                        header: String,
                                        completionHandler: @escaping((TCAPopUpPickerViewController)-> Void)){
        let popUpVC = TCAPopUpPickerViewController(titles: titles, header: header)
        DispatchQueue.main.async {
            popUpVC.modalTransitionStyle = .crossDissolve
            popUpVC.modalPresentationStyle = .overFullScreen
            self.present(popUpVC, animated: true) {
                completionHandler(popUpVC)
            }
        }
    }
    //PRESENT LIST POPUP PICKER <-----

    //-----> PRESENT ERROR MESSAGE
    func presentErrorMessageOnMainThread(error: String,
                                         completionHandler: ((TCAPopUpErrorMessageViewController)-> Void)?=nil){
        let errorPopUpVC = TCAPopUpErrorMessageViewController(error: error)
        DispatchQueue.main.async {
            errorPopUpVC.modalTransitionStyle = .crossDissolve
            errorPopUpVC.modalPresentationStyle = .overFullScreen
            self.present(errorPopUpVC, animated: true) {
                completionHandler?(errorPopUpVC)
            }
        }
    }
    //PRESENT ERROR MESSAGE <-----

    
    func bringToView(from childVC: UIViewController, to containerView: UIView){
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    


    // MARK: - Action
}
