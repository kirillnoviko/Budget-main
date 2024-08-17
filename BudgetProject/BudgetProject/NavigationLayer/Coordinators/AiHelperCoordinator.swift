//
//  AiHelperCoordinator.swift
//  BudgetProject
//
//  Created by User on 19.05.24.
//
import UIKit

class AiHelperCoordinator: Coordinator {
    
    
    override func start() {
        showAIHelperScene()
    }
    
    override func finish() {
        print("OnboardingCoordinator finish")
        
    }
    
}
extension AiHelperCoordinator{
    func showAIHelperScene(){
    
        guard let navigationController = navigationController else { return }
        let storyboard = UIStoryboard(name: "AIHelperLayer", bundle: nil)
                guard let viewController = storyboard.instantiateViewController(withIdentifier: "AIHelperController") as? AIHelperController else {
                    fatalError("ViewController not found")
                }

                viewController.coordinator = self
                navigationController.pushViewController(viewController, animated: true)
           
    }
}

