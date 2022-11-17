//
//  TCAOrderDoingViewController.swift
//  TheCoffeeStore
//
//  Created by Le Viet Anh on 12/11/2022.
//

import UIKit
import RxRelay
import RxSwift
import RxCocoa
protocol TCAOrderDoingViewControllerDelegate: AnyObject{
    func didPushToOrderDetailNotConfirmedVC(bill: Bill,
                                items: [Item],
                                drinks: [Drink])
    
    func didPushToOrderDetailPreparedVC(bill: Bill,
                                         items: [Item],
                                         drinks: [Drink])
    
    func didPushToOrderShippedVC(bill: Bill,
                                 items: [Item],
                                 drinks: [Drink])
    
    func didPushToOrderFinishedVC(bill: Bill,
                                  items: [Item],
                                  drinks: [Drink])
    
    
}
class TCAOrderDoingViewController: UIViewController {
    
    //MARK: - Subviews
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    //MARK: - Properties
    private var orderDoingViewModel: TCAOrderDoingViewModel!
    private let disposeBag = DisposeBag()
    weak var delegate: TCAOrderDoingViewControllerDelegate?
    //MARK: - Life cycle
    
    convenience init(orderDoingViewModel: TCAOrderDoingViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.orderDoingViewModel = orderDoingViewModel
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
        bindingOrderDoingViewModel()
        
    }
    
    //MARK: - Action
    
    //MARK: - API
    
    //MARK: - Helper

    private func bindingOrderDoingViewModel(){
        
        orderDoingViewModel.needReload.subscribe(onNext: { [weak self]needReload in
            guard let self = self else{return}
            if needReload{
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }).disposed(by: disposeBag)
        
        let group = DispatchGroup()
        group.enter()
        orderDoingViewModel.fetchingOrders { [weak self] isSuccess in
            guard let self = self else {return}
            if isSuccess{
                group.leave()
                self.orderDoingViewModel.populateDrinks()
            }
        }
        group.notify(queue: .main) {
            self.orderDoingViewModel.orderLatest { [weak self] isSuccess in
                guard let self = self else {return}
                if isSuccess{
                    self.orderDoingViewModel.populateDrinks()
                }
            }
        }
    }
}

extension TCAOrderDoingViewController {
    private func setupViewModel(){
        self.orderDoingViewModel = TCAOrderDoingViewModel()
    }
    private func setupTableView(){
        tableView.register(TCAOrderDoingTableViewCell.self, forCellReuseIdentifier: TCAOrderDoingTableViewCell.reuseIdentifier)
        tableView.sectionHeaderTopPadding = 0.0
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setup(){
        self.view.backgroundColor = .white
        setupTableView()
        setupViewModel()
        
    }
    
    private func layout(){

        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        
        ])
    }
}

//MARK: - UITableViewDelegate
extension TCAOrderDoingViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TCAOrderDoingTableViewCell else {
            fatalError("cell for row TCAOrderDoingTableViewCell failed")
        }
        guard let items = orderDoingViewModel.itemForRowAt(atIndex: indexPath), let drinks = orderDoingViewModel.drinkForRowAt(atIndex: indexPath) else{return}
        
        let bill = orderDoingViewModel.billForRowAt(atIndex: indexPath)
        
        switch cell.billStatus(){
        case .notConfirmed:
            delegate?.didPushToOrderDetailNotConfirmedVC(bill: bill, items: items, drinks: drinks)
        case .prepared:
            delegate?.didPushToOrderDetailPreparedVC(bill: bill, items: items, drinks: drinks)
        case.shipped:
            delegate?.didPushToOrderShippedVC(bill: bill, items: items, drinks: drinks)
        case .finished:
            delegate?.didPushToOrderFinishedVC(bill: bill, items: items, drinks: drinks)
        case .canceled:
            break
        }
    }
}

//MARK: - UITableViewDataSource
extension TCAOrderDoingViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return orderDoingViewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderDoingViewModel.numberOfRowsInSections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TCAOrderDoingTableViewCell.reuseIdentifier, for: indexPath) as? TCAOrderDoingTableViewCell else{
            fatalError("deque TCAOrderDoingTableViewCell failed")
        }
        
        cell.delegate = self
        let bill = orderDoingViewModel.billForRowAt(atIndex: indexPath)

        if let billId = bill.id, let drinks = orderDoingViewModel.drinkCollection[billId] {
            cell.bindingData(bill: bill, drinks: drinks)
            cell.layoutIfNeeded()
        }
        return cell
    }
}

//MARK: - TCAPopUpErrorMessageViewControllerDelegate
extension TCAOrderDoingViewController: TCAPopUpErrorMessageViewControllerDelegate{
    func didConfirmButtonTapped() {
        self.dismiss(animated: true)
    }
}

//MARK: - TCAOrderDoingViewControllerDelegate
extension TCAOrderDoingViewController: TCAOrderDoingTableViewCellDelegate{
    func needReloadTableView() {}
    
    func needRemoveFinshedOrderFromDoingScreen(cell: TCAOrderDoingTableViewCell) {
        guard let indexPath  = tableView.indexPath(for: cell) else {return}
        self.tableView.beginUpdates()
        self.orderDoingViewModel.removeOrderFinished(atIndex: indexPath)
        self.tableView.deleteRows(at: [indexPath], with: .none)
        self.tableView.reloadData()
        self.tableView.endUpdates()
    }
}





