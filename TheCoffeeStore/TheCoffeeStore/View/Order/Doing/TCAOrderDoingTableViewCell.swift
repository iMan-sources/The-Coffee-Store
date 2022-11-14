//
//  TCAOrderDoingTableViewCell.swift
//  TheCoffeeStore
//
//  Created by Le Viet Anh on 13/11/2022.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay

protocol TCAOrderDoingTableViewCellDelegate: AnyObject{
    func needReloadTableView()
}
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
    
    let dishesStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = .kMinimumConstraintConstant
        stackView.backgroundColor = .white
        stackView.distribution = .equalSpacing
        
        stackView.layoutMargins = UIEdgeInsets(top: .kMinimumConstraintConstant, left: .kMinimumConstraintConstant, bottom: .kMinimumConstraintConstant, right: .kMinimumConstraintConstant)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.cornerRadius = 10
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.TCABrightGreen.cgColor
        return stackView
        
    }()
    
    private let dividerView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray2
        return view
    }()
    //MARK: - Properties
    static let reuseIdentifier = "TCAOrderDoingTableViewCell"
    private var orderDoingDisplayViewModel: TCAOrderDoingTableCellViewModel!
    private let disposeBag = DisposeBag()
    weak var delegate: TCAOrderDoingTableViewCellDelegate?
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
    func bindingData(bill: Bill, itemNames names: [String]){
        dateLabel.text = Date(milliseconds: Int64(bill.time)).convertDateToString()
        dishesStackView.removeFullyAllArrangedSubviews()
        
        names.forEach { name in
            dishesStackView.addArrangedSubview(TCAOrderDoingDrinkInfoView(orderName: name))
        }

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
        
        let heightDividerViewConstraint = dividerView.heightAnchor.constraint(equalToConstant: 1)
        heightDividerViewConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            heightDividerViewConstraint
        
        ])
        


        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor,constant: .kConstraintConstant),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            statusView.topAnchor.constraint(equalTo: dateLabel.topAnchor),
            statusView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dishesStackView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: .kConstraintConstant),
            dishesStackView.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            dishesStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),

        ])
        
        let dividerTopConstraint = dividerView.topAnchor.constraint(equalTo: dishesStackView.bottomAnchor, constant: .kConstraintConstant * 2)
        dividerTopConstraint.priority = .defaultHigh + 1
        NSLayoutConstraint.activate([
            dividerTopConstraint,
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    
}
