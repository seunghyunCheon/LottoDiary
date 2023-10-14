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
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            self.yearAndMonthView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constant.yearAndMonthLeading),
            self.yearAndMonthView.topAnchor.constraint(equalTo: self.topAnchor),
            
            self.scopeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.scopeButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.scopeButton.widthAnchor.constraint(equalToConstant: Constant.buttonWidth),
            self.scopeButton.heightAnchor.constraint(equalToConstant: Constant.buttonHeight),
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
    }
}
