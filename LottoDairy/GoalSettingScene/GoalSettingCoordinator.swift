//
//  GoalSettingCoordinator.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/17.
//

protocol GoalSettingCoordinatorFinishable: AnyObject {
    var isEdit: Bool? { get set }
    var finishFlow: (() -> Void)? { get set }
}

final class GoalSettingCoordinator: BaseCoordinator, GoalSettingCoordinatorFinishable {

    var isEdit: Bool?
    var finishFlow: (() -> Void)?
    private let factory: GoalSettingModuleFactory
    private let router: Router
    
    init(router: Router, factory: GoalSettingModuleFactory) {
        self.factory = factory
        self.router = router
    }
    
    override func start() {
        showGoalSetting()
    }
    
    private func showGoalSetting() {
        guard let isEdit = isEdit else { return }
        var goalSettingModule = factory.makeGoalSettingFlow(isEdit: isEdit)

        goalSettingModule.onMain = { [weak self] in
            self?.finishFlow?()
        }
        
        router.setRootModule(goalSettingModule)
    }
}
