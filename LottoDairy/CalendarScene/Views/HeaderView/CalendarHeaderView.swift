//
//  CalendarWeekView.swift
//  LottoDairy
//
//  Created by Brody on 2023/08/18.
//

import UIKit
import Combine

protocol CalendarHeaderViewDelegate {
    func scopeSwitchButtonTapped(with: ScopeType)
}

final class CalendarHeaderView: UIView {
    
    // MARK: - UIView
    var yearAndMonthView: YearAndMonthView = {
        let stackView = YearAndMonthView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var scopeButton: ScopeButton = {
        let scopeButton = ScopeButton()
        scopeButton.translatesAutoresizingMaskIntoConstraints = false
        
        return scopeButton
    }()
    
    var weekdayStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        return stackView
    }()
    
    private var scopeType: ScopeType = .month
    
    var delegate: CalendarHeaderViewDelegate?
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        scopeButton.delegate = self
        self.addSubview(self.yearAndMonthView)
        self.addSubview(self.scopeButton)
        self.addSubview(self.weekdayStackView)
        
        let days = ["일", "월", "화", "수", "목", "금", "토"]
        days.forEach { day in
            let dayLabel = LottoLabel(text: day, font: .gmarketSans(size: .subheadLine, weight: .medium))
            dayLabel.textColor = .designSystem(.gray63626B)
            dayLabel.textAlignment = .center
            self.weekdayStackView.addArrangedSubview(dayLabel)
        }
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            self.yearAndMonthView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constant.yearAndMonthLeading),
            self.yearAndMonthView.topAnchor.constraint(equalTo: self.topAnchor),
            
            self.scopeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.scopeButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.scopeButton.widthAnchor.constraint(equalToConstant: Constant.buttonWidth),
            self.scopeButton.heightAnchor.constraint(equalToConstant: Constant.buttonHeight),
            
            self.weekdayStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.weekdayStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.weekdayStackView.topAnchor.constraint(equalTo: self.yearAndMonthView.bottomAnchor, constant: Constant.weekdayBottom),
            self.weekdayStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
    }
}

extension CalendarHeaderView: ScopeChangeDelegate {
    func changeState() {
        self.scopeType = (scopeType == .month) ? .week : .month
        self.delegate?.scopeSwitchButtonTapped(with: self.scopeType)
        self.scopeButton.changeStateView(with: self.scopeType)
    }
}

extension CalendarHeaderView {
    private enum Constant {
        static let buttonWidth: CGFloat = 90
        static let buttonHeight: CGFloat = 30
        static let yearAndMonthLeading: CGFloat = 15
        static let weekdayBottom: CGFloat = 30
    }
}
