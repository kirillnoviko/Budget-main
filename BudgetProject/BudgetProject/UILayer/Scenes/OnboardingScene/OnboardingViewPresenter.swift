//
//  OnboardingViewPresenter.swift
//  BudgetProject
//
//  Created by User on 19.05.24.
//

import Foundation


protocol OnboardingViewOutput: AnyObject {
    func onboardingFinish ()
}

class OnboardingViewPresenter : OnboardingViewOutput{
    
    private var userStorage = UserStorage.shared
    
    //MARK: -properties
     weak var coordinator: OnboardingCoordinator!
    
    init(coordinator: OnboardingCoordinator!) {
        self.coordinator = coordinator
    }
    
    func onboardingFinish() {
        userStorage.passedOnboarding = true
        coordinator.finish()
    }
    
}



