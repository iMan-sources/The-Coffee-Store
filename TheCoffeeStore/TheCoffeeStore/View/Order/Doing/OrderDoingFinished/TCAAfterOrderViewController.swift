//
//  TCAAfterOrderViewController.swift
//  TheCoffeeApp
//
//  Created by Le Viet Anh on 12/11/2022.
//

import UIKit

class TCAAfterOrderViewController: TCACustomNavigationBarViewController{
    //MARK: - Subviews
    
    var afterOrderBottomView: TCAAfterOrderBottomView!
    var afterOrderTopView: TCAAfterOrderTopView!
    
    //MARK: - Properties
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.postHideBottomnTabBarNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.postUnHideBottomTabBarNotification()
    }
    //MARK: - Life cycle
    
    //MARK: - Helper
    
    override func configCustomNavigationBar() {
        let rightButtonAttrs = TCAButtonAttributes(text: nil,
                                                   textColor: nil,
                                                   font: nil,
                                                   size: nil,
                                                   color: nil,
                                                   image: nil,
                                                   isHidden: false)
        
        let leftButtonAttrs = TCAButtonAttributes(text: nil,
                                                  textColor: nil,
                                                  font: nil,
                                                  size: nil,
                                                  color: nil,
                                                  image: Image.exit,
                                                  isHidden: false,
                                                  tintColor: .white)
        let titleAttrs = TCATitleLabelAttrs(text: "", color: .white)
        self.customNav = TCACustomNavigationBar(leftButtonAttrs: leftButtonAttrs,
                                                rightButtonAttrs: rightButtonAttrs,
                                                titleAttrs: titleAttrs)
        
        self.customNav.delegate = self
    }
    
    
    override func setup() {
        super.setup()
    }
    
    override func layout() {
        super.layout()
        self.view.addSubview(afterOrderTopView)
        self.view.addSubview(afterOrderBottomView)
        NSLayoutConstraint.activate([
            afterOrderTopView.topAnchor.constraint(equalTo: customNav.bottomAnchor),
            afterOrderTopView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            afterOrderTopView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            afterOrderBottomView.topAnchor.constraint(equalTo: afterOrderTopView.bottomAnchor),
            afterOrderBottomView.leadingAnchor.constraint(equalTo: afterOrderTopView.leadingAnchor),
            afterOrderBottomView.trailingAnchor.constraint(equalTo: afterOrderTopView.trailingAnchor),
            afterOrderBottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

extension TCAAfterOrderViewController: TCACustomNavigationBarDelegate{
    func didLeftButtonItemTapped() {
        print("DEBUG: back to home view")
    }
    
    func didRightButtonItemTapped() {
        
    }
}



