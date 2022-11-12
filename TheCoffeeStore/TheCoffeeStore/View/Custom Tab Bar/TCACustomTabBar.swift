//
//  CustomTabBar.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 14/09/2022.
//
import Foundation
import UIKit

protocol CustomTabBarDelegate: AnyObject{
    func didItemTapped(itemTapped: Int)
}

class TCACustomTabBar: UIView {
    
    // MARK: - Subviews
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        return stackView
        
    }()
    
    // MARK: - Properties
    var itemTapped: Int = 0
    var activeItem: Int = 0
    let padding: CGFloat = 8
    var items: [TabItem]!
    private let itemImageWidth: CGFloat = 25
    weak var delegate: CustomTabBarDelegate?
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(menuItems: [TabItem], frame: CGRect) {
        self.init(frame: frame)
        self.items = menuItems
        setup()
        layout()
    }
    // MARK: - Navigation
    
    // MARK: - Action
    @objc func didTabBarItemTapped(_ sender: UITapGestureRecognizer){
        let destinationTag = sender.view?.tag ?? 0
        if destinationTag != activeItem {
            switchTab(from: activeItem, to: destinationTag)
        }
        
    }
    
    // MARK: - Helper
    
}

extension TCACustomTabBar{
    private func setup(){
        layer.backgroundColor = UIColor.white.cgColor
        
        //customize uiview shape
        self.clipsToBounds = true
    }
    
    private func layout(){
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
        
        for index in 0..<self.items.count{
            let itemView = createTabItem(item: items[index])
            itemView.tag = index
            itemView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(itemView)
            
            NSLayoutConstraint.activate([
                itemView.heightAnchor.constraint(equalTo: heightAnchor)
            ])
        }
        
        setNeedsLayout()
        layoutIfNeeded()
        
        activateTab(tab: 0)
        
    }
}

// MARK: - Initialize Item tabBar
extension TCACustomTabBar{
    
    private func createItemLabel(with title: String) -> UILabel{
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.clipsToBounds = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.textColor = .gray
        return titleLabel
    }
    
    private func createItemImage(with image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.tintColor = .gray
        imageView.image = image.withRenderingMode(.alwaysTemplate)
        return imageView
    }
    
    private func createItem() -> UIView{
        let tabBarItem = UIView()
        tabBarItem.translatesAutoresizingMaskIntoConstraints = false
        tabBarItem.clipsToBounds = true
        
        return tabBarItem
    }
    
    private func addGestureToItem(with item: UIView){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTabBarItemTapped(_:)))
        item.isUserInteractionEnabled = true
        item.addGestureRecognizer(gesture)
    }
    
    private func layoutSubViewInItem(forItem tabBarItem: UIView, withImage itemImageView: UIImageView, withTitle itemLabel: UILabel){
        //itemImageView constraint
        NSLayoutConstraint.activate([
            itemImageView.widthAnchor.constraint(equalToConstant: itemImageWidth),
            itemImageView.heightAnchor.constraint(equalTo: itemImageView.widthAnchor, multiplier: 1),
            itemImageView.centerXAnchor.constraint(equalTo: tabBarItem.centerXAnchor),
            itemImageView.topAnchor.constraint(equalTo: tabBarItem.topAnchor, constant: 8)
        ])
        
        //itemLabel constraint
        NSLayoutConstraint.activate([
            itemLabel.centerXAnchor.constraint(equalTo: tabBarItem.centerXAnchor),
            itemLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 4)
        ])
    }
    
    private func createTabItem(item: TabItem) -> UIView{
        
        
        let tabBarItem = createItem()
        let itemLabel = createItemLabel(with: item.title)
        let itemImageView = createItemImage(with: item.icon)
        
        addGestureToItem(with: tabBarItem)
        
        tabBarItem.addSubview(itemLabel)
        tabBarItem.addSubview(itemImageView)
        
        layoutSubViewInItem(forItem: tabBarItem, withImage: itemImageView, withTitle: itemLabel)
        
        return tabBarItem
    }
}
// MARK: - Interact with itemTabBar
extension TCACustomTabBar{
    func switchTab(from: Int, to: Int){
        deactiveTab(tab: from)
        activateTab(tab: to)
    }
    
    private func subViewsInItem(view: [UIView]) -> (imageView: UIImageView?, label: UILabel?){
        var imageSubView: UIImageView?
        var titleSubView: UILabel?
        for subview in view{
            if let imageView = subview as? UIImageView {
                imageSubView = imageView
            }else if let title = subview as? UILabel {
                titleSubView = title
            }
        }
        return (imageSubView, titleSubView)
    }
    
    private func itemToggle(view: [UIView], isTapped: Bool, tab: Int){
        let subviews = subViewsInItem(view: view)
        let imageSubView = subviews.imageView
        let titleSubView = subviews.label
        
        imageSubView?.tintColor = isTapped ? .TCAGreen : .gray
        titleSubView?.textColor = isTapped ? .TCAGreen : .gray
        
        let itemType = TabItem.allCases[tab]
        imageSubView?.image = isTapped ? itemType.iconFill : itemType.icon
    }
    

    
    private func animateItem(view: [UIView]){
        /*
         set alpha = 0 & scale = 0.7 at first with duration = 0.3s,
         the other animation [set alpha = 1 & scale = 1] will appear after 0.1s
             anim1
         |---------------|
                    anim2
                |-------------|
         */
        
        let subviews = subViewsInItem(view: view)
        
        let imageSubView = subviews.imageView
        let titleSubView = subviews.label
        
        UIView.animate(withDuration: CGFloat.kTimingAnimation, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: [.curveEaseIn], animations: {
            imageSubView!.transform = CGAffineTransform.identity.scaledBy(x: 0.7, y: 0.7)
            titleSubView!.transform = CGAffineTransform.identity.scaledBy(x: 0.7, y: 0.7)
            
            imageSubView!.alpha = 0
            titleSubView!.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: [.curveEaseInOut], animations: {
                imageSubView!.transform = .identity
                imageSubView!.alpha = 1
                
                titleSubView!.alpha = 1
                titleSubView!.transform = .identity
                
            }, completion: nil)
        })
    }
    
    func activateTab(tab: Int){
        let tabToActive = stackView.arrangedSubviews[tab]
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn, .allowUserInteraction]) {
                //animate
                self.animateItem(view: tabToActive.subviews)
                
            } completion: { _ in
                self.itemToggle(view: tabToActive.subviews, isTapped: true, tab: tab)
                self.delegate?.didItemTapped(itemTapped: tab)
                self.activeItem = tab
            }
            
        }
    }
    
    private func deactiveTab(tab: Int){
        let inactiveTab = stackView.arrangedSubviews[tab]
        DispatchQueue.main.async {
            self.itemToggle(view: inactiveTab.subviews, isTapped: false, tab: tab)
        }
    }
}
