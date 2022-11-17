//
//  TCAOrderSuccessViewController.swift
//  TheCoffeeApp
//
//  Created by Le Viet Anh on 12/11/2022.
//

import UIKit


class TCAOrderDetailFinishedViewController: TCAAfterOrderViewController {
    
    //MARK: - Subview
    
    //MARK: - Properties
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }
    
    
    //MARK: - Helper
    
    override func configCustomNavigationBar() {
        super.configCustomNavigationBar()
        self.customNav.backgroundColor = .TCABrightGreen
        self.statusView.backgroundColor = .TCABrightGreen
    }
    
    override func setup() {
        super.setup()
        self.afterOrderTopView = TCAAfterOrderTopView(orderStatus: .success)
        
        self.afterOrderBottomView = TCAAfterOrderBottomView(orderStatus: .success)
        self.afterOrderBottomView.delegate = self
    }
}

extension TCAOrderDetailFinishedViewController: TCAAfterOrderBottomViewDelegate{
    func didBackToHomeAfter5Seconds() {
//        postToPopToHomeVCNotification()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func didBackToHomeButtonTapped() {
//        postToPopToHomeVCNotification()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func didContinueShoppingButtonTapped() {
//        postToPopToOrderVCNotification()
        self.navigationController?.popToRootViewController(animated: true)
    }
}
