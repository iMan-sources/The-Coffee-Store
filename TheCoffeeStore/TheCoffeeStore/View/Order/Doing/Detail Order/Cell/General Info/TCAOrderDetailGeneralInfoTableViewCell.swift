//
//  TCAOrderDetailGeneralInfoTableViewCell.swift
//  TheCoffeeStore
//
//  Created by Le Viet Anh on 14/11/2022.
//

import UIKit
import RxSwift
import RxCocoa
class TCAOrderDetailGeneralInfoTableViewCell: UITableViewCell {
    //MARK: - Subviews
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    //MARK: - Properties
    static let reuseIdentifier = "TCAOrderDetailGeneralInfoTableViewCell"
    static let nibName = "TCAOrderDetailGeneralInfoTableViewCell"
    private var orderDetailGenneralInfoViewModel: TCAOrderDetailGeneralInfoViewModel!
    private let disposeBag = DisposeBag()
    //MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
        layout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Helper
    func bindingData(atIndex indexPath: IndexPath, generalInfo: BillGeneralInfo?){
        guard let generalInfo = generalInfo else {return}
        self.orderDetailGenneralInfoViewModel = TCAOrderDetailGeneralInfoViewModel(generalInfo: generalInfo)
        let data = self.orderDetailGenneralInfoViewModel.populateUserInfo(indexPath: indexPath)
        self.titleLabel.text = data.title
        self.infoLabel.text = data.content
        
    }
}

extension TCAOrderDetailGeneralInfoTableViewCell{
    private func decorateLabels(){
        self.titleLabel.font = .loadOpenSansFont(withType: .light, ofSize: .regularSize)
        self.titleLabel.textColor = .systemGray
        
        self.infoLabel.font = .loadOpenSansFont(withType: .medium, ofSize: .regularSize)
        self.titleLabel.textColor = .black
    }
    
    private func setup(){
        decorateLabels()
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    private func layout(){
        
    }
}
