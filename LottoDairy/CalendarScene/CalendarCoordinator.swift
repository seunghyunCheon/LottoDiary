//
//  CalendarCoordinator.swift
//  LottoDairy
//
//  Created by Sunny on 2023/08/17.
//

import Foundation

final class CalendarCoordinator: BaseCoordinator {

    private let router: Router
    private let moduleFactory: CalendarModuleFactory
    private let coordinatorFactory: CoordinatorFactory
    private var calendarFlow: CalendarFlowProtocol?

    init(router: Router, moduleFactory: CalendarModuleFactory, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
    }

    override func start() {
        calendarFlow = moduleFactory.makeCalendarFlow()
        calendarFlow?.onAddLotto = { [weak self] currentDate in
            self?.presentAddLotto(with: currentDate)
        }
        router.setRootModule(calendarFlow)
    }
    
    func presentAddLotto(with date: Date) {
        var addLottoView = moduleFactory.makeAddLottoView()
        addLottoView.selectedDate = date
        addLottoView.onCalendar = { [weak self] lotto in
            guard let self else { return }
            self.calendarFlow?.addLotto()
            self.router.dismissModule(animated: true, completion: nil)
        }
        router.present(addLottoView, animated: true)
    }
}
