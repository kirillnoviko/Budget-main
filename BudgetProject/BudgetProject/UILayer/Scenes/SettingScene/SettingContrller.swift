import Foundation
import UIKit
class SettingContrller:UIViewController {
    weak var coordinator: SettingCoordinator?

        @IBOutlet weak var privacyButton: UIButton!
        @IBOutlet weak var termsButton: UIButton!

        override func viewDidLoad() {
            super.viewDidLoad()
            setupNavigationBar()
   }

    private func setupNavigationBar() {
    
        if let navigationBar = self.navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = AppColors.background
 
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            navigationBar.compactAppearance = appearance
            navigationBar.layer.masksToBounds = true
        }

        // Установите пользовательский заголовок в navigationItem
        let titleLabel = UILabel()
        titleLabel.text = "Settings"
        titleLabel.font = UIFont(name: "OpenSans-SemiBold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        
        self.navigationItem.titleView = titleLabel
    }
        @IBAction func termsButtonTapped(_ sender: UIButton) {
            openURL("https://www.google.com")
        }

        @IBAction func privacyButtonTapped(_ sender: UIButton) {
            openURL("https://www.yandex.com")
        }

        private func openURL(_ urlString: String) {
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        }
    
    }
