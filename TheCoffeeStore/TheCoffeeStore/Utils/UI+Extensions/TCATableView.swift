//
//  TCATableView.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 12/10/2022.
//

import UIKit

class TCATableView: UITableView {



    override var contentSize: CGSize {
        didSet{
            self.invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        var newSize = self.contentSize
        newSize.height += (.kMinimumConstraintConstant + .kConstraintConstant)
        return newSize
    }
    

    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}
