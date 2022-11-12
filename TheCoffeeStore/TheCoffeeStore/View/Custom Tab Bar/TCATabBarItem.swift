//
//  TCATabBarItem.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 17/09/2022.
//

import UIKit

class TCATabBarItem: UIView {
    // MARK: - Subviews
    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.tintColor = .gray
        return imageView
    }()
    
    private let itemLabel: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.clipsToBounds = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.textColor = .gray
        return titleLabel
    }()
    
    // MARK: - Properties
    private let itemImageWidth: CGFloat = 25
    private var image: UIImage!
    private var title: String!

    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(withItemType type: TabItem) {
        self.init(frame: .zero)
        populateData(withItemType: type)
        setup()
        layout()
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    // MARK: - Action
    
    // MARK: - Helper
    private func populateData(withItemType type: TabItem){
        self.itemLabel.text = type.title
        self.itemImageView.image = type.icon.withRenderingMode(.alwaysTemplate)

    }

}

extension TCATabBarItem{
    private func setup(){
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    private func layout(){
        addSubview(itemImageView)
        addSubview(itemLabel)
        //itemImageView constraint
        NSLayoutConstraint.activate([
            itemImageView.widthAnchor.constraint(equalToConstant: itemImageWidth),
            itemImageView.heightAnchor.constraint(equalTo: itemImageView.widthAnchor, multiplier: 1),
            itemImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            itemImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8)
        ])
        
        //itemLabel constraint
        NSLayoutConstraint.activate([
            itemLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            itemLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 4)
        ])
    }
}
