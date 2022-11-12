//
//  UIPopUpPickerTableViewCell.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 30/09/2022.
//

import UIKit

class TCAPopUpPickerTableViewCell: UITableViewCell {
    private var titleLabel = UILabel.createLabel(withAttrs: TCATitleLabelAttrs(text: "", color: UIColor.black),
                                                 font: .loadOpenSansFont(withType: .medium, ofSize: .smallSize + 3)!)
    // MARK: - Properties
    static let reuseIdentifier: String = "TCAPopUpPickerTableViewCell"
    static let estimatedRowHeight: CGFloat = 44
    static let nibName = "TCAPopUpPickerTableViewCell"
    // MARK: - Properties
    
    var text: String? {
        get {return titleLabel.text}
        set {titleLabel.text = newValue}
    }
    
    // MARK: - Life cycle
    func bindingData(title: String){
        self.titleLabel.text = title
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

extension TCAPopUpPickerTableViewCell{
    func setup(){
        self.selectionStyle = .none
        
    }
    
    func layout(){
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .kConstraintConstant),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .kConstraintConstant * 2),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.kConstraintConstant),
        ])
    }
}
