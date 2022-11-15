//
//  TCAOrderDetailCheckInTableViewCell.swift
//  TheCoffeeStore
//
//  Created by Le Viet Anh on 14/11/2022.
//

import UIKit

class TCAOrderDetailCheckInTableViewCell: UITableViewCell {

    //MARK: - Subviews
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK: - Properties
    static let reuseIdentifier = "TCAOrderDetailCheckInTableViewCell"
    static let nibName = "TCAOrderDetailCheckInTableViewCell"
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
}

extension TCAOrderDetailCheckInTableViewCell{
    private func decorateLabels(){
        self.descriptionLabel.font = .loadOpenSansFont(withType: .light, ofSize: .regularSize)
        self.descriptionLabel.textColor = .black
    }
    
    private func setup(){
        decorateLabels()
        self.backgroundColor = .clear
        self.descriptionLabel.text = "Đơn giá đã trừ đi các khuyến mãi được áp dụng"
        self.selectionStyle = .none
    }
    
    private func layout(){
        
    }
}
