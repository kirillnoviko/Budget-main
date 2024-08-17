//
//  CreditCalculatorControlller.swift
//  BudgetProject
//
//  Created by User on 1.08.24.
//

import Foundation
import UIKit
class CreditCalculatorControlller:UIViewController, UITextFieldDelegate {
    weak var coordinator: CreditCalculatorCoordinator?
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var interestRateTextField: UITextField!
    @IBOutlet weak var termTextField: UITextField!
    @IBOutlet weak var currencyButton: UIButton!
    @IBOutlet weak var termButton: UIButton!
    @IBOutlet weak var paymentTypeSwitch: UIButton!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var procent: UILabel!
    
    var selectedCurrency: String = "USD"
    var selectedTermType: String = "Months"
    var isAnnuityPayment: Bool = true // Переменная для хранения состояния переключателя
        
    enum PaymentType {
        case annuity
        case differentiated
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountTextField.delegate = self
        interestRateTextField.delegate = self
        termTextField.delegate = self
        setupMenuActions()
        setupNavigationBar()
        
        setupAmountTextField(textField: amountTextField)
        setupAmountTextField(textField: interestRateTextField)
        setupAmountTextField(textField: termTextField)
        setupAmountLabel(label: procent)
        setupButtons()
        
        setupSwitchAppearance(paymentTypeSwitch)
              
        paymentTypeSwitch.addTarget(self, action: #selector(paymentTypeChanged), for: .touchDown)
        calculateButton.addTarget(self, action: #selector(calculatePayment), for: .touchUpInside)
    }
    func setupButtons() {
         let spacing: CGFloat = 4.0 // Расстояние между текстом и изображением
        let borderColor = UIColor(red: 116/255, green: 105/255, blue: 150/255, alpha: 1) // Цвет #746996
        
      
     // Настройка кнопки валюты
        
        currencyButton.layer.borderColor = borderColor.cgColor
        currencyButton.layer.borderWidth = 1.0
        currencyButton.layer.cornerRadius = 15.0
        currencyButton.layer.masksToBounds = true
        currencyButton.backgroundColor = UIColor.clear
        
        
        termButton.layer.borderColor = borderColor.cgColor
        termButton.layer.borderWidth = 1.0
        termButton.layer.cornerRadius = 15.0
        termButton.layer.masksToBounds = true
        termButton.backgroundColor = UIColor.clear
        
        
         currencyButton.semanticContentAttribute = .forceRightToLeft
         currencyButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: -spacing)
         currencyButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -spacing, bottom: 0, right: spacing)
         
