//
//  TCACustomNavigationBar.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 24/09/2022.
//

import Foundation
import UIKit
enum NavigationBarButtonSide{
    case left, right
}

protocol TCACustomNavigationBarDelegate: AnyObject{
    func didLeftButtonItemTapped()
    func didRightButtonItemTapped()
}

class TCACustomNavigationBar: UIView {
    
    // MARK: - Subviews
    
    private var leftButton: UIButton?
    
    private var rightButton: UIButton?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Le Viet Anh"
        label.textColor = .black
        label.font = UIFont.loadOpenSansFont(withType: .semibold, ofSize: .largeSize)
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    // MARK: - Properties
    
    var rightButtonAttrs: TCAButtonAttributes?
    var leftButtonAttrs: TCAButtonAttributes?
    
    var titleLabelLeadingContraint: NSLayoutConstraint!
    var titleLabelTopContraint: NSLayoutConstraint!
    var titleLabelTrailingConstraint: NSLayoutConstraint!
    
    var customNavHeight: CGFloat = 0
    
    private var newTitleLeadingConstant: CGFloat = 0
    private var oldTitleTopConstant: CGFloat = 0
    private var newTitleTopConstant: CGFloat = 0
    
    weak var delegate: TCACustomNavigationBarDelegate?
    
    private var isLargeTitleAnimation: Bool!
    
    //adjust size of title label
    private lazy var isTitleAlphaAnimation: Bool = false{
        didSet{
            if isTitleAlphaAnimation{
                titleLabel.font =  UIFont.loadOpenSansFont(withType: .semibold, ofSize: .regularSize)
                titleLabel.lineBreakMode = .byTruncatingTail
            }
        }
    }
    
    private var isNoTitleAnimation: Bool = false
    // MARK: - Lifecycle
    
    init(leftButtonAttrs: TCAButtonAttributes?,
         rightButtonAttrs: TCAButtonAttributes?,
         titleAttrs: TCATitleLabelAttrs,
         isLargeTitleAnimation: Bool = true,
         isTitleAlphaAnimation: Bool = false,
         isNoTitleAnimation: Bool = false){
        super.init(frame: .zero)
        self.rightButtonAttrs = rightButtonAttrs
        self.leftButtonAttrs = leftButtonAttrs
        self.titleLabel.text = titleAttrs.text
        self.titleLabel.textColor = titleAttrs.color
        self.isLargeTitleAnimation = isLargeTitleAnimation
        self.isTitleAlphaAnimation = isTitleAlphaAnimation
        self.isNoTitleAnimation = isNoTitleAnimation
        self.setup()
        self.layout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize{
        
        return CGSize(width: UIView.noIntrinsicMetric, height: customNavHeight)
    }
    // MARK: - Navigation
    
    // MARK: - Action
    @objc func didLeftButtonTapped(_ sender: UIButton){
        delegate?.didLeftButtonItemTapped()
    }
    
    @objc func didRightButtonTapped(_ sender: UIButton){
        delegate?.didRightButtonItemTapped()
    }
    
    // MARK: - Helper
    
    private func heightForCustomNavBarAtHome(){
        let size = titleLabel.getSize(constrainedWidth: .kScreenWidth - (.kConstraintConstant * 4))
        self.customNavHeight = .kConstraintConstant + size.height
        
    }
    func updateTitleNavigationBar(title: String?, isLoggedIn: Bool){
        guard let title = title else {return}
        if isLoggedIn{
            titleLabel.text = title
            heightForCustomNavBarAtHome()

        }else{
            titleLabel.text = "Khởi đầu ngày mới với với cà phê"
            heightForCustomNavBarAtHome()
        }
    }
    
    //change title label when inherited O
    func configTitle(title: String){
        titleLabel.text = title
    }
    
    func getTitleViewHeight() -> CGFloat{
        let size = titleLabel.getSize(constrainedWidth: .kScreenWidth)
        //textSize.height + titleLabel top constraint + titleLabel bottom constraint
        let textViewHeight = size.height + .kConstraintConstant * 2
        
        return textViewHeight
    }
    //---->LARGER TITLE MODE
    func strechShrunkNavigationBar(isScrolled: Bool){
        /*
         Animate content: Large title -> regular title & stretch-shrunk height
         */
        
        self.layoutIfNeeded()
        
        NSLayoutConstraint.deactivate([
            self.titleLabelTopContraint,
            self.titleLabelLeadingContraint
        ])

        self.titleLabelTopContraint.constant = isScrolled ? self.newTitleTopConstant : self.oldTitleTopConstant
        
        self.titleLabelLeadingContraint.constant = isScrolled ? self.newTitleLeadingConstant : .kConstraintConstant * 2
        
        if isScrolled{
            NSLayoutConstraint.deactivate([self.titleLabelTrailingConstraint])
 
        }
        NSLayoutConstraint.activate([
            self.titleLabelTopContraint,
            self.titleLabelLeadingContraint
        ])
        //change constraint layout of Title
        UIView.animate(withDuration: CGFloat.kTimingAnimation) {
            self.layoutIfNeeded()
        }
        //Resize font size
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
            self.titleLabel.transform = isScrolled ? CGAffineTransform(scaleX: 0.7, y: 0.7) : CGAffineTransform(scaleX: 1, y: 1)
        }
        
        self.layoutIfNeeded()
    }
    //LARGER TITLE MODE <-----

