//
//  TCAOrderDoingViewController.swift
//  TheCoffeeStore
//
//  Created by Le Viet Anh on 12/11/2022.
//

import UIKit

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
    private let orderDoingViewModel = TCAOrderDoingViewModel()
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        binding()
        
    }
    
    //MARK: - Action
    
    //MARK: - API
    
    //MARK: - Helper
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTableView()
    }
    
    private func binding(){
        orderDoingViewModel.orderLatest()
    }
    
}

extension TCAOrderDoingViewController {
    private func setupTableView(){
        tableView.register(TCAOrderDoingTableViewCell.self, forCellReuseIdentifier: TCAOrderDoingTableViewCell.reuseIdentifier)
        tableView.sectionHeaderTopPadding = 0.0
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setup(){
        self.view.backgroundColor = .TCAWarmNeutral
        
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
    
}

//MARK: - UITableViewDataSource
extension TCAOrderDoingViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TCAOrderDoingTableViewCell.reuseIdentifier, for: indexPath) as? TCAOrderDoingTableViewCell else{
            fatalError("deque TCAOrderDoingTableViewCell failed")
        }
        
        return cell
    }
}




