//
//  TCALazyImageView.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 07/10/2022.
//

import UIKit
import SDWebImage
class TCALazyImageView: UIImageView {
    
    // MARK: - Subviews
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    init(){
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    // MARK: - Navigation
    
    // MARK: - Action
    
    // MARK: - Helper
    func downloadImage(imageURL: URL?, size: CGSize?, completion: (() -> Void)?=nil){
        if let size = size {
            self.image = image?.resizeImage(targetSize: size)
        }
        self.sd_setImage(with: imageURL, placeholderImage: Image.placeHolder, options: .continueInBackground) { _, _, _, _ in
            completion?()
        }
    }
    
    func download(imagePath: String, size: CGSize?, completion: ((String?) -> Void)?=nil){
        FirebaseStore.shared.downloadImageURL(imagePath: imagePath) { [weak self]url, error in
            guard let self = self else {return}
            if let error = error{
                completion?(error)
            }else{
                self.downloadImage(imageURL: url, size: size) {
                    completion?(nil)
                }
            }
        }
    }
    
}
