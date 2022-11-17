//
//  ViewController.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 14/09/2022.
//

import UIKit
enum TabItem: String, CaseIterable {
//    case home = "Home"
//    case pay = "Pay"
    case order = "Order"
//    case stores = "Stores"
    
    var index: Int{
        switch self {
//        case .home:
//            return 0
//        case .pay:
//            return 1
        case .order:
            return 2
//        case .stores:
//            return 3
        }
    }
    
    var navigationController: UINavigationController {
        switch self{
//        case .home:
//            return UINavigationController(rootViewController: TCAHomeViewController())
        case .order:
            return UINavigationController(rootViewController: TCAOrderViewController())
//        case .pay:
//            return UINavigationController(rootViewController: TCAPayViewController())
//        case .stores:
//            return UINavigationController(rootViewController: TCAStoresViewController())
        }
    }
    
    var icon: UIImage{
        switch self {
//        case .home:
//            return Image.star
//        case .pay:
//            return Image.creditcard
        case .order:
            return Image.order
//        case .stores:
//            return Image.store
        }
    }
    
    var iconFill: UIImage{
        switch self {
//        case .home:
//            return Image.star_fill
//        case .pay:
//            return Image.creditcard_fill
        case .order:
            return Image.order_fill
//        case .stores:
//            return Image.store_fill
        }
    }
    
    var title: String {
        return self.rawValue
    }
}

class TCAMainTabBarViewController: UITabBarController {
    
    // MARK: - Subviews
    
    // MARK: - Properties
    private var customTabBar: TCACustomTabBar!
    // MARK: - Lifecycle
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadTabBar()
        self.customTabBar.addTopShadow(shadowColor: UIColor.gray, shadowOpacity: 0.9, shadowRadius: 10, offset: CGSize(width: 0.0, height : -1.0))
        registerHideBottomTabBarNotification()
        registerUnHideBottomTabBarNotification()
    }

    // MARK: - Navigation
    
    // MARK: - Action
    @objc func hideBottomTabBar(_ sender: NSNotification){
        customTabBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func unHideBottomTabBar(_ sender: NSNotification){
        customTabBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    // MARK: - Helper
    private func registerHideBottomTabBarNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(hideBottomTabBar(_:)), name: .hideBottomTabBar, object: nil)
    }
    
    private func registerUnHideBottomTabBarNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(unHideBottomTabBar(_:)), name: .unHideBottomTabBar, object: nil)
    }


}
extension TCAMainTabBarViewController{
    private func loadTabBar(){
//        let tabBarItems : [TabItem] = [.home, .pay, .order, .stores]
        let tabBarItems : [TabItem] = [.order]

        setupTabBar(tabBarItems) { viewControllers in
            self.viewControllers = viewControllers
        }
    }
    private func setupTabBar(_ menuItems: [TabItem], completion: @escaping([UIViewController]) -> Void){
        let frame = tabBar.bounds
        var viewControllers = [UIViewController]()
         
        tabBar.isHidden = true
        
        customTabBar = TCACustomTabBar(menuItems: menuItems, frame: frame)
        customTabBar.delegate = self
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(customTabBar)
        customTabBar.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            customTabBar.heightAnchor.constraint(equalToConstant: .kTabBarHeight),
            customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            
        ])
        
        //add viewcontrollers to viewcontrollers array

        menuItems.forEach({viewControllers.append($0.navigationController)})
                
        view.layoutIfNeeded()
        
        completion(viewControllers)
    }
}

// MARK: - CustomTabBarDelegate
extension TCAMainTabBarViewController: CustomTabBarDelegate{
    func didItemTapped(itemTapped: Int) {
        self.selectedIndex = itemTapped
    }
}


