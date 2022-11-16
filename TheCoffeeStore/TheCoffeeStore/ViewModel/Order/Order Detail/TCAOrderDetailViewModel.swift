//
//  TCAOrderDetailViewModel.swift
//  TheCoffeeStore
//
//  Created by Le Viet Anh on 14/11/2022.
//

import Foundation
import RxCocoa
import RxRelay
import RxSwift
enum OrderDetailSection: CaseIterable{
    case generalInfo, orderDrink, checkin
    
    var section: Int{
        switch self {
        case .generalInfo:
            return 0
        case .orderDrink:
            return 1
        case .checkin:
            return 2
        }
    }
}


enum OrderDetailGeneralInfo: CaseIterable{
    case billNumber, time,timeReceived ,store, address, userName, phoneNumber
    
    var title: String{
        switch self {
        case .billNumber:
            return "Số hoá đơn"
        case .time:
            return "Thời gian đặt món"
        case .store:
            return "Cửa hàng"
        case .address:
            return "Địa chỉ nhận hàng"
        case .timeReceived:
            return "Thời gian nhận hàng"
        case .userName:
            return "Tên khách hàng"
        case .phoneNumber:
            return "Số điện thoại"
        }
    }
    
    var row: Int{
        switch self {
        case .billNumber:
            return 0
        case .time:
            return 1
        case .timeReceived:
            return 2
        case .store:
            return 3
        case .address:
            return 4
        case .userName:
            return 5
        case .phoneNumber:
            return 6
        }
    }
}

class TCAOrderDetailViewModel{
    
    //MARK: - Subviews
    private let sections = 3
    //MARK: - Properties
    var bill: Bill!
    var items: [Item]
    let isLoading: PublishSubject<Bool> = PublishSubject()
    var address: AddressRecv?
    var userInfo: User?
    var branch: Branch?
    var generalInfo: BillGeneralInfo?
    let needShowError = PublishSubject<String>()
    let needReload = PublishSubject<Bool>()
    let updatedStatusBill = PublishSubject<Bool>()
    var drinks: [Drink]!
    var drinkAdjustCollection: [String: [Adjust]] = [String: [Adjust]]()
    var billStatus: StatusBill!
    //MARK: - Life cycle
    init(bill: Bill, items: [Item], drinks: [Drink], status: StatusBill){
        self.bill = bill
        self.items = items
        self.drinks = drinks
        self.billStatus = status
    }
    //MARK: - Action
    
    //MARK: - API
    
    //MARK: - Helper
    
    
    func numberOfSections() -> Int{
        let sections  = OrderDetailSection.allCases.count
        return sections
    }
    
