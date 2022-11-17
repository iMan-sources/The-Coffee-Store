//
//  TCAUserPointViewModel.swift
//  TheCoffeeStore
//
//  Created by Le Viet Anh on 17/11/2022.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay
class TCAUserPointViewModel{
    
    
    private var bill: Bill!
    let isLoading: PublishSubject<Bool> = PublishSubject()
    let updatedPoint: PublishSubject<Bool> = PublishSubject()
    let needShowError = PublishSubject<String>()
    init(bill: Bill){
        self.bill = bill
    }
    
    private func exchangePoint() -> Int{
        let price = bill.price
        let point = Int(price/1000)
        return point
    }
    
    private func getRankId(rankId: String, completion: @escaping((Rank?, String?) -> Void)){
        FirebaseManager.shared.getRankById(rankId: rankId) { rank, err in
            if let err = err{
                completion(nil, err)
            }else{
                completion(rank, nil)
            }
        }
    }
    /*Find next rank from current rank*/
    private func levelUpRank(rank: Rank,
                             completion: @escaping((Rank?, String?) -> Void)){
        let newOrder = rank.order + 1
        FirebaseManager.shared.searchRankByOrder(order: newOrder) { rank, err in
            if let err = err{
                completion(nil, err)
            }else{
                completion(rank, nil)
            }
        }
    }
    
    private func updatePoint(userPoint: UserPoint,
                             newPoint: Int,
                             rankId: String,
                             completion: @escaping((String?) -> Void)){
        FirebaseManager.shared.updatePoint(rank_Id: rankId, userPoint: userPoint, newPoint: newPoint) { err in
            if let err = err{
                completion(err)
            }else{
                completion(nil)
            }
        }
    }
    
    /*Fetch Rank -> check condition to level up or not -> if passed,  find new rank by order -> return new rank or not passed, return current rank*/
    private func handleRank(newPoint: Int,
                            rankId: String,
                            completion: @escaping((Rank?, String?) -> Void)){
        getRankId(rankId: rankId) { [weak self]rank, err in
            guard let self = self else {return}
            if let err = err{
               completion(nil, err)
            }else{
                guard let rank = rank else {return}
                if newPoint >= rank.pointCondition{
                    //passed, level up rank
                    self.levelUpRank(rank: rank) { newRank, err in
                        if let err = err{
                            completion(nil, err)
                            
                        }else{
                            completion(newRank, err)
                            
                        }
                    }
                }else{
                    //not need to update rank
                    completion(rank, nil)
                }
            }
        }
    }
    
    private func fetchUserPoint(userId: String, completion: @escaping((UserPoint?, String?) -> Void)){
        FirebaseManager.shared.fetchUserPoint(userId: userId) { userPoint, err in
            if let err = err{
                completion(nil, err)
            }else{
                completion(userPoint, nil)
            }
        }
    }
    
    
    func updateUserPoint(){
        let userId = bill.userId
        DispatchQueue.main.async {
            self.isLoading.onNext(true)
        }
        let additionalPoint = exchangePoint()
        //fetch user point info
        self.fetchUserPoint(userId: userId) { [weak self] userPoint, err in
            guard let self = self else {return}
            if let err = err{
                self.needShowError.onNext(err)
                self.updatedPoint.onNext(false)
                DispatchQueue.main.async {
                    self.isLoading.onNext(false)
                }
            }else{
                guard let userPoint = userPoint else {return}
                let newPoint = userPoint.currentPoint + additionalPoint
                //update rank if needed
                self.handleRank(newPoint: newPoint, rankId: userPoint.rankId) { rank, err in
                    if let err = err {
                        self.needShowError.onNext(err)
                        self.updatedPoint.onNext(false)
                        DispatchQueue.main.async {
                            self.isLoading.onNext(false)
                        }
                    }else{
                        guard let rank = rank, let id = rank.id else {return}
                        self.updatePoint(userPoint: userPoint, newPoint: newPoint, rankId: id) { err in
                            if let err = err{
                                self.needShowError.onNext(err)
                                self.updatedPoint.onNext(false)
                            }else{
                                self.updatedPoint.onNext(true)
                                DispatchQueue.main.async {
                                    self.isLoading.onNext(false)
                                }
                            }
                        }
                    }
                    
                    
                }
                
                
            }
        }
    }
}
