//
//  TCAOrderDoingViewModel.swift
//  TheCoffeeStore
//
//  Created by Le Viet Anh on 13/11/2022.
//

import RxSwift
import RxRelay
import UIKit
class TCAOrderDoingViewModel{
    
    //MARK: - Subviews
    
    //MARK: - Properties
    var needReload = PublishSubject<Bool>()
    private var disposeBag = DisposeBag()
    private var bills = [Bill]()/*poplute table view items*/
    let isLoading: PublishSubject<Bool> = PublishSubject()
    
    let needShowError = PublishSubject<String>()
    private var setOfBills = Set<Bill>()/*Make sure no duplicate record*/
    var itemsCollection = [String: [Item]]()/*save items of bill with bill_id is key*/
    var drinkCollection = [String: [Drink]]()
    
    
    private let sections = 1
    //MARK: - Life cycle
    init(){}
    
    //MARK: - Action
    
    //MARK: - API
    
    //MARK: - Helper
    func removeOrderFinished(atIndex indexPath: IndexPath){
        let row = indexPath.row
        self.bills.remove(at: row)
    }
    
}

//MARK: - Fetching drink info

//MARK: - Update Bill realtime
extension TCAOrderDoingViewModel{
    func orderLatest(completion: @escaping((Bool) -> Void)){
        FirebaseManager.shared.updateBill { [weak self] bill, err in
            guard let self = self else {return}
            self.isLoading.onNext(false)
            if let err = err{
                self.needShowError.onNext(err)
                completion(false)
            }else{
                if let bill = bill {
                    if !self.setOfBills.contains(bill){
                        guard let id = bill.id else {return}
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.fetchItems(billId: id) { items, err in
                                if let err = err{
                                    self.needShowError.onNext(err)
                                }else{
                                    self.setOfBills.insert(bill)
                                    self.bills.insert(bill, at: 0)
                                    if self.itemsCollection[id] == nil{
                                        self.itemsCollection[id] = items
                                    }
                                    completion(true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

//MARK: - Fetching bils & items
extension TCAOrderDoingViewModel{
    
    func fetchDrink(withDrinkId drinkId: String, completion: @escaping((Drink?, String?) -> Void)){
        FirebaseManager.shared.fetchDrink(drinkId: drinkId) { drink, err in
            if let err = err{
                completion(nil, err)
            }else{
                completion(drink, nil)
            }
        }
    }
    
//    func fetchNameDrink(withDrinkId drinkId: String, completion: @escaping((String?, String?) -> Void)){
//        FirebaseManager.shared.fetchNameDrink(drinkId: drinkId) { drink, err in
//            if let err = err{
//                completion(nil, err)
//            }else{
//                completion(name, nil)
//            }
//        }
//    }
    
    func populateDrinks(){
        self.drinkCollection.removeAll()
        DispatchQueue.main.async {
            self.isLoading.onNext(true)
        }
        
        let group = DispatchGroup()
        for key in self.itemsCollection.keys{
            group.enter()
            let items = self.itemsCollection[key]
            
            let nextGroup = DispatchGroup()
            
            items?.forEach({ item in
                nextGroup.enter()
                
                self.fetchDrink(withDrinkId: item.drinkId) { drink, err in
                    if let err = err{
                        self.isLoading.onNext(false)
                        self.needShowError.onNext(err)
                    }else{
                        guard let drink = drink else {return}
                        if self.drinkCollection[item.billId] == nil{
                            self.drinkCollection[item.billId] = []
                        }
                        self.drinkCollection[item.billId]?.append(drink)
                        nextGroup.leave()
                    }
                }

            })
            
            nextGroup.notify(queue: .main) {
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            DispatchQueue.main.async {
                self.isLoading.onNext(false)
            }
            self.needReload.onNext(true)
        }
    }
    
    func fetchingOrders(completion: @escaping((Bool) -> Void)){
        self.itemsCollection.removeAll()
        DispatchQueue.main.async {
            self.isLoading.onNext(true)
        }
        fetchBills { [weak self] err in
            guard let self = self else {return}
            if let err = err{
                self.isLoading.onNext(false)
                self.needShowError.onNext(err)
                completion(false)
            }else{
                let group = DispatchGroup()
                self.bills.forEach { bill in
                    guard let id = bill.id else{return}
                    group.enter()
                    self.fetchItems(billId: id) { items, err in
                        self.itemsCollection[id] = items
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    DispatchQueue.main.async {
                        self.isLoading.onNext(false)
                    }
                    completion(true)
                }
            }
        }
    }
    
    func fetchBills(completion: @escaping((String?) -> Void)){
        FirebaseManager.shared.fetchBills { [weak self] bills, err in
            guard let self = self else {return}
            self.isLoading.onNext(false)
            if let err = err{
                completion(err)
            }else{
                if let bills = bills{
                    self.bills.append(contentsOf: bills)
                    self.bills.forEach { bill in
                        self.setOfBills.insert(bill)
                    }
                }
                completion(nil)
            }
        }
    }
    
    func fetchItems(billId: String, completion: @escaping(([Item]?, String?) -> Void)){
        FirebaseManager.shared.fetchItems(billId: billId) { items, err in
            if let err = err{
                completion(nil, err)
            }else{
                completion(items, nil)
            }
        }
    }
}

//MARK: - Populate Data
extension TCAOrderDoingViewModel{
    func numberOfSections() -> Int{
        return 1
    }
    
    func numberOfRowsInSections() -> Int{
        let rows = bills.count
        return rows
    }
    
    func billForRowAt(atIndex indexPath: IndexPath) -> Bill{
        let row = indexPath.row
        let bill = bills[row]
        return bill
    }
    
    func drinkForRowAt(atIndex indexPath: IndexPath) ->[ Drink]?{
        let row = indexPath.row
        let bill = bills[row]
        guard let id = bill.id else {return nil}
        let drinks = drinkCollection[id]
        return drinks
    }
    
    func itemForRowAt(atIndex indexPath: IndexPath) -> [Item]?{
        let row = indexPath.row
        let bill = bills[row]
        guard let id = bill.id else {return nil}
        let items = itemsCollection[id]
        return items
    }
}



extension TCAOrderDoingViewModel {
    private func setup(){
        
    }
    
    private func layout(){
        
    }
}
