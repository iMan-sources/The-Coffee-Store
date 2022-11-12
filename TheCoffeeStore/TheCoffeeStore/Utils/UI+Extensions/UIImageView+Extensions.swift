//
//  UIImageView+Extensions.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 20/09/2022.
//

import Foundation
import UIKit

extension UIImageView {
    static func createIcon(withImage image: UIImage, size: CGFloat = .kIconHeight) -> UIImageView{
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.image = image
        imageView.tintColor = .gray
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: size),
            imageView.widthAnchor.constraint(equalToConstant: size)
        ])
        return imageView
    }
    
    static func createSmallIcon(withImage image: UIImage, size: CGFloat = .regularSize) -> UIImageView{
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.image = image
        imageView.tintColor = .gray
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: size),
            imageView.widthAnchor.constraint(equalToConstant: size)
        ])
        return imageView
    }
}
