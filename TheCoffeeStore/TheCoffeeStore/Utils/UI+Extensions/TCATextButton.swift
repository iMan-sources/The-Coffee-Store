//
//  TCAButton.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 22/09/2022.
//

import Foundation
import UIKit

enum ButtonSize{
    case normal
    case big
}

struct TCAButtonAttributes{
    let text: String?
    let textColor: UIColor?
    let font: UIFont?
    var size: ButtonSize?
    var color: UIColor?
    var image: UIImage?
    var isHidden: Bool = false
    var tintColor: UIColor? = .gray
}

class TCATextButton: UIButton{
    
    // MARK: - Subview
    var widthConstraint: NSLayoutConstraint!
    // MARK: - Properties
    private let normalButtonHeight: CGFloat = 35
    private let bigButtonHeight: CGFloat = 50
    private var buttonAttrs: TCAButtonAttributes!

    // MARK: - Life cycle
    convenience init(buttonAttrs: TCAButtonAttributes,
                     type: UIButton.ButtonType = .custom) {
        
        self.init(type: type)
        setTitle(buttonAttrs.text, for: .normal)
        setTitleColor(buttonAttrs.textColor, for: .normal)
        titleLabel?.font = buttonAttrs.font
       
        self.buttonAttrs = buttonAttrs
        backgroundColor = buttonAttrs.color
        
        if let size = buttonAttrs.size{
            self.configureButton(size: size)
        }
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        //resize width anchor
        guard let buttonAttrs = self.buttonAttrs else {return}
        let fontAttributes = [NSAttributedString.Key.font: buttonAttrs.font]
        let textSize = title?.getSize(withAttrs: fontAttributes as [NSAttributedString.Key : Any]) ?? .zero
        let buttonWidth = textSize.width + 32
        self.widthConstraint.constant = buttonWidth        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    
    private func configureButton(size: ButtonSize){
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.adjustsFontSizeToFitWidth = true
        self.layer.masksToBounds = false
        let fontAttributes = [NSAttributedString.Key.font: self.buttonAttrs.font]

        let textSize = self.buttonAttrs.text?.getSize(withAttrs: fontAttributes as [NSAttributedString.Key : Any]) ?? .zero
        let buttonWidth = textSize.width + 32
        
        self.widthConstraint = widthAnchor.constraint(equalToConstant: buttonWidth)
        
        NSLayoutConstraint.activate([
            self.widthConstraint!
        ])
        
        switch size{
        case .normal:
            heightAnchor.constraint(equalToConstant: normalButtonHeight).isActive = true
            layer.cornerRadius = normalButtonHeight / 2
        case .big:
            heightAnchor.constraint(equalToConstant: bigButtonHeight).isActive = true
            layer.cornerRadius = bigButtonHeight / 2
        }
        self.layer.masksToBounds = false
        self.clipsToBounds = false
    }
    
}
