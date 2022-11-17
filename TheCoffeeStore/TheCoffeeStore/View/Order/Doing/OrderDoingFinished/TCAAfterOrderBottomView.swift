//
//  TCAAfterOrderBottomView.swift
//  TheCoffeeApp
//
//  Created by Le Viet Anh on 12/11/2022.
//

import UIKit
import RxSwift
import RxCocoa
protocol TCAAfterOrderBottomViewDelegate: AnyObject{
    func didBackToHomeButtonTapped()
    func didContinueShoppingButtonTapped()
    func didBackToHomeAfter5Seconds()
}

class TCAAfterOrderBottomView: UIView{
    
    //MARK: - Subviews
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.loadOpenSansFont(withType: .semibold, ofSize: .regularSize)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.minimumScaleFactor = 0.7
        label.textColor = .TCABrightGreen
        label.text = "Trở về trang chủ trong: "
        label.textAlignment = .left
        return label
    }()
    
    private let secondLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.loadOpenSansFont(withType: .semibold, ofSize: .regularSize)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.minimumScaleFactor = 0.7
        label.textColor = .TCABrightGreen
        label.text = "5"
        label.textAlignment = .left
        return label
    }()
    
//    private let continueShoppingButton: TCATextButton = {
//        let buttonAttrs = TCAButtonAttributes(text: "Tiếp tục chọn món",
//                                              textColor: .TCABrightGreen,
//                                              font: .loadOpenSansFont(withType: .semibold,ofSize: .regularSize)!,
//                                              size: .normal,
//                                              color: .white)
//        let button = TCATextButton(buttonAttrs: buttonAttrs)
//        button.layer.borderColor = UIColor.TCABrightGreen.cgColor
//        button.layer.borderWidth = 1
//        return button
//    }()
    
    private let backToHomeButton: TCATextButton = {
        let buttonAttrs = TCAButtonAttributes(text: "Trở về trang chủ",
                                              textColor: .white,
                                              font: .loadOpenSansFont(withType: .semibold,ofSize: .regularSize)!,
                                              size: .normal,
                                              color: .TCABrightGreen)
        let button = TCATextButton(buttonAttrs: buttonAttrs)
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = .kConstraintConstant
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        return stackView
    }()
    
    
    
    //MARK: - Properties
    private var orderStatus: OrderStatus!
    private var secondsRemainingToExit = 5
    private let disposeBag = DisposeBag()
    weak var delegate: TCAAfterOrderBottomViewDelegate?
    //MARK: - Life cycle
    convenience init(orderStatus: OrderStatus) {
        self.init(frame: .zero)
        self.orderStatus = orderStatus
        setup()
        layout()
        binding()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize{
        return CGSize(width: UIView.noIntrinsicMetric, height: .kTileViewHeight)
    }
    
}

extension TCAAfterOrderBottomView{
    
    private func binding(){
        self.backToHomeButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else {return}
            self.delegate?.didBackToHomeButtonTapped()
        }).disposed(by: disposeBag)
        
//        self.continueShoppingButton.rx.tap.subscribe(onNext: { [weak self] _ in
//            guard let self = self else {return}
//            self.delegate?.didContinueShoppingButtonTapped()
//        }).disposed(by: disposeBag)
    }
    
    private func countDownToExit(){
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if self.secondsRemainingToExit > 0 {
                self.secondLabel.text = "\(self.secondsRemainingToExit)"
                self.secondsRemainingToExit -= 1
            } else if self.secondsRemainingToExit == 0 {
                self.delegate?.didBackToHomeAfter5Seconds()
                Timer.invalidate()
            }
        }
    }
    
    private func setup(){

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        countDownToExit()
    }
    
    private func layout(){
        addSubview(titleLabel)
        addSubview(secondLabel)
        addSubview(buttonStackView)
//        buttonStackView.addArrangedSubview(continueShoppingButton)
        buttonStackView.addArrangedSubview(backToHomeButton)
        
        titleLabel.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)
        secondLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: .kConstraintConstant),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .kConstraintConstant * 2),
            
        ])
        
        NSLayoutConstraint.activate([
            secondLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            secondLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: .kMinimumConstraintConstant / 2),
            secondLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(.kConstraintConstant * 2))
        ])
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .kConstraintConstant + .kMinimumConstraintConstant),
            buttonStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
            
        ])
    }
}

