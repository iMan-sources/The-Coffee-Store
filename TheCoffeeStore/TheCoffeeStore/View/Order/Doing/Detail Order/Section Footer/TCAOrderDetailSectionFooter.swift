//
//  TCAOrderDetailSectionFooter.swift
//  TheCoffeeStore
//
//  Created by Le Viet Anh on 14/11/2022.
//

import UIKit


class TCAOrderDetailSectionFooter: UITableViewHeaderFooterView {
    
    //MARK: - Subviews
    private let dividerView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray2
        return view
    }()
    //MARK: - Properties
    static let reuseIdentifier = "TCAOrderDetailSectionFooter"
    //MARK: - Life cycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize{
        return CGSize(width: UIView.noIntrinsicMetric, height: 1)
    }
    
    //MARK: - Action
    
    //MARK: - API
    
    //MARK: - Helper
    
}

extension TCAOrderDetailSectionFooter {
    private func setup(){
//        self.backgroundColor = .clear
    }
    
    private func layout(){
        contentView.addSubview(dividerView)
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
