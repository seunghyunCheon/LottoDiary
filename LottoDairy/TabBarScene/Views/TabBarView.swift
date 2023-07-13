//
//  TabBarView.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/14.
//

import UIKit

final class TabBarView: UITabBar {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureTabBar()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = sizeThatFits.height + 5
        
        return sizeThatFits
    }
    
    private func configureTabBar() {
        self.backgroundColor = .designSystem(.gray2B2C35)
        self.barStyle = .black
        self.tintColor = .designSystem(.white)
        self.items?.forEach { $0.setTitleTextAttributes([.font : UIFont.gmarketSans(size: .caption, weight: .medium)], for: .normal)}
    }

}
