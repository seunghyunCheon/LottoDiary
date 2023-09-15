//
//  AddLottoViewController.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/15.
//

import UIKit

final class AddLottoViewController: UIViewController, AddLottoViewProtocol {
    var selectedDate: Date?
    private var halfModalTransitioningDelegate = HalfModalTransitioningDelegate()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupModalStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemYellow
    }
    
    private func setupModalStyle() {
        modalPresentationStyle = .custom
        modalTransitionStyle = .coverVertical
        transitioningDelegate = halfModalTransitioningDelegate
    }
}
