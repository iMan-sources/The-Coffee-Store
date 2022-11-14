//
//  TCAOrderDoingDrinkInfoView.swift
//  TheCoffeeStore
//
//  Created by Le Viet Anh on 13/11/2022.
//

import UIKit

class TCAOrderDoingDrinkInfoView: UIStackView {
    
    //MARK: - Subviews
    private let drinkName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.loadOpenSansFont(withType: .medium, ofSize: .regularSize)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.2
        label.textColor = .black
        label.text = "Coffee Frapuccino Americano jafjkabfsjbf fjbasfhjsbajh"
        label.textAlignment = .left
        return label
    }()
    
    private let seperatorIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Image.exit
        imageView.tintColor = .black
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 17),
            imageView.widthAnchor.constraint(equalToConstant: 17)
        ])
        return imageView
    }()
    
    private let quatityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.loadOpenSansFont(withType: .medium, ofSize: .regularSize)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.minimumScaleFactor = 0.7
        label.textColor = .black
        label.text = "1"
        label.textAlignment = .left
        return label
    }()
    
    //MARK: - Properties
    private var orderName: String!
    //MARK: - Life cycle
    
    convenience init(orderName: String) {
        self.init(frame: .zero)
        self.orderName = orderName
        setup()
        layout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Action
    
    //MARK: - API
    
    //MARK: - Helper
}

extension TCAOrderDoingDrinkInfoView {
    private func setup(){
        self.axis = .horizontal
        self.spacing = .kMinimumConstraintConstant
        self.alignment = .center
        self.distribution = .fill
        translatesAutoresizingMaskIntoConstraints = false
        self.drinkName.text = orderName
    }
    
    private func layout(){
        self.addArrangedSubview(drinkName)
        self.addArrangedSubview(seperatorIcon)
        self.addArrangedSubview(quatityLabel)
        quatityLabel.setContentHuggingPriority(.required, for: .horizontal)
    }
}
