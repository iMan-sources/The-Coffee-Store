//
//  TCAOrderDetailViewController.swift
//  TheCoffeeStore
//
//  Created by Le Viet Anh on 14/11/2022.
//

import UIKit
import RxSwift
import RxCocoa
class TCAOrderDetailNotConfirmedViewController: TCACustomNavigationBarViewController, TCACustomNavigationBarDelegate, TCAOrderDetailFooterViewDelegate {
    
    //MARK: - Subviews
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()

    private var tableFooterView: TCAOrderDetailFooterView!
    //MARK: - Properties
    var orderDetailViewModel: TCAOrderDetailViewModel!
    let disposeBag = DisposeBag()
    private var isAcceptButtonTapped: Bool = true
    //MARK: - Life cycle
    convenience init(bill: Bill,
                     items: [Item],
                     drinks: [Drink],
                     billStatus: StatusBill) {
        self.init(nibName: nil, bundle: nil)
        self.orderDetailViewModel = TCAOrderDetailViewModel(bill: bill, items: items, drinks: drinks, status: billStatus)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()

        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.postHideBottomnTabBarNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.postUnHideBottomTabBarNotification()
    }
    
    //MARK: - Action
    
    //MARK: - API
    
    
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
                                                  tintColor: .darkGray)
        let titleAttrs = TCATitleLabelAttrs(text: "Xác nhận đơn hàng", color: .black)
        self.customNav = TCACustomNavigationBar(leftButtonAttrs: leftButtonAttrs,
                                                rightButtonAttrs: rightButtonAttrs,
                                                titleAttrs: titleAttrs)
        
        self.customNav.delegate = self
    }
    
    override func setup() {
        super.setup()
        self.view.backgroundColor = .white
        setupTableFooterView()
        setupTableView()
        bindingViewModel()
       
    }
    
    override func layout() {
        super.layout()
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.customNav.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    override func didConfirmButtonTapped() {
        if isAcceptButtonTapped{
            self.orderDetailViewModel.changeStatusBill(statusCode: StatusBill.prepared.statusCode)
        }else{
            self.orderDetailViewModel.changeStatusBill(statusCode: StatusBill.canceled.statusCode)
        }
    }
    
    /*To override at child vc*/
    
    func acceptButtonTapped() {
        self.presentErrorMessageOnMainThread(error: "Sau khi xác nhận không thể huỷ đơn hàng") { [weak self] popUpViewController in
            guard let self = self else {return}
            self.isAcceptButtonTapped = true
            popUpViewController.delegate = self
        }
    }
    
    func declineButtonTapped() {
        self.presentErrorMessageOnMainThread(error: "Xác nhận huỷ đơn hàng") { [weak self] popUpViewController in
            guard let self = self else {return}
            self.isAcceptButtonTapped = false
            popUpViewController.delegate = self
        }
    }
        
   
    func didLeftButtonItemTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didRightButtonItemTapped() {
        
    }
    
    func pushToNextStatusPhase(){
        self.orderDetailViewModel.updatedStatusBill.subscribe(onNext: { [weak self] isUpdated in
            guard let self = self else {return}
            if isUpdated{
                if self.isAcceptButtonTapped{
                    self.pushToOrderDetailPreparedViewController()
                }else{
                    self.pushToOrderDetailCancelViewController()
                }
            }
        }).disposed(by: disposeBag)
    }
}

//MARK: - Utils
extension TCAOrderDetailNotConfirmedViewController {
    private func pushToOrderDetailPreparedViewController(){
        let orderDetailPreparedVC = TCAOrderDetailPreparedViewController(bill: orderDetailViewModel.bill,
                                                                         items: orderDetailViewModel.items,
                                                                         drinks: orderDetailViewModel.drinks,
                                                                         billStatus: .prepared)
        self.navigationController?.pushViewController(orderDetailPreparedVC, animated: true)
    }
    
    private func pushToOrderDetailCancelViewController(){
        let orderDetailCancelVC = TCAOrderDetailCancelViewController(bill: orderDetailViewModel.bill,
                                                                     items: orderDetailViewModel.items,
                                                                     drinks: orderDetailViewModel.drinks,
                                                                     billStatus: .canceled)
        self.navigationController?.pushViewController(orderDetailCancelVC, animated: true)

    }
}

//MARK: - Binding ViewModel
extension TCAOrderDetailNotConfirmedViewController {
    

    
    private func bindingViewModel(){
        self.orderDetailViewModel.needReload.subscribe(onNext: {[weak self] needReload in
            guard let self = self else {return}
            if needReload{
                self.tableView.reloadData()
            }
        }).disposed(by: disposeBag)
        
        self.orderDetailViewModel.isLoading.subscribe(onNext: { [weak self] isLoading in
            guard let self = self else {return}
            _ = isLoading ? self.showLoadingView(frame: self.view.bounds) : self.dismissLoadingView()
        }).disposed(by: disposeBag)
        
        self.orderDetailViewModel.needShowError.subscribe(onNext: { [weak self] err in
            guard let self = self else {return}
            self.presentErrorMessageOnMainThread(error: err) { popUpVc in
                popUpVc.delegate = self
            }
        }).disposed(by: disposeBag)
        
        pushToNextStatusPhase()
        
        self.orderDetailViewModel.fetchingBillDetail()
    }
    
