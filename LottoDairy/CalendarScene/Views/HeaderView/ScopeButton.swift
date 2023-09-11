//
//  ScopeButton.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/08.
//

import UIKit

protocol ScopeChangeDelegate: AnyObject {
    func changeState()
}

final class ScopeButton: UIView {
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.text = "월간"
        label.font = .gmarketSans(size: .subheadLine, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let weekLabel: UILabel = {
        let label = UILabel()
        label.text = "주간"
        label.font = .gmarketSans(size: .subheadLine, weight: .bold)
        label.textColor = .designSystem(.gray63626B)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let stateView: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.mainBlue)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var stateViewLeadingConstraint: NSLayoutConstraint!
    private var stateViewTrailingContraint: NSLayoutConstraint!
    
    weak var delegate: ScopeChangeDelegate?
    
    init() {
        super.init(frame: .zero)
        setupRootView()
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.size.height / Constant.cornerRadius
        self.stateView.layer.cornerRadius = self.frame.size.height / Constant.cornerRadius
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.changeState()
    }
    
    func changeStateView(with state: ScopeType) {
        switch state {
            case .month:
                stateView.backgroundColor = .designSystem(.mainBlue)
                monthLabel.textColor = .white.withAlphaComponent(Constant.activeAlpha)
                weekLabel.textColor = .white.withAlphaComponent(Constant.inActiveAlpha)
                stateViewLeadingConstraint.constant = Constant.monthScopeLeading
            case .week:
                stateView.backgroundColor = .designSystem(.mainOrange)
                weekLabel.textColor = .white.withAlphaComponent(Constant.activeAlpha)
                monthLabel.textColor = .white.withAlphaComponent(Constant.inActiveAlpha)
                stateViewLeadingConstraint.constant = Constant.weekScopeLeading
        }
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.layoutIfNeeded()
        }
    }

    
    private func setupRootView() {
        self.addSubview(stateView)
        self.addSubview(labelStackView)
        labelStackView.addArrangedSubview(monthLabel)
        labelStackView.addArrangedSubview(weekLabel)
    }
    
    private func setupLayout() {
        self.backgroundColor = .black
        
        stateViewLeadingConstraint = stateView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constant.monthScopeLeading)
        
        NSLayoutConstraint.activate([
            stateViewLeadingConstraint,
            stateView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constant.stateTopMargin),
            stateView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: Constant.stateBottomMargin),
            stateView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: Constant.stateWidth),
            
            labelStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            labelStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

extension ScopeButton {
    private enum Constant {
        static let cornerRadius = 2.5
        static let stateTopMargin: CGFloat = 2.0
        static let stateBottomMargin: CGFloat = -2.0
        static let stateWidth: CGFloat = 1/2-0.03
        static let monthScopeLeading: CGFloat = 2.0
        static let weekScopeLeading: CGFloat = 46.0
        static let activeAlpha: CGFloat = 1.0
        static let inActiveAlpha: CGFloat = 1.0
    }
}
