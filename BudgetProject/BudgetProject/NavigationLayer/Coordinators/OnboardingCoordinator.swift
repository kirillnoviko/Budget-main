//
//  OnboardingCoordinator.swift
//  FoodDeliveryApp
//
//  Created by Alexey Krzywicki on 29.01.2024.
//

import UIKit

class OnboardingCoordinator: Coordinator {
    
    private let factory = SceneFactory.self
    
   
    override func start() {
        showOnboarding()
    }
    
    override func finish() {
        print("OnboardingCoordinator finish")
        finishDelegate?.coordinatorDidFinish(childCoordinatro: self)
    }
    
    
}
private extension OnboardingCoordinator{
    func showOnboarding(){
        
        let viewController = factory.makeOnboardingScene(coordinator: self)
        navigationController?.pushViewController(viewController, animated: true)

    }
}


