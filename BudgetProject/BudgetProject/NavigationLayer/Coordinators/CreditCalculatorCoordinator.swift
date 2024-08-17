//
//  CreditCalculatorCoordinator.swift
//  BudgetProject
//
//  Created by User on 19.05.24.
//

import UIKit

class CreditCalculatorCoordinator: Coordinator {
    
    
   
    override func start() {
        showCreditScene()
    }
    
    override func finish() {
        print("OnboardingCoordinator finish")
        
    }
    
}
extension CreditCalculatorCoordinator{
    func showCreditScene(){
    
        guard let navigationController = navigationController else { return }
        let storyboard = UIStoryboard(name: "CreditCalculatorLayer", bundle: nil)
                guard let viewController = storyboard.instantiateViewController(withIdentifier: "CreditCalculatorControlller") as? CreditCalculatorControlller else {
                    fatalError("ViewController not found")
                }

                viewController.coordinator = self
                navigationController.pushViewController(viewController, animated: true)
           
    }
}
