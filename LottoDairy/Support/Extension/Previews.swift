//
//  Previews.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/27.
//

//#if DEBUG
//import SwiftUI
//struct UIViewPreview<View: UIView>: UIViewRepresentable {
//  let view: View
//
//  init(_ content: @escaping () -> View) {
//    view = content()
//  }
//
//  func makeUIView(context: Context) -> some UIView {
//    return view
//  }
//
//  func updateUIView(_ uiView: UIViewType, context: Context) {
//    view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//    view.setContentHuggingPriority(.defaultHigh, for: .vertical)
//  }
//}
//#endif
//
//
//// MARK: - Preview 사용 예시
//
//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//struct CarouselCellPreview: PreviewProvider {
//  static var previews: some View {
//    UIViewPreview {
//      let cell = MoneyInformationStackView()
//      return cell
//    }
//    .frame(width: 370, height: 80) // 원하는 수치만큼 뷰 크기 조절 가능
//    .previewLayout(.sizeThatFits)
//  }
//}
//#endif


// 1. 미리 볼 뷰컨 파일 상단에 'import SwiftUI'
// 2. 미리 볼 뷰컨 파일 하단에 아래 코드 복붙

//#if DEBUG
//import SwiftUI
//struct ViewController_Previews: PreviewProvider {   // 이름 바꿔도 됨
//
//    static var previews: some View {
//        Container().edgesIgnoringSafeArea(.all)
//    }
//
//    struct Container: UIViewControllerRepresentable {
//
//        func makeUIViewController(context: Context) -> UIViewController {
//            return DashboardViewController()    // <- 미리 볼 뷰컨 인스턴스
//        }
//
//        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//
//        }
//
//    }
//
//}
//#endif
