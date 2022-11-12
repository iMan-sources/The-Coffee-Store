//
//  TCALabel.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 09/10/2022.
//

import UIKit

class TCALabel: UILabel {
    init(font: UIFont) {
        super.init(frame: .zero)
        self.font = font
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        self.translatesAutoresizingMaskIntoConstraints = false
    }

}
