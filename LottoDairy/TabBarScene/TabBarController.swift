//
//  TabbarController.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/05.
//

import UIKit
import AVFoundation

final class TabBarController: UITabBarController, TabBarFlowProtocol {
    
    var onViewWillAppear: ((UINavigationController) -> ())?
    
    var onHomeFlowSelect: ((UINavigationController) -> ())?
    
    var onLottoQRFlowSelect: ((UINavigationController) -> ())?

    var onCalendarFlowSelect: ((UINavigationController) -> ())?

    var onChartFlowSelect: ((UINavigationController) -> ())?

    var onRandomNumberFlowSelect: ((UINavigationController) -> ())?

    var onPermissionDeniedAlert: ((UINavigationController, UIAlertController) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
        configureViewControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let controller = viewControllers?[1] as? UINavigationController {
            onViewWillAppear?(controller)
        }
    }
    
    private func configureTabBar() {
        let tabBarView = TabBarView(frame: tabBar.frame)
        tabBarView.lottoQRDelegate = self
        setValue(tabBarView, forKey: "tabBar")
        delegate = self
    }
    
    private func configureViewControllers() {
        viewControllers = TabBarComponents.allCases.map { makeTabBarNavigationControllers($0) }
        selectedIndex = TabBarComponents.home.rawValue
    }
    
    private func makeTabBarNavigationControllers(_ type: TabBarComponents) -> UINavigationController {
        let viewController = UINavigationController()
        viewController.tabBarItem.title = type.title
        viewController.tabBarItem.image = UIImage(systemName: type.systemName)
        return viewController
    }
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let controller = viewControllers?[selectedIndex] as? UINavigationController else { return }

        switch TabBarComponents(rawValue: selectedIndex) {
        case .calendar:
            onCalendarFlowSelect?(controller)
        case .home:
            onHomeFlowSelect?(controller)
        case .chart:
            onChartFlowSelect?(controller)
        case .numbers:
            onRandomNumberFlowSelect?(controller)
        default:
            break
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return true
        }
        return TabBarComponents(rawValue: selectedIndex) == .lottoQR ? false : true
    }
}

extension TabBarController: LottoQRButtonDelegate {

    func lottoQRButtonDidTap() {
        Task {
            await self.requestCameraPermission()
        }
    }

    private func requestCameraPermission() async {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)

        switch cameraAuthorizationStatus {
        case .notDetermined:
            await self.requestCameraAccess()
        case .restricted, .denied:
            self.showCameraPermissionDeniedAlert()
        case .authorized:
            self.selectedLottoQR()
        @unknown default:
            break
        }
    }

    private func requestCameraAccess() async {
        if await AVCaptureDevice.requestAccess(for: .video) {
            self.selectedLottoQR()
        } else {
            self.showCameraPermissionDeniedAlert()
        }
    }

    private func showCameraPermissionDeniedAlert() {
        let alert = UIAlertController(
            title: StringLiteral.CameraAlert.title,
            message: StringLiteral.CameraAlert.message,
            preferredStyle: .alert
        )

        let okButton = UIAlertAction(title: StringLiteral.CameraAlert.okTitle, style: .default)

        let settingButton = UIAlertAction(
            title: StringLiteral.CameraAlert.settingTitle,
            style: .default) { action in
            if let settingURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingURL)
            }
        }

        alert.addAction(okButton)
        alert.addAction(settingButton)

        guard let controller = self.selectedViewController as? UINavigationController else { return }
        onPermissionDeniedAlert?(controller, alert)
    }

    private func selectedLottoQR() {
        guard let controller = self.viewControllers?[TabBarComponents.lottoQR.rawValue] as? 
                UINavigationController else { return }
        onLottoQRFlowSelect?(controller)

        self.selectedIndex = TabBarComponents.lottoQR.rawValue
    }
}

extension TabBarController {

    private enum StringLiteral {

        enum CameraAlert {
            static let title = "카메라 권한이 거부되었어요."
            static let message = "설정>로또다이어리에서 카메라 권한을 허용해주세요."
            static let okTitle = "닫기"
            static let settingTitle = "설정으로 이동하기"
        }
    }
}
