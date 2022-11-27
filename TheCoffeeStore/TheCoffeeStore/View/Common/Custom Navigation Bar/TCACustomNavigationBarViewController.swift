//
//  TCACustomNavViewController.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 24/09/2022.
//

import UIKit

class TCACustomNavigationBarViewController: TCAViewController, TCAPopUpPickerViewControllerDelegate, TCAPopUpErrorMessageViewControllerDelegate {
    
    func didConfirmButtonTapped() {}

    // MARK: - Subviews
    let statusView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    //-----> LOADING VIEW
    var containerView: UIView!
    //LOADING VIEW <-----
    
    
    var customNav: TCACustomNavigationBar!
    // MARK: - Properties
    private var customNavBarHeightConstraint: NSLayoutConstraint?
    
    private var statusViewTopConstraint: NSLayoutConstraint?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    // MARK: - Navigation
    
    // MARK: - Action
    
    // MARK: - Helper
    func setup(){
        self.configCustomNavigationBar()
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func layout(){
        self.view.addSubview(self.statusView)
        self.view.addSubview(self.customNav)
        //statusView
        statusViewTopConstraint = self.statusView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        NSLayoutConstraint.activate([
            statusViewTopConstraint!,
            self.statusView.heightAnchor.constraint(equalToConstant: self.view.getStatusBarHeight()),
            self.statusView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.statusView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
        //customNav
        customNavBarHeightConstraint = self.customNav.heightAnchor.constraint(equalToConstant: self.customNav.customNavHeight)
        
        NSLayoutConstraint.activate([
            self.customNav.topAnchor.constraint(equalTo: self.statusView.bottomAnchor, constant: 0),
            self.customNav.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.customNav.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            customNavBarHeightConstraint!
            
        ])
        
        self.view.layoutIfNeeded()
        
    }
    
    func updatecustomNavBarHeightConstraint(){
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: CGFloat.kTimingAnimation) {
            
            //titleViewHeight include bottom kConstraintConstant
            self.customNavBarHeightConstraint?.constant = self.customNav.customNavHeight
            self.view.layoutIfNeeded()
        }
    }
    
    //Function can overide depend on needs of each VC
    func configCustomNavigationBar(){
        customNav.backgroundColor = .white
    }
    
    // MARK: - Animation
    func animateLargeTitleToTitle(contentOffsetY: CGFloat){
        let y = contentOffsetY
        //hide top header with text "Khoi dau ngay moi voi ca phe"
        let shouldSnap = y >= 70
        
        if shouldSnap{
            self.customNav.strechShrunkNavigationBar(isScrolled: true)
        }else{
            self.customNav.strechShrunkNavigationBar(isScrolled: false)
        }
        
        //animate height of custom nav
        UIView.animate(withDuration: CGFloat.kTimingAnimation) {
            
            //titleViewHeight include bottom kConstraintConstant
            self.customNavBarHeightConstraint?.constant = shouldSnap ? (self.customNav.customNavHeight - self.customNav.getTitleViewHeight() + CGFloat.kConstraintConstant) : self.customNav.customNavHeight
            self.view.layoutSubviews()
        }
    }
    
    func keepTitleNormal(){
        self.customNavBarHeightConstraint?.constant = (self.customNav.customNavHeight - self.customNav.getTitleViewHeight() + CGFloat.kConstraintConstant)
    }
    
    
    func animateDragViewOverScreen(contentOffsetY: CGFloat){
        let y = contentOffsetY
        //hide top header with text "Khoi dau ngay moi voi ca phe"
        let shouldSnap = y >= 30
        
        
        //animate height of custom nav
        UIView.animate(withDuration: CGFloat.kTimingAnimation) {
            
            //titleViewHeight include bottom kConstraintConstant
            self.statusViewTopConstraint?.constant = shouldSnap ? -(self.customNav.customNavHeight + .kHeaderViewHeight) : 0
            self.view.layoutSubviews()
        }
    }
    
    //---->HANDLE CUSTOM NAV BAR VISUALBILTY
    //adjust nav bar alpha is reversed to image background
    //when image background is shown nav bar is hidden
    func animateAdjustNavigationBarAlpha(alpha: CGFloat){
        customNav.animateAlphaNavigationBarWhenScrolled(alpha: alpha)
        UIView.animate(withDuration: CGFloat.kTimingAnimation) {
            self.statusView.backgroundColor = UIColor.white.withAlphaComponent(alpha)
        }
    }
    
    func postHideBottomnTabBarNotification(){
        NotificationCenter.default.post(name: .hideBottomTabBar, object: nil)
    }
    
    func postUnHideBottomTabBarNotification(){
        NotificationCenter.default.post(name: .unHideBottomTabBar, object: nil)
    }
    
    func hideCustomNavigationBar(){
        self.statusView.backgroundColor = UIColor.white.withAlphaComponent(0)
        self.customNav.setupHideCustomNavBarMode()
    }
    
    func unHideCustomNavigationBar(){
        self.statusView.backgroundColor = UIColor.white.withAlphaComponent(1)
        self.customNav.setupUnHideCustomNavBarMode()
    }
    //HANDLE CUSTOM NAV BAR VISUALBILTY <-----
    
    //-----> TCAPopUpPickerViewControllerDelegate
//    func presentPopUpPicker(picker: PopUpPicker?){
//        self.presentPopUpPickerOnMainThread(titles: picker!.titles,
//                                            header: picker!.header) { [weak self] popUpViewController in
//            guard let self = self else {return}
//            popUpViewController.delegate = self
//        }
//    }
    
    func didPickerSelected(selection: String?, atIndex indexPath: IndexPath?) {}
    
    //TCAPopUpPickerViewControllerDelegate <-----
    
//    func presentPopUpAddressPicker(branches: [Branch],
//                                   address: [AddressRecv]){
//        self.presentPopUpAddressPickerOnMainThread(branches: branches, addresses: address) { [weak self] popUpAddressController in
//            guard let self = self else {return}
//            
//            popUpAddressController.delegate = self
//        }
//    }
    
    
    //-----> DISPLAY ERROR MESSAGE
//    func presentErrorMessage(error: String){
//        self.presentErrorMessageOnMainThread(error: error) { errorPopUpViewController in
////            guard let self = self else {return}
//            errorPopUpViewController.delegate = self
//        }
//    }
//    
//    func didConfirmButtonTapped() {}
    //DISPLAY ERROR MESSAGE <-----
    
}


//MARK: - Loading View
extension TCACustomNavigationBarViewController{
    func showLoadingView(frame: CGRect){
        containerView = UIView(frame: frame)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.containerView.alpha = 0.8
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingView(){
        DispatchQueue.main.async {
            if self.containerView != nil{
                self.containerView.removeFromSuperview()

            }
            self.containerView = nil
        }
    }
}
