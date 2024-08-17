//
//  SettingCoordinator.swift
//  BudgetProject
//
//  Created by User on 19.05.24.
//

import UIKit

class SettingCoordinator: Coordinator {
    
    
   
    
    override func start() {
        showSettingScene()
    }
    
    override func finish() {
        print("OnboardingCoordinator finish")
        
    }
    
}
extension SettingCoordinator{
    func showSettingScene(){
    
        guard let navigationController = navigationController else { return }
        let storyboard = UIStoryboard(name: "SettingLayer", bundle: nil)
                guard let viewController = storyboard.instantiateViewController(withIdentifier: "SettingContrller") as? SettingContrller else {
                    fatalError("ViewController not found")
                }

                viewController.coordinator = self
                navigationController.pushViewController(viewController, animated: true)
           
    }
}
