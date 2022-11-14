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
    //MARK: - Life cycle
    init(drinkNames: [String]){
        self.drinkNames = drinkNames
    }
    
    //MARK: - Action
    
    //MARK: - API
    
    func createInfoViews() -> [TCAOrderDoingDrinkInfoView]{
        var views = [TCAOrderDoingDrinkInfoView]()
        drinkNames.forEach { name in
            let infoView = TCAOrderDoingDrinkInfoView(orderName: name)
            views.append(infoView)
        }
        
        return views
    }
    
    //MARK: - Helper
  
}
