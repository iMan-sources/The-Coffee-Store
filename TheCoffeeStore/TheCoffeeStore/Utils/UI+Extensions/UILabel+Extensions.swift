//
//  UILabel+Extensions.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 25/09/2022.
//

import UIKit

struct TCATitleLabelAttrs{
    let text: String
    let color: UIColor
}

extension UILabel{
    static func createLabel(withAttrs attrs: TCATitleLabelAttrs, font: UIFont)-> UILabel{
        let label = UILabel()
        label.text = attrs.text
        label.textColor = attrs.color
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        return label
    }
}

extension UILabel {
    func getSize(constrainedWidth: CGFloat) -> CGSize {
        return systemLayoutSizeFitting(CGSize(width: constrainedWidth, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    func countLines() -> Int {
      guard let myText = self.text as NSString? else {
        return 0
      }
      // Call self.layoutIfNeeded() if your view uses auto layout
      let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
      let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font as Any], context: nil)
      return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }
}
