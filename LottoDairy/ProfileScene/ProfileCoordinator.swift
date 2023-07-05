//
//  ProfileCoordinator.swift
//  LottoDairy
//
//  Created by Sunny on 2023/06/30.
//

protocol ProfileCoordinatorFinishable: AnyObject {
    var finishFlow: (() -> Void)? { get set }
}

final class ProfileCoordinator: BaseCoordinator, ProfileCoordinatorFinishable {
    var finishFlow: (() -> Void)?
}
