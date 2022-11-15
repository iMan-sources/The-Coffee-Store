//
//  TCAOrderDetailGeneralInfoViewModel.swift
//  TheCoffeeStore
//
//  Created by Le Viet Anh on 15/11/2022.
//

import UIKit
import RxCocoa
import RxRelay
import RxSwift

struct BillGeneralInfo{
    var bill: Bill
    var address: AddressRecv?
    var branch: Branch?
    var user: User?
}
class TCAOrderDetailGeneralInfoViewModel{
    
    private var bill: Bill!
    let isLoading: PublishSubject<Bool> = PublishSubject()
    var address: AddressRecv?
    var branch: Branch?
    var userInfo: User?

    private let disposeBag = DisposeBag()
    init(generalInfo: BillGeneralInfo){
        self.bill = generalInfo.bill
        self.address = generalInfo.address
        self.branch = generalInfo.branch
        self.userInfo = generalInfo.user
    }
    
    func populateUserInfo(indexPath: IndexPath) -> (title: String, content: String){
        switch indexPath.row{
        case OrderDetailGeneralInfo.billNumber.row:
            if let id = bill.id{
                return (OrderDetailGeneralInfo.billNumber.title, id)
            }
            
        case OrderDetailGeneralInfo.time.row:
            let time = Date(milliseconds: Int64(bill.time)).convertDateToString()
            return (OrderDetailGeneralInfo.time.title, time)
            
        case OrderDetailGeneralInfo.store.row:
            if let branch = branch{
                let branchInfo = "\(branch.address.addressDetail) - \(branch.address.ward) - \(branch.address.district) - \(branch.address.province)"
                return (OrderDetailGeneralInfo.store.title, branchInfo)
            }
            return (OrderDetailGeneralInfo.store.title, "")

        case OrderDetailGeneralInfo.address.row:
            if let address = address{
                let addressInfo = "\(address.address.address.addressDetail) - \(address.address.address.ward) - \(address.address.address.district) - \(address.address.address.province)"
                return (OrderDetailGeneralInfo.address.title, addressInfo)
            }
            return (OrderDetailGeneralInfo.address.title, "")
            
        case OrderDetailGeneralInfo.timeReceived.row:
            let timeReceived = Date(milliseconds: Int64(bill.time_received)).convertDateToString()
            return (OrderDetailGeneralInfo.timeReceived.title, timeReceived)
            
        case OrderDetailGeneralInfo.userName.row:
            if let userInfo = userInfo{
                let name = "\(userInfo.personalInfor.firstName) \(userInfo.personalInfor.lastName)"
                return (OrderDetailGeneralInfo.userName.title, name)
            }
            return (OrderDetailGeneralInfo.userName.title, "")
 
        case OrderDetailGeneralInfo.phoneNumber.row:
            if let userInfo = userInfo{
                let phoneNumber = "\(userInfo.personalInfor.phoneNumber)"
                return (OrderDetailGeneralInfo.phoneNumber.title, phoneNumber)
            }
            return (OrderDetailGeneralInfo.phoneNumber.title, "")
        default:
            return ("","")
        }
        
        return ("","")
    }
    

}
