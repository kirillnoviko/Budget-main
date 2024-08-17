//
//  TabBapController.swift
//  BudgetProject
//
//  Created by User on 19.05.24.
//

import UIKit

class TabBarController: UITabBarController {
   
    init(tabBarControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        for tab in tabBarControllers {
            self.addChild(tab)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = AppColors.background
        if let items = tabBar.items {
                    for item in items {
                        item.image = item.image?.withRenderingMode(.alwaysOriginal)
                        item.selectedImage = item.selectedImage?.withRenderingMode(.alwaysOriginal)
                    }
                }
        tabBar.itemPositioning = .centered
        tabBar.itemWidth = 24.0
        tabBar.itemSpacing = 60.0
        // Настройка UITabBar
        self.tabBar.barTintColor = AppColors.background
        self.tabBar.tintColor = AppColors.background  // Цвет выбранного элемента
          self.tabBar.unselectedItemTintColor = AppColors.background // Цвет невыбранных элементов
          
        // Удаление размытия и фона
        if let visualEffectView = self.tabBar.subviews.first(where: { $0 is UIVisualEffectView }) as? UIVisualEffectView {
            visualEffectView.effect = nil  // Удаляем эффект размытия
            visualEffectView.isHidden = true  // Скрываем сам visualEffectView
            
            // Проходимся по всем подвидам UIVisualEffectView
            for subview in visualEffectView.subviews {
                if String(describing: type(of: subview)).contains("_UIVisualEffectSubview") {
                    subview.isHidden = true  // Скрываем _UIVisualEffectSubview
                }
            }
        }
        
        // Обработка дополнительных подслоев
        self.tabBar.subviews.forEach { view in
            if view is UIImageView {
                view.isHidden = true  // Скрываем любые UIImageView, которые могут добавлять серый цвет
            }
        }

       
     }
     
    
   
}
