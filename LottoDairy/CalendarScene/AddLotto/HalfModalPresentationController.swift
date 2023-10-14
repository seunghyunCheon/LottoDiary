//
//  HalfModalPresentationController.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/15.
//

import UIKit

final class HalfModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        return HalfModalPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
}

final class HalfModalPresentationController: UIPresentationController {
    
    let blurEffectView: UIVisualEffectView!
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView.isUserInteractionEnabled = true
        self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let screenBounds = UIScreen.main.bounds
        let size = CGSize(width: screenBounds.width, height: screenBounds.height * 0.5)
        let origin = CGPoint(x: .zero, y: screenBounds.height * 0.5)
        
        return CGRect(origin: origin, size: size)
    }
    
    override func presentationTransitionWillBegin() {
        self.blurEffectView.alpha = 0
        self.containerView?.addSubview(blurEffectView)
        self.presentedViewController.transitionCoordinator?.animate(
            alongsideTransition: { _ in self.blurEffectView.alpha = 0.3},
            completion: nil
        )
    }
    
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(
            alongsideTransition: { _ in self.blurEffectView.alpha = 0},
            completion: { _ in self.blurEffectView.removeFromSuperview() }
        )
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        guard let presentedView = self.presentedView else {
            return
        }
        
        blurEffectView.frame = containerView!.bounds
        presentedView.roundCorners(corners: [.topLeft, .topRight], radius: 15)
    }
    
    @objc
    func dismissController() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
}

fileprivate extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         layer.mask = mask
     }
 }
