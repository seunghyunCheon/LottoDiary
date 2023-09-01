//
//  ChartInformationCell.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/02.
//

import UIKit

struct ChartInformationComponents {
    let image: UIImage
    let title: String
    var amount: String
    // 1, 2 : (달성 여부, nil)
    // 3 : (+/-, 금액)
    var result: (result: Bool, amount: String?)

    init(image: UIImage, type: ChartInformationType, amount: Int, result: (result: Bool, amount: String?)) {
        self.image = image
        self.title = type.rawValue
        self.amount = amount.convertToDecimal()
        self.result = result
    }

    enum ChartInformationType: String {
        case goal = "목표 금액"
        case buy = "구매 금액"
        case win = "당첨 금액"
    }
}

final class ChartInformationCell: UICollectionViewCell {

    var chartImformationComponents: ChartInformationComponents?

    init() {
        super.init(frame: .zero)
        self.backgroundColor = .yellow

        setupChartInformationCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with components: ChartInformationComponents) {
        self.chartImformationComponents = components
    }

    private func setupChartInformationCell() {
        let totalStackView = makeTotalStackView()
        self.addSubview(totalStackView)
    }

    private func makeTotalStackView() -> UIStackView {
        let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = chartImformationComponents?.image
            imageView.backgroundColor = .white
            return imageView
        }()

        let stackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [imageView])
            stackView.backgroundColor = .red
            stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            stackView.spacing = 10
            return stackView
        }()

        return stackView
    }

    private func makeInformationStackView() -> UIStackView {
        let titleLabel: UILabel = {
            let label = PretendardLabel
        }

        let InformationStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [])
            stackView.backgroundColor = .systemPink
            stackView.spacing = 5
            stackView.axis = .vertical
            return stackView
        }()

        return InformationStackView
    }
}



#if DEBUG
import SwiftUI
struct UIViewPreview<View: UIView>: UIViewRepresentable {
  let view: View

  init(_ content: @escaping () -> View) {
    view = content()
  }

  func makeUIView(context: Context) -> some UIView {
    return view
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {
    view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    view.setContentHuggingPriority(.defaultHigh, for: .vertical)
  }
}
#endif


// MARK: - Preview 사용 예시

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct CarouselCellPreview: PreviewProvider {
  static var previews: some View {
    UIViewPreview {
      let cell = ChartInformationCell()
        let components = ChartInformationComponents(
            image: .checkmark,
            type: .buy,
            amount: 2000,
            result: (true, nil))
      cell.configure(with: components)
      return cell
    }
    .frame(width: 300, height: 100) // 원하는 수치만큼 뷰 크기 조절 가능
    .previewLayout(.sizeThatFits)
  }
}
#endif
