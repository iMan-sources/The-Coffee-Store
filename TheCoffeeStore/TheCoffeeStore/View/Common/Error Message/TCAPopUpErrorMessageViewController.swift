//
//  TCAPopUpErrorMessageViewController.swift
//  TheCoffeeApp
//
//  Created by Le Viet Anh on 03/11/2022.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay

protocol TCAPopUpErrorMessageViewControllerDelegate: AnyObject{
    func didConfirmButtonTapped()
}
class TCAPopUpErrorMessageViewController: TCAViewController {
    
    private let errorPopUpView: TCAPopUpErrorMessageView = {
       let view = TCAPopUpErrorMessageView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Properties
    private var errorMessageViewModel: TCAErrorMessageViewModel!
    weak var delegate: TCAPopUpErrorMessageViewControllerDelegate?
    // MARK: - Lifecycle
    init(error: String){
        super.init(nibName: nil, bundle: nil)
        self.errorMessageViewModel = TCAErrorMessageViewModel(error: error)
        
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    private func bindingViewModel(){
        errorPopUpView.bindingData(error: errorMessageViewModel.showError())
    }
}
// MARK: - Setup UI
extension TCAPopUpErrorMessageViewController{
    private func setup(){
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        setupDismissKeyboardGesture()
        bindingViewModel()
        errorPopUpView.delegate = self
    }
    
    private func layout(){
        self.view.addSubview(errorPopUpView)
        //height = label height + top label constant + bottom label constant + button height + button bottom constant
        let height = errorPopUpView.errorTitle.getSize(constrainedWidth: .kScreenWidth - (.kConstraintConstant * 3)).height + (.kConstraintConstant + .kMinimumConstraintConstant) + .kConstraintConstant * 2 + .kBigImageHeight
        NSLayoutConstraint.activate([
            self.errorPopUpView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.errorPopUpView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -.kConstraintConstant * 3),
            self.errorPopUpView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: .kConstraintConstant * 3),
            self.errorPopUpView.heightAnchor.constraint(equalToConstant: height)
        ])
                
    }
}
// MARK: - TCAPopUpErrorMessageViewDelegate
extension TCAPopUpErrorMessageViewController: TCAPopUpErrorMessageViewDelegate{
    func didConfirmButtonTapped() {
        delegate?.didConfirmButtonTapped()
    }
}




