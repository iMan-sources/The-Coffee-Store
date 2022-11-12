//
//  FilterBarCell.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 04/10/2022.
//

import UIKit

class FilterBarCell: UICollectionViewCell {
    // MARK: - Properties
    
    static let reuseIdentifier = "FilterBarCell"
    
    var orderOptions: OrderMode! {
        didSet {
            optionTitleLabel.text = orderOptions.title
        }
    }
    
    private let optionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .loadOpenSansFont(withType: .medium, ofSize: .regularSize)!
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override var isSelected: Bool {
        didSet {
            optionTitleLabel.textColor = isSelected ? .black : .gray
            optionTitleLabel.font = isSelected ? .loadOpenSansFont(withType: .semibold, ofSize: .regularSize)! : .loadOpenSansFont(withType: .medium, ofSize: .regularSize)!
        }
    }
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Selector
    // MARK: - Helpers
    func setup(){
        backgroundColor = .clear
    }
    
    func layout(){
        addSubview(optionTitleLabel)
        
        NSLayoutConstraint.activate([
            optionTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            optionTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
