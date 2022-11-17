//
//  TCAOrderDetailPreparedViewControlelr.swift
//  TheCoffeeStore
//
//  Created by Le Viet Anh on 16/11/2022.
//

import UIKit
import RxSwift
import RxCocoa

class TCAOrderDetailPreparedViewController: TCAOrderDetailNotConfirmedViewController {
    
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
        let titleAttrs = TCATitleLabelAttrs(text: "Chuẩn bị đơn hàng", color: .black)
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
        let orderDetailShippedVC = TCAOrderDetailShippedViewController(bill: orderDetailViewModel.bill,
                                                                         items: orderDetailViewModel.items,
                                                                         drinks: orderDetailViewModel.drinks,
                                                                         billStatus: .shipped)
        self.navigationController?.pushViewController(orderDetailShippedVC, animated: true)
    }
    //MARK: - Helper
    override func acceptButtonTapped() {
        self.presentErrorMessageOnMainThread(error: "Đã chuẩn bị xong đơn hàng") { popUpViewController in
            popUpViewController.delegate = self
        }
    }
    
    override func didConfirmButtonTapped() {
        self.orderDetailViewModel.changeStatusBill(statusCode: StatusBill.shipped.statusCode)
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

