//
//  TCAOrderDetailDrinkTableViewCell.swift
//  TheCoffeeStore
//
//  Created by Le Viet Anh on 14/11/2022.
//

import UIKit

class TCAOrderDetailDrinkTableViewCell: UITableViewCell {
    
    //MARK: - Subviews
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var adjustStackView: UIStackView!
    

    //MARK: - Properties
    static let reuseIdentifier = "TCAOrderDetailDrinkTableViewCell"
    static let nibName = "TCAOrderDetailDrinkTableViewCell"
    private var orderDetailDrinkViewModel: TCAOrderDetailDrinkViewModel!
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
    
    func bindingData(drink: Drink,
                     adjusts: [Adjust],
                     size: String){
        self.orderDetailDrinkViewModel = TCAOrderDetailDrinkViewModel(drink: drink, adjusts: adjusts)
        
        drinkLabel.text = self.orderDetailDrinkViewModel.getDrinkName()
        priceLabel.text = self.orderDetailDrinkViewModel.getPrice()
        adjustStackView.removeFullyAllArrangedSubviews()
        
        //create size view
        createAdjustHorizontalInfoStackView(type: "Cỡ", title: size)
        
        
        //create adjust view
        adjusts.forEach { adjust in
            createAdjustHorizontalInfoStackView(type: adjust.type, title: adjust.title)
        }
    }
    
    func createAdjustHorizontalInfoStackView(type: String, title: String){
        let adjustTypeLabel = makeAdjustLabel(withText: "\(type):")
        let adjustTitleLabel = makeAdjustLabel(withText: "\(title)")
        
        let adjustHorizontalStackView = makeHorizontalStackView()
        adjustHorizontalStackView.addArrangedSubview(adjustTypeLabel)
        adjustHorizontalStackView.addArrangedSubview(adjustTitleLabel)
        adjustStackView.addArrangedSubview(adjustHorizontalStackView)
    }
    
}

extension TCAOrderDetailDrinkTableViewCell{
    
    private func makeHorizontalStackView() -> UIStackView{
        let stackView = UIStackView()
         stackView.translatesAutoresizingMaskIntoConstraints = false
         stackView.axis = .horizontal
         stackView.distribution = .equalSpacing
         stackView.alignment = .center
         return stackView
    }
    
    private func makeAdjustLabel(withText text: String) -> UILabel{
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.loadOpenSansFont(withType: .light, ofSize: .regularSize)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.minimumScaleFactor = 0.7
        label.textColor = .TCAGreen
        label.text = text
        label.textAlignment = .left
        return label
    }
    
    private func decorateLabels(){
        self.drinkLabel.font = .loadOpenSansFont(withType: .light, ofSize: .regularSize)
        self.drinkLabel.textColor = .black
        self.priceLabel.font = .loadOpenSansFont(withType: .light, ofSize: .regularSize)
        self.priceLabel.textColor = .black
        
    }
    
    private func setup(){
        decorateLabels()
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    private func layout(){
        
    }
}
