//
//  GoalSettingCoordinator.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/17.
//

protocol GoalSettingCoordinatorFinishable: AnyObject {
    var finishFlow: (() -> Void)? { get set }
}

final class GoalSettingCoordinator: BaseCoordinator, GoalSettingCoordinatorFinishable {
    
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
        var goalSettingModule = factory.makeGoalSettingFlow()
        
        goalSettingModule.onMain = { [weak self] in
            self?.finishFlow?()
        }
        
        router.setRootModule(goalSettingModule)
    }
}
