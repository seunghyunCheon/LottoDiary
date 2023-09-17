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
    private let numberLabel: LottoLabel = {
        let label = LottoLabel(text: "", font: .gmarketSans(size: .subheadLine, weight: .bold))
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        label.backgroundColor = .clear
        return label
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel?.validateCellState(with: false)
    }
}