    private func setupTableFooterView(){
        self.tableFooterView = TCAOrderDetailFooterView(billStatus: orderDetailViewModel.billStatus)
    }
    private func setupTableView(){
        
        
        
        tableView.register(UINib(nibName: TCAOrderDetailGeneralInfoTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: TCAOrderDetailGeneralInfoTableViewCell.reuseIdentifier)
        
        tableView.register(UINib(nibName: TCAOrderDetailDrinkTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: TCAOrderDetailDrinkTableViewCell.reuseIdentifier)
        
        tableView.register(UINib(nibName: TCAOrderDetailCheckInTableViewCell.nibName, bundle: nibBundle), forCellReuseIdentifier: TCAOrderDetailCheckInTableViewCell.reuseIdentifier)
        
        tableView.register(TCAOrderDetailSectionFooter.self, forHeaderFooterViewReuseIdentifier: TCAOrderDetailSectionFooter.reuseIdentifier)

        tableView.register(TCAOrderDetailDrinkSectionHeader.self, forHeaderFooterViewReuseIdentifier: TCAOrderDetailDrinkSectionHeader.reuseIdentifier)
        
        tableView.sectionHeaderTopPadding = 0.0
        tableView.tableFooterView = tableFooterView
        tableFooterView.delegate = self
        tableView.estimatedRowHeight = .kHeaderViewHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }

}

//MARK: - UITableViewDelegate
extension TCAOrderDetailNotConfirmedViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section{
        case OrderDetailSection.generalInfo.section:
            return 1
        case OrderDetailSection.orderDrink.section:
            return 1
        case OrderDetailSection.checkin.section:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section{
        case OrderDetailSection.generalInfo.section:
            return 0
        case OrderDetailSection.orderDrink.section:
            return UITableView.automaticDimension
        case OrderDetailSection.checkin.section:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let twoColumnHeaderCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: TCAOrderDetailDrinkSectionHeader.reuseIdentifier) as? TCAOrderDetailDrinkSectionHeader else {
            fatalError("deque TCAOrderDetailDrinkSectionHeader failed")
        }
        
        switch section{
        case OrderDetailSection.generalInfo.section:
            return nil
            
        case OrderDetailSection.orderDrink.section:
            
            twoColumnHeaderCell.bindingData(firstColumn: "Món đặt", secondColumn: "Đơn giá(VND)")
            return twoColumnHeaderCell
        case OrderDetailSection.checkin.section:
            twoColumnHeaderCell.bindingData(firstColumn: "Thanh toán", secondColumn: "Đơn giá(VND)")
            return twoColumnHeaderCell
        default:
            return nil
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: TCAOrderDetailSectionFooter.reuseIdentifier) as? TCAOrderDetailSectionFooter else {
            fatalError("deque TCAOrderDetailSectionFooter failed")
        }
        switch section{
        case OrderDetailSection.generalInfo.section:
            return footerCell
            
        case OrderDetailSection.orderDrink.section:
            
            return footerCell
        case OrderDetailSection.checkin.section:
            guard let twoColumnHeaderCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: TCAOrderDetailDrinkSectionHeader.reuseIdentifier) as? TCAOrderDetailDrinkSectionHeader else {
                fatalError("deque TCAOrderDetailDrinkSectionHeader failed")
            }
            
            twoColumnHeaderCell.bindingData(firstColumn: "Tổng cộng", secondColumn: "\(orderDetailViewModel.bill.price)")
            return twoColumnHeaderCell
        default:
            return nil
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        self.animateLargeTitleToTitle(contentOffsetY: y)
    }
}

//MARK: - UITableViewDataSource
extension TCAOrderDetailNotConfirmedViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        let sections = self.orderDetailViewModel.numberOfSections()
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = self.orderDetailViewModel.numberRowsInSection(section: section)
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section{
        case OrderDetailSection.generalInfo.section:
            guard let generalInfoCell = tableView.dequeueReusableCell(withIdentifier: TCAOrderDetailGeneralInfoTableViewCell.reuseIdentifier, for: indexPath) as? TCAOrderDetailGeneralInfoTableViewCell else {
                fatalError("deque TCAOrderDetailGeneralInfoTableViewCell failed")
            }
            generalInfoCell.bindingData(atIndex: indexPath, generalInfo: orderDetailViewModel.generalInfo)
            return generalInfoCell
        case OrderDetailSection.orderDrink.section:
            
            guard let drinkCell = tableView.dequeueReusableCell(withIdentifier: TCAOrderDetailDrinkTableViewCell.reuseIdentifier, for: indexPath) as? TCAOrderDetailDrinkTableViewCell else {
                fatalError("deque TCAOrderDetailGeneralInfoTableViewCell failed")
            }
            if let drinkWithAdjusts = orderDetailViewModel.drinkWithAdjusts(atIndex: indexPath){
                drinkCell.bindingData(drink: drinkWithAdjusts.drink, adjusts: drinkWithAdjusts.adjusts, size: drinkWithAdjusts.size)
                drinkCell.layoutIfNeeded()
            }
            return drinkCell
            
        case OrderDetailSection.checkin.section:
            guard let checkInCell = tableView.dequeueReusableCell(withIdentifier: TCAOrderDetailCheckInTableViewCell.reuseIdentifier, for: indexPath) as? TCAOrderDetailCheckInTableViewCell else {
                fatalError("deque TCAOrderDetailCheckInTableViewCell failed")
            }
            return checkInCell
        default:
            return UITableViewCell()
        }
    }
}
