//
//  TCAContentSizedTableView.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 30/09/2022.
//

import UIKit

final class TCAContentSizedTableView: UITableView {

    override var contentSize: CGSize{
        didSet{
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize{
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }

}
