//
//  HomeView.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/27.
//

import UIKit

final class HomeView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureHomeStackView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        setupHomeStackView()
    }

    private func setupHomeStackView() {
        let informationView = InformationView()
        let imageInformationStackView = ImageInformationStackView()
        addSubviews([informationView, imageInformationStackView])

        let gap: CGFloat = frame.height * 0.06
        let informationViewHeight: CGFloat = frame.height * 0.378

        NSLayoutConstraint.activate([
            informationView.topAnchor.constraint(equalTo: topAnchor),
            informationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            informationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            informationView.heightAnchor.constraint(equalToConstant: informationViewHeight),

            imageInformationStackView.topAnchor.constraint(equalTo: informationView.bottomAnchor, constant: gap),
            imageInformationStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageInformationStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageInformationStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func configureHomeStackView() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}
