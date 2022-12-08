//
//  TCAOrderDetailFinishedViewController.swift
//  TheCoffeeStore
//
//  Created by Le Viet Anh on 16/11/2022.
//

import UIKit
import RxSwift
import RxCocoa

class TCAOrderDetailShippedViewController: TCAOrderDetailNotConfirmedViewController {
    
    //MARK: - Subviews
    
    //MARK: - Properties
    private var userPointViewModel: TCAUserPointViewModel!
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserPointViewModel()
        bindingUserPointViewModel()

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
        let orderDetailFinishedVC = TCAOrderDetailFinishedViewController()
        self.navigationController?.pushViewController(orderDetailFinishedVC, animated: true)
        
    }
    //MARK: - Helper
    override func acceptButtonTapped() {
        self.presentErrorMessageOnMainThread(error: "Đồng ý giao hàng thành công") { popUpViewController in
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
                self.updateUserPoint()
            }
        }).disposed(by: disposeBag)
        
    }
    
    private func updateUserPoint(){
        userPointViewModel.updateUserPoint()

    }

}

extension TCAOrderDetailShippedViewController{
    private func setupUserPointViewModel(){
        self.userPointViewModel = TCAUserPointViewModel(bill: self.orderDetailViewModel.bill)
    }
    private func bindingUserPointViewModel(){
        self.userPointViewModel.isLoading.subscribe(onNext: { [weak self] isLoading in
            guard let self = self else {return}
            _ = isLoading ? self.showLoadingView(frame: self.view.bounds) : self.dismissLoadingView()
        }).disposed(by: disposeBag)
        
        self.userPointViewModel.updatedPoint.subscribe(onNext: { [weak self] isUpdated in
            guard let self = self else {return}
            if isUpdated{
                self.pushToOrderFinishedViewController()
            }
        }).disposed(by: disposeBag)
    }
}



