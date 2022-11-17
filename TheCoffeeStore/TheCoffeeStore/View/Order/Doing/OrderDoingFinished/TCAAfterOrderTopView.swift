//
//  TCAAfterOrderTopView.swift
//  TheCoffeeApp
//
//  Created by Le Viet Anh on 12/11/2022.
//

import UIKit
import RxRelay
import RxSwift
import RxCocoa

enum OrderStatus {
    case success, failed
    
    var icon: UIImage{
        switch self {
        case .success:
            return Image.checkMark
        case .failed:
            return Image.exit
        }
    }
    
    var backgroundColor: UIColor{
        switch self {
        case .success:
            return .TCABrightGreen
        case .failed:
            return .systemRed
        }
    }
    
    var title: String{
        switch self {
        case .success:
            return "Chúc mừng.\n Đơn hàng đã hoàn thành"
        case .failed:
            return "Oops! Có lỗi xảy ra"
        }
    }
    
    var  buttonAttrs: TCAButtonAttributes{
        switch self {
        case .success:
            let buttonAttrs = TCAButtonAttributes(text: "Tuyệt vời!",
                                                  textColor: .TCABrightGreen,
                                                  font: .loadOpenSansFont(withType: .semibold,ofSize: .regularSize)!,
                                                  size: .normal,
                                                  color: .white)
            return buttonAttrs
        case .failed:
            let buttonAttrs = TCAButtonAttributes(text: "Thất bại",
                                                  textColor: .systemRed,
                                                  font: .loadOpenSansFont(withType: .semibold,ofSize: .regularSize)!,
                                                  size: .normal,
                                                  color: .white)
            return buttonAttrs
        }
    }
}
class TCAAfterOrderTopView: UIView{
    
    //MARK: - Subviews
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private var textButton: TCATextButton!
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.loadOpenSansFont(withType: .semibold, ofSize: .regularSize)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.minimumScaleFactor = 0.7
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    //MARK: - Properties
    private var orderStatus: OrderStatus!
    //MARK: - Life cycle
    convenience init(orderStatus: OrderStatus) {
        self.init(frame: .zero)
        self.orderStatus = orderStatus
        setup()
        layout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.animateInOutView()
//        titleLabel.animateInOutView()
//        textButton.animateInOutView()
    }
    
}

extension TCAAfterOrderTopView{

    
    private func setup(){
        self.imageView.image = self.orderStatus.icon
        self.backgroundColor = self.orderStatus.backgroundColor
        translatesAutoresizingMaskIntoConstraints = false
        self.textButton = TCATextButton(buttonAttrs: self.orderStatus.buttonAttrs)
        self.titleLabel.text = self.orderStatus.title
    }
    
    private func layout(){
        addSubview(imageView)
        addSubview(textButton)
        addSubview(titleLabel)
        /*Because the topview include nav bar and status bar so center Y is not corrrectly*/
        let statusBarHeight = self.getStatusBarHeight()
        let topCenterConstant = (CGFloat.kScreenHeight - .kTileViewHeight/*Height of bottom view */ - statusBarHeight - 56/*Height of custom nav bar*/) / 2  /* height of top view */ - (.kBigImageHeight * 2)/*height of image view*/
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: topCenterConstant),
            imageView.heightAnchor.constraint(equalToConstant: .kBigImageHeight * 2),
            imageView.widthAnchor.constraint(equalToConstant: .kBigImageHeight * 2)
        ])
        
        NSLayoutConstraint.activate([
            textButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .kConstraintConstant),
            textButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: textButton.bottomAnchor, constant: .kConstraintConstant + .kMinimumConstraintConstant),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .kConstraintConstant * 2),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(.kConstraintConstant * 2))
        ])
        
    }
}
