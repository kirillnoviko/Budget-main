//
//  AppCoordinator.swift
//  FoodDeliveryApp
//
//  Created by Alexey Krzywicki on 29.01.2024.
//

import UIKit

class AppCoordinator: Coordinator {
    private let userStorage = UserStorage.shared
    private let factory = SceneFactory.self
    
    override func start() {
        
        if userStorage.passedOnboarding{
           showMainFlow()
        } else {
            showOnboardingFlow()
        }
        
        
    }
    
    override func finish() {
        print("AppCoordinator finish")
    
    }
    
}

// MARK: - Navigation methods
private extension AppCoordinator {
    func showOnboardingFlow() {
        guard let navigationController = navigationController else { return }
        let onboardingCoordinator = factory.makeOnboardingFlow(coordinator: self, finishDelegate: self, navigationController: navigationController)
        onboardingCoordinator.start()
    }
    func showMainFlow(){
        guard let navigationController = navigationController else {return}
        let tabBarController = factory.makeMainFlow(coordinator: self, finishDelegate: self)
        self.window?.rootViewController = tabBarController
    }

}
extension AppCoordinator : CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinatro: CoordinatorProtocol) {
        removeChildCoordinator(childCoordinatro)
        switch childCoordinatro.type{
        case .onboarding:
            showMainFlow()
            navigationController?.viewControllers = [navigationController?.viewControllers.last ?? UIViewController()]
           
        case .app:
            return
        default:
            navigationController?.popToRootViewController(animated: false)
        }
    }
    
}

