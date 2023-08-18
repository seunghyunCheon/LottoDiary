//
//  YearAndMonthView.swift
//  LottoDairy
//
//  Created by Brody on 2023/08/18.
//

import UIKit

final class YearAndMonthView: UIStackView {
    var yearLabel: LottoLabel = {
        let label = LottoLabel(text: "2023", font: .gmarketSans(size: .title2, weight: .light))
        
        return label
    }()
    
    var monthLabel: LottoLabel = {
        let label = LottoLabel(text: "6월", font: .gmarketSans(size: .body, weight: .bold))
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.axis = .vertical
        self.spacing = 10
        self.alignment = .leading
        self.addArrangedSubview(self.yearLabel)
        self.addArrangedSubview(self.monthLabel)
    }
}
