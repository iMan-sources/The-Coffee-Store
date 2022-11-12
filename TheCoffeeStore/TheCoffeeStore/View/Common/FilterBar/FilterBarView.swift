//
//  FilterBarView.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 03/10/2022.
//

import UIKit

protocol FilterBarViewDelegate: AnyObject {
    func filterViewAnimation(_ view: FilterBarView, didSelect path: IndexPath)
}
class FilterBarView: UIView {
    
    // MARK: - Subviews
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isScrollEnabled = false
        view.backgroundColor =  .clear

        return view
    }()
    // MARK: - Properties
    private var filterBarViewModel: FilterBarViewModel!
    weak var delegate: FilterBarViewDelegate?
    // MARK: - Lifecycle
    
    convenience init(mode: FilterBarMode) {
        self.init(frame: .zero)
        self.filterBarViewModel = FilterBarViewModel(mode: mode)
        setup()
        layout()
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize{
        return CGSize(width: UIView.noIntrinsicMetric, height: .kHeaderViewHeight)
    }
    // MARK: - Navigation
    
    // MARK: - Action
    
    // MARK: - Helper
    private func configCollectionView(){
        
        collectionView.register(FilterBarCell.self, forCellWithReuseIdentifier: FilterBarCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self


        
    }
    
}

extension FilterBarView{
    private func setup(){
        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
       
    }
    
    private func layout(){
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        self.layoutIfNeeded()
        
        configCollectionView()
        
        
    }
}

// MARK: - UICollectionViewDelegate
extension FilterBarView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.filterViewAnimation(self, didSelect: indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FilterBarView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = filterBarViewModel.sizeItemAt(indexPath: indexPath)
        //.kConstraintConstant * 2 = leading & trailing = 12
        let widthItem = size.width + (.kConstraintConstant + .kMinimumConstraintConstant/2)
        let itemSize = CGSize(width: widthItem, height: frame.height)
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0 
    }
}

// MARK: - UICollectionViewDataSource
extension FilterBarView: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let sections = filterBarViewModel.numberOfSections()
        return sections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let items = filterBarViewModel.numberOfItemsInSection()
        return items
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(
            withReuseIdentifier: FilterBarCell.reuseIdentifier,
                        for: indexPath) as? FilterBarCell)!
        let option = filterBarViewModel.orderOptionForItemAt(indexPath: indexPath)
        cell.orderOptions = option
        return cell
    }
}


