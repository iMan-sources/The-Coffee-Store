//
//  TCAOrderViewController.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 14/09/2022.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import RxRelay
class TCAOrderViewController: TCACustomNavigationBarViewController {
    
    // MARK: - Subviews
    private let headerFilterView: FilterBarView = {
        let view = FilterBarView(mode: .order)
        return view
    }()
    
    private let underlineFilterBar: UIView = {
        let view = UIView()
        view.backgroundColor = .TCAAccentGreen
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .TCABrightGray
        return scrollView
    }()
    
    
    
    //---->DOING, DONE ORDER VIEWCONTROLLER
    private var orderDoneView: UIView = UIView.create()
    private var orderDoneViewController: TCAOrderDoneViewController!
    
    private var orderDoingView: UIView = UIView.create()
    private var orderDoingViewController: TCAOrderDoingViewController!
    
    //DOING, DONE ORDER VIEWCONTROLLER <-----

    
    // MARK: - Properties
    private var underlineFilterBarWidthConstraint: NSLayoutConstraint?
    private var yScrollViewOffset: CGFloat = 0.0
    private var scrollViewHeight: CGFloat = 0.0
    private var scrollChildViewContentOffsets = [CGPoint]()
    private var orderDoingViewModel: TCAOrderDoingViewModel!
    private let disposeBag = DisposeBag()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    // MARK: - Navigation
    
    // MARK: - Action
    
    // MARK: - Inherited
    override func configCustomNavigationBar() {
        
        let rightButtonAttrs = TCAButtonAttributes(text: nil,
                                                   textColor: nil,
                                                   font: nil,
                                                   size: nil,
                                                   color: nil,
                                                   image: nil,
                                                   isHidden: false)
        let titleAttrs = TCATitleLabelAttrs(text: "????n h??ng", color: .black)
        self.customNav = TCACustomNavigationBar(leftButtonAttrs: nil, rightButtonAttrs: rightButtonAttrs, titleAttrs: titleAttrs)
        self.customNav.delegate = self
        
        super.configCustomNavigationBar()
    }
    
    override func setup() {
        super.setup()
        self.setupViewModel()
        self.initSubViewControllers()
        self.setupHeaderFilterView()
        self.setupScrollView()
        self.bindingOrderDoingViewModel()
    }
    
