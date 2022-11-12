//
//  TCAPopUpPickerViewController.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 30/09/2022.
//

import UIKit
protocol TCAPopUpPickerViewControllerDelegate: AnyObject{
    func didPickerSelected(selection: String?, atIndex indexPath: IndexPath?)
}
class TCAPopUpPickerViewController: TCAViewController {
    private var popUpTableView: TCAContentSizedTableView!
    // MARK: - Properties
    private var popUpViewModel: TCAPopUpViewModel!
    weak var delegate: TCAPopUpPickerViewControllerDelegate?
    // MARK: - Lifecycle
    init(titles: [String]?, header: String){
        super.init(nibName: nil, bundle: nil)
//        self.popUpViewModel = TCAPopUpViewModel(titles: titles, header: header)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //.kConstraintConstant * 3 * 2 means leading to view = 60 & trailing to view = 60
        let fixedHeight = UIScreen.main.bounds.height - (.kConstraintConstant * 10 * 2)
        if popUpTableView.contentSize.height > fixedHeight{
            popUpTableView.heightAnchor.constraint(equalToConstant: fixedHeight).isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setup()
        self.layout()
        
    }
    // MARK: - Navigation
    
    // MARK: - Action
    override func viewTapped(_ recognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true) {}
    }
    // MARK: - Helper
    
}
// MARK: - Setup UI
extension TCAPopUpPickerViewController{
    private func setup(){
        
        self.setupTableView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        setupDismissKeyboardGesture()
    }
    
    private func layout(){
        self.view.addSubview(popUpTableView)
        NSLayoutConstraint.activate([
            self.popUpTableView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.popUpTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -.kConstraintConstant * 3),
            self.popUpTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: .kConstraintConstant * 3)
        ])
        

        
    }
    
    private func setupTableView(){
        self.popUpTableView = TCAContentSizedTableView(frame: .zero)
        self.popUpTableView.translatesAutoresizingMaskIntoConstraints = false
        self.popUpTableView.delegate = self
        self.popUpTableView.dataSource = self
        self.popUpTableView.layer.cornerRadius = .kCornerRadius
        self.popUpTableView.register(TCAPopUpPickerTableViewCell.self, forCellReuseIdentifier: TCAPopUpPickerTableViewCell.reuseIdentifier)
        self.popUpTableView.estimatedRowHeight = TCAPopUpPickerTableViewCell.estimatedRowHeight
        self.popUpTableView.rowHeight = UITableView.automaticDimension
        self.popUpTableView.sectionHeaderTopPadding = 0.0
        self.popUpTableView.separatorStyle = .none
    }
    
    private func createTableHeaderView() -> UIView{
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.popUpTableView.bounds.width, height: .kConstraintConstant * 3))
        let title = UILabel.createLabel(withAttrs: TCATitleLabelAttrs(text: "", color: .black), font: .loadOpenSansFont(withType: .medium, ofSize: .regularSize)!)
        title.text = self.popUpViewModel.headerForSection()
        view.backgroundColor = .white
        view.addSubview(title)
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .kConstraintConstant * 3
    }
}
// MARK: - TableView Delegate
extension TCAPopUpPickerViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellSelected =  tableView.cellForRow(at: indexPath) as? TCAPopUpPickerTableViewCell
        self.delegate?.didPickerSelected(selection: cellSelected?.text, atIndex: indexPath)
    }
}

// MARK: - TableView Datasource
extension TCAPopUpPickerViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        let sections = self.popUpViewModel.numberOfSections()
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = self.popUpViewModel.numberOfRowsInSection()
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: TCAPopUpPickerTableViewCell.reuseIdentifier, for: indexPath) as? TCAPopUpPickerTableViewCell)!
        let text = self.popUpViewModel.cellForRowAt(indexPath: indexPath)
        cell.bindingData(title: text)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = createTableHeaderView()
        
        return view
    }
}



