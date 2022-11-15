//
//  TCAOrderDetailDrinkSectionHeader.swift
//  TheCoffeeStore
//
//  Created by Le Viet Anh on 14/11/2022.
//

import UIKit
class TCAOrderDetailDrinkSectionHeader: UITableViewHeaderFooterView {
    
    //MARK: - Subviews
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.loadOpenSansFont(withType: .medium, ofSize: .regularSize)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.minimumScaleFactor = 0.7
        label.textColor = .black
//        label.text = "Món đặt"
        label.textAlignment = .left
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.loadOpenSansFont(withType: .medium, ofSize: .regularSize)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.minimumScaleFactor = 0.7
        label.textColor = .black
//        label.text = "Đơn giá(VND)"
        label.textAlignment = .left
        return label
    }()
    
    private let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    
    //MARK: - Properties
    static let reuseIdentifier = "TCAOrderDetailDrinkSectionHeader"
    //MARK: - Life cycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override var intrinsicContentSize: CGSize{
//        return CGSize(width: UIView.noIntrinsicMetric, height: 1)
//    }
    
    //MARK: - Action
    
    //MARK: - API
    
    //MARK: - Helper
    func bindingData(firstColumn firstTitle: String, secondColumn secondTitle: String){
        self.titleLabel.text = firstTitle
        self.priceLabel.text = secondTitle
    }
    
}

extension TCAOrderDetailDrinkSectionHeader {
    private func setup(){
//        self.backgroundView?.backgroundColor = .clear
    }
    
    private func layout(){
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(priceLabel)
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        priceLabel.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)
        contentView.addSubview(stackView)
        let bottomStackViewConstraint = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.kMinimumConstraintConstant)
        bottomStackViewConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .kConstraintConstant),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .kConstraintConstant),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.kConstraintConstant),
            bottomStackViewConstraint
        ])
    }
}