    override func layout() {
        super.layout()
        //headerFilterView
        self.view.addSubview(headerFilterView)
        self.view.addSubview(underlineFilterBar)
        self.view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            headerFilterView.topAnchor.constraint(equalTo: customNav.bottomAnchor),
            headerFilterView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            headerFilterView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            
        ])
        
        //underline
        underlineFilterBarWidthConstraint = underlineFilterBar.widthAnchor.constraint(equalToConstant: 100)
        NSLayoutConstraint.activate([
            underlineFilterBar.topAnchor.constraint(equalTo: headerFilterView.bottomAnchor),
            underlineFilterBar.leadingAnchor.constraint(equalTo: headerFilterView.leadingAnchor),
            underlineFilterBar.heightAnchor.constraint(equalToConstant: 3),
            underlineFilterBarWidthConstraint!
        ])
        
        //scrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.underlineFilterBar.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -.kTabBarHeight)
        ])
        
        self.view.layoutIfNeeded()
        
        yScrollViewOffset = scrollView.frame.origin.y
        scrollViewHeight = scrollView.frame.size.height
        
        
        addChildViewAtScrollView()
        
        let indexPath = IndexPath(row: 0, section: 0)
        self.headerFilterView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
        self.headerFilterView.collectionView(self.headerFilterView.collectionView, didSelectItemAt: indexPath)
        
        
        
    }
    // MARK: - Helper
    private func initSubViewControllers(){
        self.orderDoneViewController = TCAOrderDoneViewController()
        self.orderDoingViewController = TCAOrderDoingViewController(orderDoingViewModel: self.orderDoingViewModel)
        self.orderDoingViewController.delegate = self
    }
    private func setupViewModel(){
        orderDoingViewModel = TCAOrderDoingViewModel()
    }
    private func setupHeaderFilterView(){
        headerFilterView.delegate = self
    }
    
    private func setupChildViewsInScrollView(){
        DispatchQueue.main.async {
            self.bringToView(from: self.orderDoneViewController, to: self.orderDoneView)
    //        menuViewController.delegate = self
            self.bringToView(from: self.orderDoingViewController, to: self.orderDoingView)
        }
    }
    private func addChildViewAtScrollView(){
        var xScrollViewOffSet = 0.0
        //bring vc to view
        setupChildViewsInScrollView()
        let childViews = [orderDoingView, orderDoneView]
        /*
         set up X postion for each view in scrollview: x[2] = x[1] + width
         and save its offset in array to switch among views when filter bar selected
         */
        for i in 0..<childViews.count{
            let view = childViews[i]
            view.frame = CGRect(x: xScrollViewOffSet, y: 0, width: .kScreenWidth, height: scrollViewHeight)
            scrollChildViewContentOffsets.append(view.frame.origin)
            scrollView.addSubview(view)
            xScrollViewOffSet = xScrollViewOffSet + view.frame.size.width
        }
        scrollView.contentSize = CGSize(width: xScrollViewOffSet, height: scrollViewHeight)
    }
    
    private func setupScrollView(){
        self.scrollView.backgroundColor = .clear
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.isPagingEnabled = true
        self.scrollView.isScrollEnabled = false
    }
    
    //-----> EXECUTE CONFIRM BUTTON ACTION
    override func didConfirmButtonTapped() {
        self.dismiss(animated: true)
    }
    //EXECUTE CONFIRM BUTTON ACTION <-----
    
    private func bindingOrderDoingViewModel(){
        self.orderDoingViewModel.needShowError.subscribe { [weak self] error in
            guard let self = self else {return}
            self.presentErrorMessageOnMainThread(error: error) { [weak self] popUpErrorMessageVC in
                guard let self = self else {return}
                popUpErrorMessageVC.delegate = self
            }
        }.disposed(by: disposeBag)
        
        self.orderDoingViewModel.isLoading.subscribe(onNext: {[weak self] isLoading in
            guard let self = self else {return}
            _ = isLoading ? self.showLoadingView(frame: self.view.bounds) : self.dismissLoadingView()
        }).disposed(by: disposeBag)
    }
    
}

extension TCAOrderViewController: TCACustomNavigationBarDelegate{
    func didLeftButtonItemTapped() {}
    
    func didRightButtonItemTapped() {
        
    }
}

extension TCAOrderViewController: FilterBarViewDelegate{
    func filterViewAnimation(_ view: FilterBarView, didSelect path: IndexPath) {
        guard let cell = view.collectionView.cellForItem(at: path) as? FilterBarCell else {return}
        let xPosition = cell.frame.origin.x
        let width = cell.frame.size.width
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {
            self.scrollView.contentOffset = self.scrollChildViewContentOffsets[path.row]
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
            self.underlineFilterBarWidthConstraint?.constant = width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
            self.underlineFilterBar.frame.origin.x = xPosition
            
        }, completion: nil)
    }
}

extension TCAOrderViewController: TCAOrderDoingViewControllerDelegate{
    
    func didPushToOrderFinishedVC(bill: Bill, items: [Item], drinks: [Drink]) {
        print("did move to finished vc")
    }
    
    func didPushToOrderShippedVC(bill: Bill, items: [Item], drinks: [Drink]) {
        let orderDetailPreparedVC = TCAOrderDetailShippedViewController(bill: bill,
                                                                         items: items,
                                                                         drinks: drinks,
                                                                         billStatus: .shipped)
        self.navigationController?.pushViewController(orderDetailPreparedVC, animated: true)
    }
    
    func didPushToOrderDetailPreparedVC(bill: Bill, items: [Item], drinks: [Drink]) {
        let orderDetailPreparedVC = TCAOrderDetailPreparedViewController(bill: bill,
                                                                         items: items,
                                                                         drinks: drinks,
                                                                         billStatus: .prepared)
        self.navigationController?.pushViewController(orderDetailPreparedVC, animated: true)
    }
    
    func didPushToOrderDetailNotConfirmedVC(bill: Bill, items: [Item], drinks: [Drink]) {
        
        let orderDetailNotConfirmedVC = TCAOrderDetailNotConfirmedViewController(bill: bill,
                                                                                 items: items,
                                                                                 drinks: drinks,
                                                                                 billStatus: .notConfirmed)
        self.navigationController?.pushViewController(orderDetailNotConfirmedVC, animated: true)
    }
}

