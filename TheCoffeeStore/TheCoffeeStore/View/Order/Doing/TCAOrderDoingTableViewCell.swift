//
//  TCAOrderDoingTableViewCell.swift
//  TheCoffeeStore
//
//  Created by Le Viet Anh on 13/11/2022.
//

import UIKit


class TCAOrderDoingTableViewCell: UITableViewCell {
    
    //MARK: - Subviews
    private let statusView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemRed
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: .mediumSize),
            view.widthAnchor.constraint(equalToConstant: .mediumSize)
        ])
        view.layer.cornerRadius = .mediumSize / 2
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.loadOpenSansFont(withType: .semibold, ofSize: .regularSize)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.minimumScaleFactor = 0.7
        label.textColor = .black
        label.text = "11:30 13/11/2O22"
        label.textAlignment = .left
        return label
    }()
    
    private let dishesStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = .kMinimumConstraintConstant
        stackView.backgroundColor = .white
        stackView.distribution = .fill
        stackView.layoutMargins = UIEdgeInsets(top: .kMinimumConstraintConstant, left: .kMinimumConstraintConstant, bottom: .kMinimumConstraintConstant, right: .kMinimumConstraintConstant)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.cornerRadius = 10
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.TCABrightGreen.cgColor
        return stackView
        
    }()
    
    private let dividerView: UIView = {
       let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray2
        return view
    }()
    //MARK: - Properties
    static let reuseIdentifier = "TCAOrderDoingTableViewCell"
    //MARK: - Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Action
    
    //MARK: - API
    
    //MARK: - Helper
    func bindingData(){
        
    }
}

extension TCAOrderDoingTableViewCell {
    private func setup(){
        self.selectionStyle = .none
    }
    
    private func layout(){
        contentView.addSubview(statusView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(dishesStackView)
        contentView.addSubview(dividerView)
        

        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: .kConstraintConstant),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor   , constant: (.kConstraintConstant + .kMinimumConstraintConstant)),
        ])
        
        NSLayoutConstraint.activate([
            statusView.topAnchor.constraint(equalTo: dateLabel.topAnchor),
            statusView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -(.kConstraintConstant + .kMinimumConstraintConstant))
        ])
        
        NSLayoutConstraint.activate([
            dishesStackView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: .kConstraintConstant),
            dishesStackView.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            dishesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(.kConstraintConstant + .kMinimumConstraintConstant)),

        ])
        
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(equalTo: dishesStackView.bottomAnchor, constant: .kConstraintConstant * 2),
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        let colors = [UIColor.red, UIColor.yellow, UIColor.TCABrown]
        
        for i in 0..<3{
            let infoView = TCAOrderDoingDrinkInfoView()
//            infoView.heightAnchor.constraint(equalToConstant: 44).isActive = true
            self.dishesStackView.addArrangedSubview(infoView)
            infoView.setContentHuggingPriority(UILayoutPriority(Float(250 + i)), for: .vertical)
            infoView.setContentCompressionResistancePriority(UILayoutPriority(Float(750 + i)), for: .vertical)
//            infoView.heightAnchor.constraint(greaterThanOrEqualToConstant: .kIconHeight).isActive = true
        }
    }
    
    
}
