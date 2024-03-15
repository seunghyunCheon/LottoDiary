//
//  LastLottoNumberCell.swift
//  LottoDairy
//
//  Created by Sunny on 3/15/24.
//

import UIKit

final class LastLottoNumberCell: UITableViewCell {
    static let cellId = "LastLottoNumberCell"

    private let roundNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .gmarketSans(size: .title3, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(round: String, numbers: [Int]) {
        roundNumberLabel.text = "\(round)회"
        
        let lottoNumbers = LottoNumbersView(numbers: numbers, isAnimation: false)
        self.setup(lottoNumberView: lottoNumbers)
    }
}

// MARK: Layout
extension LastLottoNumberCell {
    private func setup(lottoNumberView: UIView) {
        self.addSubviews([roundNumberLabel])
        NSLayoutConstraint.activate([
            roundNumberLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 14),
            roundNumberLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14)
        ])

        self.addSubview(lottoNumberView)
        NSLayoutConstraint.activate([
            lottoNumberView.topAnchor.constraint(equalTo: roundNumberLabel.bottomAnchor, constant: 30)
        ])
    }
}
