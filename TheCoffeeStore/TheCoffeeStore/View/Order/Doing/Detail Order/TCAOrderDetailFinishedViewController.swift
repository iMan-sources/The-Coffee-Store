//
//  TCAOrderDetailFinishedViewController.swift
//  TheCoffeeStore
//
//  Created by Le Viet Anh on 16/11/2022.
//

import UIKit
import RxSwift
import RxCocoa

class TCAOrderDetailFinishedViewController: TCAOrderDetailNotConfirmedViewController {
    
    //MARK: - Subviews
    
    //MARK: - Properties
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func configCustomNavigationBar() {
        let rightButtonAttrs = TCAButtonAttributes(text: nil,
                                                   textColor: nil,
                                                   font: nil,
                                                   size: nil,
                                                   color: nil,
                                                   image: nil,
                                                   isHidden: false)
        
        let leftButtonAttrs = TCAButtonAttributes(text: nil,
                                                  textColor: nil,
                                                  font: nil,
                                                  size: nil,
                                                  color: nil,
                                                  image: Image.exit,
                                                  isHidden: false,
                                                  tintColor: .darkGray)
        let titleAttrs = TCATitleLabelAttrs(text: "Giao hàng", color: .black)
        self.customNav = TCACustomNavigationBar(leftButtonAttrs: leftButtonAttrs,
                                                rightButtonAttrs: rightButtonAttrs,
                                                titleAttrs: titleAttrs)
        
        self.customNav.delegate = self
    }
    
    //MARK: - Action
    override func didLeftButtonItemTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - API
    private func pushToOrderFinishedViewController(){
        
        
    }
    //MARK: - Helper
    override func acceptButtonTapped() {
        self.presentErrorMessageOnMainThread(error: "Giao hàng thành công") { popUpViewController in
            popUpViewController.delegate = self
        }
    }
    
    override func didConfirmButtonTapped() {
        self.orderDetailViewModel.changeStatusBill(statusCode: StatusBill.finished.statusCode)
    }
    
    override func pushToNextStatusPhase() {
        self.orderDetailViewModel.updatedStatusBill.subscribe(onNext: { [weak self] isUpdated in
            guard let self = self else {return}
            if isUpdated{
                self.pushToOrderFinishedViewController()
            }
        }).disposed(by: disposeBag)
        
    }
    
}



