//
//  TCAOrderDetailFooterView.swift
//  TheCoffeeStore
//
//  Created by Le Viet Anh on 14/11/2022.
//

import UIKit


class TCAOrderDetailFooterView: UIView {
    
    //MARK: - Subviews
    private let acceptButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: .kHeaderViewHeight).isActive = true
        button.backgroundColor = .white
        button.setTitle("Xác nhận đơn hàng", for: .normal)
        button.setTitleColor(.TCAAccentGreen, for: .normal)
        button.titleLabel?.font = .loadOpenSansFont(withType: .medium, ofSize: .regularSize)
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.TCAAccentGreen.cgColor
        button.layer.borderWidth = 1
        
        return button
    }()
    
    
    private let declineButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: .kHeaderViewHeight).isActive = true
        button.backgroundColor = UIColor.white
        button.titleLabel?.font = .loadOpenSansFont(withType: .medium, ofSize: .regularSize)

        button.setTitle("Huỷ đơn hàng", for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(.systemRed, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    
    private let buttonStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = .kConstraintConstant
        return stackView
    }()
    
    //MARK: - Properties
    
    //MARK: - Life cycle

    
    //MARK: - Action
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - API
    
    //MARK: - Helper
}

extension TCAOrderDetailFooterView {
    private func setup(){
        
    }
    
    private func layout(){
        buttonStackView.addArrangedSubview(acceptButton)
        buttonStackView.addArrangedSubview(declineButton)
        addSubview(buttonStackView)
        let buttonStackViewLeadingConstraint = buttonStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: .kConstraintConstant)
        buttonStackViewLeadingConstraint.priority = .defaultHigh
        let buttonStackViewTopConstraint = buttonStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: .kConstraintConstant)
        buttonStackViewTopConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            buttonStackViewTopConstraint,
            buttonStackViewLeadingConstraint,
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.kConstraintConstant)
        
        ])
    }
}
