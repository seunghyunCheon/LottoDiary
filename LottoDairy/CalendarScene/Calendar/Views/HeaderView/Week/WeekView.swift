//
//  WeekView.swift
//  LottoDairy
//
//  Created by Brody on 2023/10/05.
//

import UIKit

final class WeekView: UIView {
    
    let weekdayStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.addSubview(self.weekdayStackView)
        
        let days = ["일", "월", "화", "수", "목", "금", "토"]
        days.forEach { day in
            let dayLabel = GmarketSansLabel(text: day, size: .subheadLine, weight: .medium)
            dayLabel.textColor = .designSystem(.gray63626B)
            dayLabel.textAlignment = .center
            self.weekdayStackView.addArrangedSubview(dayLabel)
        }
        
        NSLayoutConstraint.activate([
            weekdayStackView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor),
            weekdayStackView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor),
            weekdayStackView.topAnchor.constraint(equalTo: self.topAnchor),
            weekdayStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
    }
}
