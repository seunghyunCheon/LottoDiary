//
//  ImageInformationStackView.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/28.
//

import UIKit

final class ImageInformationStackView: UIView {

    private let imageLabel: UILabel = {
        let label = GmarketSansLabel(text: "이 돈이면", alignment: .left, size: .title3, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let imageView: UIImageView = {
        let image = UIImage(systemName: "photo")
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let imageExplanationView: UIView = {
        let view = DoubleLabelView(first: "78000원으로", second: "국밥 7.8개 그릇먹기 가능", alignment: .center)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init() {
        super.init(frame: .zero)

        configureImageInformationStackView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        setupImageInformationStackView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupImageInformationStackView() {
        addSubviews([imageLabel, imageView, imageExplanationView])

        let topAchorGap: CGFloat = frame.height * 0.04
        let imageViewHeight: CGFloat = frame.height * 0.52

        NSLayoutConstraint.activate([
            imageLabel.topAnchor.constraint(equalTo: topAnchor),
            imageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            imageView.topAnchor.constraint(equalTo: imageLabel.bottomAnchor, constant: topAchorGap),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: imageViewHeight),

            imageExplanationView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: topAchorGap),
            imageExplanationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageExplanationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageExplanationView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func configureImageInformationStackView() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}
