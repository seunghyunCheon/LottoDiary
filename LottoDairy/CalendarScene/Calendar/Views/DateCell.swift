//
//  DateCell.swift
//  LottoDairy
//
//  Created by Sunny on 2023/08/17.
//

import UIKit
import Combine

final class DateCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            self.viewModel?.validateCellState(with: isSelected)
        }
    }

    // MARK: Properties - View
    private let numberLabel: UILabel = {
        let label = GmarketSansLabel(size: .subheadLine, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        label.backgroundColor = .clear
        return label
    }()
    
    private let dot: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var viewModel: DateCellViewModel?
    
    var cancellables = Set<AnyCancellable>()

    // MARK: Lifecycle
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)

        setupDateCell()
    }

    // MARK: Functions - Public
    func provide(viewModel: DateCellViewModel) {
        self.viewModel = viewModel
        bindViewModel()
    }

    // MARK: Functions - Private
    private func setupDateCell() {
        contentView.addSubview(numberLabel)

        NSLayoutConstraint.activate([
            numberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            numberLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            numberLabel.widthAnchor.constraint(equalToConstant: 30),
            numberLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        contentView.addSubview(dot)
        dot.layer.cornerRadius = 2.5
        NSLayoutConstraint.activate([
            dot.centerXAnchor.constraint(equalTo: self.numberLabel.centerXAnchor),
            dot.topAnchor.constraint(equalTo: self.numberLabel.bottomAnchor, constant: 2),
            dot.widthAnchor.constraint(equalToConstant: 5),
            dot.heightAnchor.constraint(equalToConstant: 5),
        ])
    }
    
    private func bindViewModel() {
        viewModel?.$dateNumber
            .sink { [weak self] date in
                self?.numberLabel.text = date
            }
            .store(in: &cancellables)
        
        viewModel?.$cellState
            .sink { [weak self] state in
                switch state {
                case .none:
                    self?.numberLabel.backgroundColor = .clear
                    self?.numberLabel.textColor = .designSystem(.grayA09FA7)
                case .selected:
                    self?.numberLabel.backgroundColor = .designSystem(.gray63626B)
                    self?.numberLabel.textColor = .white
                case .today:
                    self?.numberLabel.backgroundColor = .designSystem(.mainBlue)
                    self?.numberLabel.textColor = .designSystem(.grayA09FA7)
                case .todaySelected:
                    self?.numberLabel.backgroundColor = .designSystem(.mainBlue)
                    self?.numberLabel.textColor = .white
                }
            }
            .store(in: &cancellables)
        

        viewModel?.$isIncludeInMonth
            .sink { [weak self] state in
                self?.numberLabel.textColor = state ? UIColor.designSystem(.grayA09FA7) : UIColor.designSystem(.gray63626B)
            }
            .store(in: &cancellables)
        
        viewModel?.$hasLotto
            .sink { [weak self] state in
                if state {
                    self?.dot.backgroundColor = .systemGreen
                } else {
                    self?.dot.backgroundColor = .clear
                }
            }
            .store(in: &cancellables)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel?.validateCellState(with: false)
    }
}
