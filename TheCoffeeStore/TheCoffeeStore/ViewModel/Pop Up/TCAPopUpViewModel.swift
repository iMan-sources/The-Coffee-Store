//
//  TCAPopUpViewModel.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 29/09/2022.
//

import UIKit
import RxCocoa
import RxSwift
class TCAPopUpViewModel{
    
    // MARK: - Subviews
    
    // MARK: - Properties
    private var titles: [String]
    private var header: String
    
    private let sections: Int = 1
    
    var pickerSelection = PublishSubject<String>()
    
    // MARK: - Lifecycle
    init(titles: [String]?, header: String?){

        self.titles = titles ?? []
        self.header = header ?? ""
    }

    // MARK: - Navigation
    
    // MARK: - Action
    
    // MARK: - Helper
    func numberOfSections() -> Int {
        return sections
    }
    
    func numberOfRowsInSection() -> Int {
        let rows = self.titles.count
        return rows
    }
    
    func cellForRowAt(indexPath: IndexPath) -> String{
        let index = indexPath.row
        var title = ""
        if titles.count > index{
            title = titles[index]
        }
        return title
    }
    
    func headerForSection() -> String{
        return self.header
    }
    
}