    func numberRowsInSection(section: Int) -> Int{
        switch section{
        case 0:
            let rows = OrderDetailGeneralInfo.allCases.count
            return rows
        case 1:
            return self.items.count
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    
    private func drinkAtItem(item: Item) -> Drink?{
        let currentId = item.drinkId
        for drink in drinks{
            
            if let drinkId = drink.id{
                if currentId == drinkId{
                    return drink
                }
            }
        }
        return nil
    }
    
    
    func drinkWithAdjusts(atIndex indexPath: IndexPath) -> (drink: Drink, adjusts: [Adjust], size: String)?{
        
        let item = items[indexPath.row]
    
        if let id = item.id, let drink = drinkAtItem(item: item){
            let adjusts = self.drinkAdjustCollection[id]!
            let size = self.items[indexPath.row].size
            return (drink, adjusts,size)
        }
        return nil
    }
    
    func fetchingBillDetail(){
        let group = DispatchGroup()
        group.enter()
        self.isLoading.onNext(true)
        fetchUserNameInfo { err in
            
            if let err = err{
                self.needShowError.onNext(err)
            }
            group.leave()
        }
        
        group.enter()
        fetchBranch { err in
            if let err = err{
                self.needShowError.onNext(err)
            }
            group.leave()
        }
        
        group.enter()
        fetchAddress { err in
            if let err = err{
                self.needShowError.onNext(err)
            }
            group.leave()
        }
        
        group.enter()
        fetchingDrinkAdjust { err in
            if let err = err{
                self.needShowError.onNext(err)
            }
            group.leave()
        }
        
        
        group.notify(queue: .main) {
            DispatchQueue.main.async {
                self.isLoading.onNext(false)
            }
            self.generalInfo = BillGeneralInfo(bill: self.bill,
                                               address: self.address,
                                               branch: self.branch,
                                               user: self.userInfo)
            self.needReload.onNext(true)
        }
    }
}

//MARK: - FETCH ADJUST FOR EACH DRINK
extension TCAOrderDetailViewModel{
    func fetchingDrinkAdjust(completion: @escaping((String?) -> Void)){
        let mainGroup = DispatchGroup()
        for item in items{
            mainGroup.enter()
            guard let key = item.id else {return}
            if drinkAdjustCollection[key] == nil{
                drinkAdjustCollection[key] = [Adjust]()
            }
            let group = DispatchGroup()
            if let milkId = item.milkId, !milkId.isEmpty{
                group.enter()
                FirebaseManager.shared.fetchSelectedAdjust(adjustId: milkId, adjustType: .milk) { [weak self] adjust, err in
                    guard let self = self else {return}
                    group.leave()
                    if let err = err{
                        completion(err)
                        
                    }else{
                        guard let adjust = adjust else {return}
                        self.drinkAdjustCollection[key]!.append(adjust)
                    }
                    
                }
            }
            if let creamId = item.creamId, !creamId.isEmpty{
                group.enter()
                FirebaseManager.shared.fetchSelectedAdjust(adjustId: creamId, adjustType: .cream) { [weak self] adjust, err in
                    guard let self = self else {return}
                    group.leave()
                    if let err = err{
                        completion(err)
                    }else{
                        guard let adjust = adjust else {return}
                        
                        self.drinkAdjustCollection[key]!.append(adjust)
                    }
                    
                }
            }
            
            if let coffeeId = item.coffeeId, !coffeeId.isEmpty{
                group.enter()
                FirebaseManager.shared.fetchSelectedAdjust(adjustId: coffeeId, adjustType: .coffee) { [weak self] adjust, err in
                    guard let self = self else {return}
                    group.leave()
                    if let err = err{
                        completion(err)
                    }else{
                        guard let adjust = adjust else {return}
                        self.drinkAdjustCollection[key]!.append(adjust)
                    }
                }
            }
            
            group.notify(queue: .main) {
                self.drinkAdjustCollection[key] = self.drinkAdjustCollection[key]!.sorted(by: {$0.type < $1.type})
                mainGroup.leave()
            }
        }
        
        
        mainGroup.notify(queue: .main) {
            completion(nil)
        }
        
    }
}

//MARK: - Update Status Bill

extension TCAOrderDetailViewModel{
    func changeStatusBill(statusCode code: Int){
        
        guard let billId = bill.id else {return}
        self.isLoading.onNext(true)
        FirebaseManager.shared.changeStatusBill(billId: billId, statusCode: code) { [weak self] err in
            guard let self = self else {return}
            self.isLoading.onNext(false)
            if let err = err{
                self.needShowError.onNext(err)
            }else{
                self.updatedStatusBill.onNext(true)
            }
        }
    }
}

//MARK: - FETCH GENERAL INFO
extension TCAOrderDetailViewModel{
    func fetchAddress(completion: @escaping((String?) -> Void)){
        if bill.isShipped{
            guard let id = bill.shippingAddress_id else {
                completion(nil)
                return
            }
            FirebaseManager.shared.getAddressRecv(addressRecv: id) { [weak self]address, err in
                guard let self = self else {return}
                if let err = err{
                    completion(err)
                }else{
                    self.address = address
                    completion(nil)
                }
            }
        }else{
            completion(nil)
        }
    }
    
    func fetchBranch(completion: @escaping((String?) -> Void)){
        if !bill.isShipped{
            guard let branchId = bill.branch_id else {
                completion(nil)
                return
                
            }
            FirebaseManager.shared.getBranch(branchId: branchId) { [weak self]branch, err in
                guard let self = self else {return}
                if let err = err{
                    completion(err)
                }else{
                    self.branch = branch
                    completion(nil)
                }
            }
        }else{
            completion(nil)
        }
    }
    
    func fetchUserNameInfo(completion: @escaping((String?) -> Void)){
        FirebaseManager.shared.fetchUser(userId: bill.userId) { [weak self]user, err in
            guard let self = self else {return}
            if let err = err{
                completion(err)
            }else{
                self.userInfo = user
                completion(nil)
            }
        }
    }
    
    
}

extension TCAOrderDetailViewModel {
    private func setup(){
        
    }
    
    private func layout(){
        
    }
}
