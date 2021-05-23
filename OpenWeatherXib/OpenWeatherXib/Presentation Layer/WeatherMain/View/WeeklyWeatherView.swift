//
//  WeeklyWeatherView.swift
//  OpenWeatherXib
//
//  Created by Igor Lemeshevski on 19/05/2021.
//

import UIKit

class WeeklyWeatherView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var current: [Hourly] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed("WeeklyWeatherView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        initCollectionView()
    }
    
    private func initCollectionView() {
        let nib = UINib(nibName: "WeeklyCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "WeeklyCollectionViewCell")
        collectionView.dataSource = self
    }

}

extension WeeklyWeatherView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        current.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeeklyCollectionViewCell", for: indexPath) as? WeeklyCollectionViewCell else { fatalError() }
        cell.configure(data: current[indexPath.row])
        return cell
    }
}

extension WeeklyWeatherView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: frame.height, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
}