    //---->DISPLAY PRODUCT MODE
    func animateAlphaNavigationBarWhenScrolled(alpha: CGFloat){
        guard let leftButton = leftButton else {
            return
        }
        if alpha == 0{
            UIView.animate(withDuration: CGFloat.kTimingAnimation) {
                leftButton.tintColor = .white
            }
        }else{
            UIView.animate(withDuration: CGFloat.kTimingAnimation) {
                leftButton.tintColor = .gray
            }
        }
        //animation alpha of title label
        UIView.animate(withDuration: CGFloat.kTimingAnimation) {
            //becasau thes visuability of title is reverse of background image
            //when image is display completely title label is hidden
            self.backgroundColor = UIColor.white.withAlphaComponent(alpha)
            self.titleLabel.alpha = alpha
        }
    }
    
    func setupHideCustomNavBarMode(){
        guard let leftButton = leftButton else {
            return
        }
        leftButton.tintColor = .white
        self.backgroundColor = UIColor.white.withAlphaComponent(0)
        self.titleLabel.alpha = 0
    }
    
    func setupUnHideCustomNavBarMode(){
        guard let leftButton = leftButton else {
            return
        }
        leftButton.tintColor = .gray
        self.backgroundColor = UIColor.white.withAlphaComponent(1)
        self.titleLabel.alpha = 1
    }
    //DISPLAY PRODUCT MODE <-----
    
    
    
}

extension TCACustomNavigationBar {
    private func setup(){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.initConstant()
        self.configButtons()
        
        if self.isNoTitleAnimation{
            titleLabel.font =  UIFont.loadOpenSansFont(withType: .medium, ofSize: .regularSize)
            titleLabel.lineBreakMode = .byTruncatingTail
            titleLabel.adjustsFontSizeToFitWidth = false
            titleLabel.numberOfLines = 1
        }

    }
    
    private func initConstant(){
        self.newTitleLeadingConstant = TCAConstant.kIconSize.width + (.kConstraintConstant + .kMinimumConstraintConstant)
        
        //25[icon height] + 12[icon top constant from self top] + [~]top constant from icon bottom
        self.oldTitleTopConstant = TCAConstant.kIconSize.height + .kConstraintConstant + .kConstraintConstant
        
        //title top constant from self top
        self.newTitleTopConstant = .kMinimumConstraintConstant / 2
    }
    
