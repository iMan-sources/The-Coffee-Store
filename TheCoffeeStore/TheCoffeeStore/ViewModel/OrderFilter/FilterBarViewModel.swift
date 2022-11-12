//
//  FilterBarViewModel.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 03/10/2022.
//

import UIKit
enum FilterBarMode{
    case order
    var numberOfItems: Int{
        switch self{
        case .order:
            return OrderMode.allCases.count
        default:
            return 0
        }
    }
}
enum OrderMode: CaseIterable{
    case doing, done
    
    var title: String{
        switch self {
        case .doing:
            return "Đang thực hiện"
        case .done:
            return "Đã hoàn thành"
        }
    }
}
class FilterBarViewModel {
    
    // MARK: - Subviews
    
    // MARK: - Properties
    private var mode: FilterBarMode!
    // MARK: - Lifecycle
    init(mode: FilterBarMode){
        self.mode = mode
    }
    // MARK: - Navigation
    
    // MARK: - Action
    
    // MARK: - Helper
    func numberOfSections() -> Int {
        let sections = 1
        return sections
    }
    
    func numberOfItemsInSection() -> Int {
        let items = mode.numberOfItems
        return items
    }

    func orderOptionForItemAt(indexPath: IndexPath) -> OrderMode {
        let option: OrderMode = OrderMode.allCases[indexPath.row]
        return option
    }
    
    func sizeItemAt(indexPath: IndexPath) -> CGSize{
        let fontAttributes = [NSAttributedString.Key.font: UIFont.loadOpenSansFont(withType: .medium, ofSize: .regularSize)!]
        var text = ""
        switch mode{
        case .order:
            text = orderOptionForItemAt(indexPath: indexPath).title
            break
        default:
            break
        }
        let textSize = text.getSize(withAttrs: fontAttributes as [NSAttributedString.Key : Any])
        return textSize
    }
}
