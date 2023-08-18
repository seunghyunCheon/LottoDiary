//
//  CalendarWeekView.swift
//  LottoDairy
//
//  Created by Brody on 2023/08/18.
//

import UIKit

final class CalendarHeaderView: UIView {
    
    // MARK: - UIView
    
    var monthLabel: LottoLabel = {
        let label = LottoLabel(text: "20236월", font: .gmarketSans(size: .title2, weight: .bold))
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var switchButton: UIButton = {
        let button = UIButton()
        button.setTitle("주간", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var weekdayStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        return stackView
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.addSubview(self.monthLabel)
        self.addSubview(self.switchButton)
        self.addSubview(self.weekdayStackView)
        
        let days = ["일", "화", "수", "목", "금", "토", "월"]
        days.forEach { day in
            let dayLabel = LottoLabel(text: day, font: .gmarketSans(size: .subheadLine, weight: .medium))
            dayLabel.textColor = .designSystem(.gray63626B)
            dayLabel.textAlignment = .center
            self.weekdayStackView.addArrangedSubview(dayLabel)
        }
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            self.monthLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.monthLabel.topAnchor.constraint(equalTo: self.topAnchor),
            
            self.switchButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.switchButton.topAnchor.constraint(equalTo: self.topAnchor),
            
            self.weekdayStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.weekdayStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.weekdayStackView.topAnchor.constraint(equalTo: self.monthLabel.bottomAnchor, constant: 30),
            self.weekdayStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
