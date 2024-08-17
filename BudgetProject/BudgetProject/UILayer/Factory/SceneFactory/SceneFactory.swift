
import UIKit

struct SceneFactory{
    
    // MARK: - onboarding
    static func makeOnboardingFlow(coordinator: AppCoordinator, finishDelegate: CoordinatorFinishDelegate, navigationController: UINavigationController) -> OnboardingCoordinator{
        let onboardingCoordinator = OnboardingCoordinator(type: .onboarding, navigationController: navigationController, finishDelegate: finishDelegate)
        coordinator.addChildCoordinator(onboardingCoordinator)
        return onboardingCoordinator
    }
    
    static func makeMainFlow(coordinator: AppCoordinator, finishDelegate: CoordinatorFinishDelegate) -> TabBarController{
        
        
        let budgetNavigationController = UINavigationController()
        budgetNavigationController.tabBarItem = UITabBarItem(title: "", image: UIImage(resource: .artificialIntelligence).withRenderingMode(.alwaysOriginal), selectedImage: UIImage(resource: .artificialIntelligenceActive).withRenderingMode(.alwaysOriginal))
        let budgetCoordinator = BudgetCoordinator(type: .budget, navigationController: budgetNavigationController)
        budgetCoordinator.finishDelegate = finishDelegate
        budgetCoordinator.start()
        
      
  
        let creditCalculatorNavigationController = UINavigationController()
        creditCalculatorNavigationController.tabBarItem = UITabBarItem(title: "", image: UIImage(resource: .balanceSheet).withRenderingMode(.alwaysOriginal), selectedImage: UIImage(resource: .balanceSheetActive).withRenderingMode(.alwaysOriginal))
        let creditCalculatorCoordinator = CreditCalculatorCoordinator(type: .creditCalculator, navigationController: creditCalculatorNavigationController)
        creditCalculatorCoordinator.finishDelegate = finishDelegate
        creditCalculatorCoordinator.start()
        
        
        let aiHelperNavigationController = UINavigationController()
        aiHelperNavigationController.tabBarItem = UITabBarItem(title: "", image: UIImage(resource: .pieChart).withRenderingMode(.alwaysOriginal),selectedImage: UIImage(resource: .pieChartActive).withRenderingMode(.alwaysOriginal))
        let aiHelperCoordinator = AiHelperCoordinator(type: .aiHelper, navigationController: aiHelperNavigationController)
        aiHelperCoordinator.finishDelegate = finishDelegate
        aiHelperCoordinator.start()
        
        
        let settingNavigationController = UINavigationController()
        settingNavigationController.tabBarItem = UITabBarItem(title: "", image: UIImage(resource: .settings).withRenderingMode(.alwaysOriginal),selectedImage: UIImage(resource: .settingsActive).withRenderingMode(.alwaysOriginal))
        let settingCoordinator = SettingCoordinator(type: .setting, navigationController: settingNavigationController)
        settingCoordinator.finishDelegate = finishDelegate
        settingCoordinator.start()
        
        coordinator.addChildCoordinator(budgetCoordinator)
        coordinator.addChildCoordinator(creditCalculatorCoordinator)
        coordinator.addChildCoordinator(aiHelperCoordinator)
        coordinator.addChildCoordinator(settingCoordinator)
         
        let tabBarControllers = [budgetNavigationController, creditCalculatorNavigationController, aiHelperNavigationController, settingNavigationController]
        let tabBarController = TabBarController(tabBarControllers: tabBarControllers)
      
        return tabBarController
    }
    
 
    static func makeOnboardingScene(coordinator: OnboardingCoordinator) -> OnboardingViewController {
        var pages = [OnboardingViewPartController]()
        
        let firstVC = OnboardingViewPartController()
        firstVC.imageToShow = UIImage(resource: .onboardingImage1)
        firstVC.titleText = "Track Your Financial Health"
        firstVC.descriptionText = "Monitor your income and expenses effortlessly to gain insights into your financial habits and manage your budget effectively."
        firstVC.buttonText = "Continue"
        firstVC.view.backgroundColor = AppColors.background
        
        
        let secondVC = OnboardingViewPartController()
        secondVC.imageToShow = UIImage(resource: .onboardingImage2Pdf)
        secondVC.titleText = "Calculate Your Financial Potential"
        secondVC.descriptionText = "Utilize our loan calculator to estimate loan payments, analyze different scenarios, and make informed borrowing decisions."
        secondVC.buttonText = "Continue"
        secondVC.view.backgroundColor = AppColors.background
        
        let thirdVC = OnboardingViewPartController()
        thirdVC.imageToShow = UIImage(resource: .onboardingImage3)
        thirdVC.titleText = "Personalized Financial Guidance "
        thirdVC.descriptionText = "Engage in conversations with our GPT-powered chat to receive tailored financial advice and recommendations based on your unique financial situation."
        thirdVC.buttonText =  "Let's start"
        thirdVC.view.backgroundColor = AppColors.background
       
      
        pages.append(firstVC)
        pages.append(secondVC)
        pages.append(thirdVC)
        
        let presenter = OnboardingViewPresenter(coordinator: coordinator)
        let viewController = OnboardingViewController( pages: pages, viewOutput: presenter)
       
        return viewController
    }

    
    static func makeBudgetScene(coordinator: BudgetCoordinator) -> BudgetViewController{
        let controller = BudgetViewController()
        return controller
    }
}
