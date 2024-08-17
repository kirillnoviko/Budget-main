//
//  BudgetCoordinator.swift
//  BudgetProject
//
//  Created by User on 19.05.24.
//
import UIKit

class BudgetCoordinator: Coordinator {
    
    private let factory = SceneFactory.self
   
    override func start() {
        showBudgetScene()

    }
    
    override func finish() {
        print("OnboardingCoordinator finish")
        
    }
    
}

extension BudgetCoordinator{
    func showBudgetScene(){
//        guard let navigationController = navigationController else { return }
//        let vc =  factory.makeBudgetScene(coordinator: self)
//
//
//        navigationController.pushViewController(vc, animated: true)
        
        guard let navigationController = navigationController else { return }
        let storyboard = UIStoryboard(name: "BudgetLayer", bundle: nil)
                guard let viewController = storyboard.instantiateViewController(withIdentifier: "BudgetViewController") as? BudgetViewController else {
                    fatalError("ViewController not found")
                }

                viewController.coordinator = self
                navigationController.pushViewController(viewController, animated: true)
           
    }
}
