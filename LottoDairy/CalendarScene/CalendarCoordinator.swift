//
//  CalendarCoordinator.swift
//  LottoDairy
//
//  Created by Sunny on 2023/08/17.
//

final class CalendarCoordinator: BaseCoordinator {

    private let router: Router
    private let moduleFactory: CalendarModuleFactory
    private let coordinatorFactory: CoordinatorFactory
//    private let canlderFlow:

    init(router: Router, moduleFactory: CalendarModuleFactory, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
    }

    override func start() {
        var calendarFlow = moduleFactory.makeCalendarFlow()
        // footer 내부에 바인드를 넣는다면 함수를 넣는 것일텐데 이 방법보다 제스처를 이용하는 게 나아보임.
        // 여기서 onAddLotto함수를 호출해서 라우터에 보여지게한다.
        // 확인을 누르면 데이터가 저장되고 노티에 post를 한다.
        // 노티에서 받는건 snapshot업데이트 하는 부분.
        // 그러니까 로또 뷰컨에 post를 감지하는 부분이 필요함.
        // 노티를 쓴다면 뷰모델에서 바로 bind함수 안에 넣으면 됨.
        // calendarFlow.onAddLotto {
        
        // }
        calendarFlow.onAddLotto = { [weak self] in
            self?.presentAddLotto()
        }
        router.setRootModule(calendarFlow)
    }
    
    func presentAddLotto() {
        var addLottoView = moduleFactory.makeAddLottoView()
        
        router.present(addLottoView, animated: true)
    }
}