         // Настройка кнопки срока
         termButton.semanticContentAttribute = .forceRightToLeft
         termButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: -spacing)
         termButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -spacing, bottom: 0, right: spacing)
     }

    func setupAmountTextField(textField : UITextField) {
           let borderColor = UIColor(red: 116/255, green: 105/255, blue: 150/255, alpha: 1) // Цвет #746996
           
            textField.layer.borderColor = borderColor.cgColor
            textField.layer.borderWidth = 1.0
            textField.layer.cornerRadius = 15.0
            textField.layer.masksToBounds = true
            textField.backgroundColor = UIColor.clear
            textField.textColor = UIColor.white
            textField.attributedPlaceholder = NSAttributedString(
                string: textField.placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: borderColor]
            )
            
       }
    func setupAmountLabel(label : UILabel) {
           let borderColor = UIColor(red: 116/255, green: 105/255, blue: 150/255, alpha: 1) // Цвет #746996
           
        label.layer.borderColor = borderColor.cgColor
        label.layer.borderWidth = 1.0
        label.layer.cornerRadius = 15.0
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
            
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
        titleLabel.text = "Loan calculator"
        titleLabel.font = UIFont(name: "OpenSans-SemiBold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        
        self.navigationItem.titleView = titleLabel
    }
    func setupSwitchAppearance(_ switchButton: UIButton) {
           switchButton.setImage(UIImage(named: "button-check-active"), for: .selected)
           switchButton.setImage(UIImage(named: "button-check"), for: .normal)
           switchButton.isSelected = true // Устанавливаем начальное состояние как выбранное (аннуитетный платеж)
       }
    
    @objc func paymentTypeChanged(_ sender: UIButton) {
        sender.isSelected.toggle()
             isAnnuityPayment = sender.isSelected
       
     }
    
    func setupMenuActions() {
        let currencyMenu = UIMenu(title: "", children: [
            UIAction(title: "USD", handler: { _ in self.selectCurrency("USD") }),
            UIAction(title: "RUB", handler: { _ in self.selectCurrency("RUB") }),
            UIAction(title: "EUR", handler: { _ in self.selectCurrency("EUR") })
        ])
        currencyButton.menu = currencyMenu
        currencyButton.showsMenuAsPrimaryAction = true
        
        let termMenu = UIMenu(title: "", children: [
            UIAction(title: "Months", handler: { _ in self.selectTermType("Months") }),
            UIAction(title: "Years", handler: { _ in self.selectTermType("Years") })
               ])
        termButton.menu = termMenu
        termButton.showsMenuAsPrimaryAction = true
    }
    
    @objc func selectCurrency(_ currency: String) {
        selectedCurrency = currency
        currencyButton.setTitle(currency, for: .normal)
    }
    
    @objc func selectTermType(_ termType: String) {
        selectedTermType = termType
        termButton.setTitle(termType, for: .normal)
    }
    
   
    @objc func calculatePayment() {
        guard let amountText = amountTextField.text, let amount = Double(amountText),
              let interestRateText = interestRateTextField.text, let annualInterestRate = Double(interestRateText),
              let termText = termTextField.text, let term = Int(termText) else {
            showAlert(title: "Invalid Input", message: "Please enter a valid value.")
            
            return
        }
        
        let monthlyInterestRate = annualInterestRate / 100 / 12
        var numberOfPayments = term
        
        if selectedTermType == "Years" {
            numberOfPayments *= 12
        }
        
        let currencyRate: Double
        switch selectedCurrency {
        case "USD":
            currencyRate = 1.0
        case "EUR":
            currencyRate = 1.1 // Примерный курс
        case "RUB":
            currencyRate = 0.014 // Примерный курс
        default:
            currencyRate = 1.0
        }
        
        let amountInUSD = amount * currencyRate
        
        let monthlyPayment: Double
        if paymentTypeSwitch.isSelected {
            monthlyPayment = calculateAnnuityPayment(amount: amountInUSD, monthlyInterestRate: monthlyInterestRate, numberOfPayments: numberOfPayments)
        } else {
            monthlyPayment = calculateDifferentiatedPayment(amount: amountInUSD, monthlyInterestRate: monthlyInterestRate, numberOfPayments: numberOfPayments)
        }
        
        resultLabel.text = String(format: "%.2f $", monthlyPayment)
    }
    
    func calculateAnnuityPayment(amount: Double, monthlyInterestRate: Double, numberOfPayments: Int) -> Double {
        return amount * monthlyInterestRate / (1 - pow(1 + monthlyInterestRate, -Double(numberOfPayments)))
    }
    
    func calculateDifferentiatedPayment(amount: Double, monthlyInterestRate: Double, numberOfPayments: Int) -> Double {
        let principalPayment = amount / Double(numberOfPayments)
        let interestPayment = (amount  * monthlyInterestRate) + principalPayment
        return  interestPayment
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "."))
        let characterSet = CharacterSet(charactersIn: string)
        
        // Check if the input string contains only allowed characters
        if !allowedCharacters.isSuperset(of: characterSet) {
            return false
        }
        
        // Get the current text and the new text after the change
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // Ensure there is only one decimal point
        let decimalSeparator = "."
        if updatedText.components(separatedBy: decimalSeparator).count - 1 > 1 {
            return false
        }
        
        // Ensure the value is positive
        if updatedText.starts(with: "-") {
            return false
        }
        
        // Ensure the value is not starting with a decimal point
        if updatedText == decimalSeparator {
            return false
        }
        
        // Allow the updated text
        return true
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

}

