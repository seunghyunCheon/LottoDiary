//
//  ProfileCoordinator.swift
//  LottoDairy
//
//  Created by Sunny on 2023/06/30.
//

protocol ProfileCoordinatorOutput: AnyObject {
  var finishFlow: (() -> Void)? { get set }
}

final class ProfileCoordinator: BaseCoordinator, ProfileCoordinatorOutput {
    var finishFlow: (() -> Void)?
}
