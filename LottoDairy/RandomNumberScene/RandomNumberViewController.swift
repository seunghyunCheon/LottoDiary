//
//  RandomNumberViewController.swift
//  LottoDairy
//
//  Created by Sunny on 3/14/24.
//

import UIKit

final class RandomNumberViewController: UIViewController, RandomNumberFlowProtocol {
    private let randomNumberTitle: UILabel = {
        let label = UILabel()
        label.text = "이번주 추천 번호는?"
        label.textColor = .white
        label.font = .gmarketSans(size: .title1, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let lastNumberTitle: UILabel = {
        let label = UILabel()
        label.text = "지난 회차 번호는?"
        label.textColor = .designSystem(.white)
        label.font = .gmarketSans(size: .title1, weight: .bold)
        label.textAlignment = .left
        return label
    }()

    private let numberBackgroundView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .designSystem(.gray2B2C35)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let numberView = LottoNumbersView()

    private lazy var changeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("새로운 번호 섞기", for: .normal)
        button.titleLabel?.font = .gmarketSans(size: .body, weight: .bold)
        button.tintColor = .white
        button.backgroundColor = .designSystem(.mainOrange)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = "위 번호는 컴퓨터가 무작위로 조합한 숫자로,\n당첨과 아무런 연관이 없음을 밝힙니다."
        label.numberOfLines = 2
        label.textColor = .white
        label.font = .gmarketSans(size: .callout, weight: .light)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let lastNumbersView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .designSystem(.gray2B2C35)
        return view
    }()

    lazy var lastLottoNumberTabelView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
//        tableView.register(LastLottoNumberTableViewCell.self, forCellReuseIdentifier: LastLottoNumberTableViewCell.cellId)
//        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = DeviceInfo.screenHeight / 10
        return tableView
    }()

    var lastDrawNumberButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회차 번호 더보기", for: .normal)
        button.titleLabel?.font = .gmarketSans(size: .body, weight: .bold)
        button.tintColor = .white
        button.backgroundColor = .designSystem(.mainBlue)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .designSystem(.backgroundBlack)

        self.setup()
    }

    @objc func changeButtonTapped() {
        numberView.updateLottoNumbers()
    }
}

//extension NumberDrawViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return LottoData.lastDrawDatas.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: LastLottoNumberTableViewCell.cellId, for: indexPath) as? LastLottoNumberTableViewCell else { return UITableViewCell() }
//        cell.lottoData = LottoData.lastDrawDatas[indexPath.row]
//        cell.selectionStyle = .none
//        return cell
//    }
//}

// MARK: Layout
extension RandomNumberViewController {
    private func setup() {
        self.view.addSubview(randomNumberTitle)
        NSLayoutConstraint.activate([
            randomNumberTitle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            randomNumberTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20)
        ])

        self.view.addSubview(numberBackgroundView)
        NSLayoutConstraint.activate([
            numberBackgroundView.topAnchor.constraint(equalTo: randomNumberTitle.bottomAnchor, constant: 14),
            numberBackgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 14),
            numberBackgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -14),
            numberBackgroundView.heightAnchor.constraint(equalToConstant: 172)
        ])

        numberBackgroundView.addSubviews([numberView, changeButton, warningLabel])
        let numberViewTopPadding: CGFloat = 22 + LottoBall.Constant.ballSize / 2
        NSLayoutConstraint.activate([
            numberView.topAnchor.constraint(equalTo: numberBackgroundView.topAnchor, constant: numberViewTopPadding),
            numberView.leadingAnchor.constraint(equalTo: numberBackgroundView.leadingAnchor),
            numberView.trailingAnchor.constraint(equalTo: numberBackgroundView.trailingAnchor),

            changeButton.trailingAnchor.constraint(equalTo: numberBackgroundView.trailingAnchor, constant: -14),
            changeButton.topAnchor.constraint(equalTo: numberView.bottomAnchor, constant: numberViewTopPadding),
            changeButton.widthAnchor.constraint(equalToConstant: 142),
            changeButton.heightAnchor.constraint(equalToConstant: 32),

            warningLabel.trailingAnchor.constraint(equalTo: numberBackgroundView.trailingAnchor, constant: -14),
            warningLabel.bottomAnchor.constraint(equalTo: numberBackgroundView.bottomAnchor, constant: -14)
        ])

//        view.addSubview(lastNumberTitle)
//        lastNumberTitle.snp.makeConstraints { make in
//            make.leading.equalToSuperview().inset(14)
//            make.top.equalTo(randomNumberDrawView.snp.bottom).offset(30)
//            make.height.equalTo(23)
//        }
//
//        view.addSubview(lastNumbersView)
//        lastNumbersView.snp.makeConstraints { make in
//            make.top.equalTo(lastNumberTitle.snp.bottom).offset(13)
//            make.leading.trailing.equalToSuperview().inset(14)
//            make.bottom.equalToSuperview().inset(150)
//        }
//
//        lastNumbersView.addSubview(lastLottoNumberTabelView)
//        lastLottoNumberTabelView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//
//        lastNumbersView.addSubview(lastDrawNumberButton)
//        lastDrawNumberButton.snp.makeConstraints { make in
//            make.trailing.equalToSuperview().inset(14)
//            make.bottom.equalToSuperview().inset(14)
//            make.height.equalTo(32)
//            make.width.equalTo(142)
//        }
    }
}

#if DEBUG
import SwiftUI
struct ViewController_Previews: PreviewProvider {   // 이름 바꿔도 됨
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }

    struct Container: UIViewControllerRepresentable {

        func makeUIViewController(context: Context) -> UIViewController {
            return RandomNumberViewController()    // <- 미리 볼 뷰컨 인스턴스
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    }
}
#endif