    private func setupCustomViewHeight(){
        let size = titleLabel.getSize(constrainedWidth: .kScreenWidth)
        self.customNavHeight = isTitleAlphaAnimation ? .kHeaderViewHeight : .kHeaderViewHeight + .kConstraintConstant + size.height        
    }
    
    private func layout(){
        
        self.addSubview(titleLabel)
        
        
        titleLabelTrailingConstraint = titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -.kConstraintConstant * 2)
        NSLayoutConstraint.activate([
            titleLabelTrailingConstraint!
        ])
        
        if self.isNoTitleAnimation{
            
            if let leftButton = leftButton{
                self.titleLabel.centerYAnchor.constraint(equalTo: leftButton.centerYAnchor).isActive = true
            }
            NSLayoutConstraint.activate([
                self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: newTitleLeadingConstant + .kConstraintConstant),
            ])

        }else{
            if !self.isLargeTitleAnimation{
                layoutInModeLargeTitleDraggedBottomToTopWhenScrolled()
            }else if isTitleAlphaAnimation{
                layoutInModeTitleAlphaWhenScrolled()
            }else{
                layoutInModeLargeTitleResizeFitNavBarWhenScrolled()
            }
        }
                
        self.layoutIfNeeded()
        
        setupCustomViewHeight()

    }
    
    //---->LAYOUT CONSTRAINT BASE ON DIFFERENT NAVBAR DISPLAY
    private func layoutInModeLargeTitleDraggedBottomToTopWhenScrolled(){
        titleLabelTrailingConstraint.isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -.kMinimumConstraintConstant).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .kConstraintConstant * 2).isActive = true
    }
    
    private func layoutInModeLargeTitleResizeFitNavBarWhenScrolled(){
        titleLabelLeadingContraint = titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .kConstraintConstant * 2)
        titleLabelTopContraint = titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: self.oldTitleTopConstant)
        
        NSLayoutConstraint.activate([
            titleLabelTopContraint!,
            titleLabelLeadingContraint!,
        ])
    }
    
    private func layoutInModeTitleAlphaWhenScrolled(){
        guard let leftButton = leftButton else {return}
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor, constant: .kConstraintConstant),
            titleLabel.centerYAnchor.constraint(equalTo: leftButton.centerYAnchor)

        ])
    }
    //LAYOUT CONSTRAINT BASE ON DIFFERENT NAVBAR DISPLAY <-----
    

}

// MARK: - Initialize Button items
extension TCACustomNavigationBar{
    private func layoutNavBarItem(button: UIButton, side: NavigationBarButtonSide){
        self.addSubview(button)
        switch side {
        case .left:
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .kConstraintConstant * 2)
            ])
        case .right:
            NSLayoutConstraint.activate([
                button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -.kConstraintConstant * 2)
            ])
        }
        
        if button.currentImage != nil{
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: TCAConstant.kIconSize.height),
                button.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 1),
                button.topAnchor.constraint(equalTo: self.topAnchor, constant: .kConstraintConstant)
            ])
        }else{
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: self.topAnchor, constant: .kMinimumConstraintConstant / 2)
            ])
            
        }
        
        self.layoutIfNeeded()
    }
    
    private func configButtons(){
        if let leftButtonAttrs = leftButtonAttrs{
            self.leftButton = UIButton()
            self.leftButton!.createButton(withButtonAttrs: leftButtonAttrs)
            self.leftButton?.addTarget(self, action: #selector(didLeftButtonTapped(_:)), for: .touchUpInside)
            self.layoutNavBarItem(button: self.leftButton!, side: .left)
            
        }
        
        if let righButtonAttrs = rightButtonAttrs{
            self.rightButton = UIButton()
            self.rightButton!.createButton(withButtonAttrs: righButtonAttrs)
            self.rightButton?.addTarget(self, action: #selector(didRightButtonTapped(_:)), for: .touchUpInside)
            self.layoutNavBarItem(button: self.rightButton!, side: .right)
        }
    }
}

