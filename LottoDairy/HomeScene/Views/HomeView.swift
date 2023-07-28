//
//  HomeView.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/27.
//

import UIKit

final class HomeView: UIView {

    private let scrollView = UIScrollView()
    private let contentView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureScrollView()
        setupHomeStackView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureScrollView() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupHomeStackView() {
        let informationView = InformationView()
        let imageInformationView = ImageInformationView()
        contentView.addArrangedSubviews([informationView, imageInformationView])

        contentView.axis = .vertical
        contentView.spacing = 40
//        contentView.spacing = 20
//        let gap: CGFloat = frame.height * 0.06
//        let informationViewHeight: CGFloat = frame.height * 0.378
//
//        NSLayoutConstraint.activate([
//            informationView.topAnchor.constraint(equalTo: topAnchor),
//            informationView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            informationView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            informationView.heightAnchor.constraint(equalToConstant: informationViewHeight),
//
//            imageInformationStackView.topAnchor.constraint(equalTo: informationView.bottomAnchor, constant: gap),
//            imageInformationStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            imageInformationStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            imageInformationStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
    }
}
