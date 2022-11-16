//
//  TCAOrderDoingDisplayInfoViewModel.swift
//  TheCoffeeStore
//
//  Created by Le Viet Anh on 13/11/2022.
//

import RxSwift
import RxRelay
import UIKit

class TCAOrderDoingTableCellViewModel {
    
    //MARK: - Subviews
    
    //MARK: - Properties
    private var bill: Bill!
    var needReload = PublishSubject<Bool>()
    private var disposeBag = DisposeBag()
    let isLoading: PublishSubject<Bool> = PublishSubject()
    let needShowError = PublishSubject<String>()
    private var drinkNames = [String]()
    var needUpdateStatus = PublishSubject<Int>()
    //MARK: - Life cycle
    init(bill: Bill){
        self.bill = bill
    }
    
    //MARK: - Action
    
    //MARK: - API
    
    func updateStatusDrink(withBillId billId: String){
        FirebaseManager.shared.updateStatusBill(billId: billId) { [weak self]status, err in
            guard let self = self else {return}
            if let err = err{
                self.needShowError.onNext(err)
            }else{
                guard let status = status else {return}
                self.needUpdateStatus.onNext(status)
            }
        }
    }
    
    //MARK: - Helper
  
}
