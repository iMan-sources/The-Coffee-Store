//
//  TCAPopUpErrorMessageView.swift
//  TheCoffeeApp
//
//  Created by Le Viet Anh on 03/11/2022.
//

import UIKit
import RxRelay
import RxSwift
protocol TCAPopUpErrorMessageViewDelegate: AnyObject{
    func didConfirmButtonTapped()
}
class TCAPopUpErrorMessageView: UIView {
    
    //MARK: - Subviews
    let errorTitle: TCALabel = {
        let label = TCALabel(font: .loadOpenSansFont(withType: .semibold, ofSize: .regularSize)!)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Lỗi kết nối mạng xin vui lòng thử lại"
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.minimumScaleFactor = 0.7
        return label
    }()
    
    lazy var confirmButton : TCATextButton = {
        let buttonAttrs = TCAButtonAttributes(text: "Đồng Ý",
                                              textColor: .TCABrightGreen,
                                              font: .loadOpenSansFont(withType: .medium, ofSize: .regularSize)!,
                                              size: .normal,
                                              color: .white)
        let button = TCATextButton(buttonAttrs: buttonAttrs)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.TCABrightGreen.cgColor
        return button
    }()
    //MARK: - Properties
    weak var delegate: TCAPopUpErrorMessageViewDelegate?
    private let disposeBag = DisposeBag()
    //MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper
    func bindingData(error: String){
        errorTitle.text = error
    }
    
    func binding(){
        self.confirmButton.rx.tap.subscribe { [weak self]_ in
            guard let self = self else {return}
            self.delegate?.didConfirmButtonTapped()
        }.disposed(by: disposeBag)
    }
    
}

extension TCAPopUpErrorMessageView{
    private func setup(){
        self.translatesAutoresizingMaskIntoConstraints = false
        binding()
        layer.cornerRadius = 10
    }
    
    private func layout(){
        addSubview(errorTitle)
        addSubview(confirmButton)
        
        //error title
        NSLayoutConstraint.activate([
            errorTitle.topAnchor.constraint(equalTo: topAnchor, constant: .kConstraintConstant + .kMinimumConstraintConstant),
            errorTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .kConstraintConstant + .kMinimumConstraintConstant),
            errorTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(.kConstraintConstant + .kMinimumConstraintConstant)),
        ])
        
        //confirm button
        NSLayoutConstraint.activate([
            confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -(.kConstraintConstant + .kMinimumConstraintConstant)),
            confirmButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(.kConstraintConstant))
        ])
    }
}
