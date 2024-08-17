
import UIKit
import CoreData

class AddCategoryViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: AddCategoryDelegate?
    var selectedType: OperationType = .expense
    var categories: [Category] = []
    private var selectedIndexPath: IndexPath?
      
 
    

    @IBAction func addButtonTapped(_ sender: Any) {
        guard let amountText = amountTextField.text, let amount = Double(amountText) else {
            showAlert(title: "Invalid Input", message: "Please enter a valid amount.")
                  
            return
        }
        
        guard let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first else {
            showAlert(title: "No category selected", message: "Please select a valid category.")
            
          
            return
        }
        
        let selectedCategory = categories[selectedIndexPath.row]
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let operation = Operation(context: context)
        operation.amount = amount
        operation.date = Date()
        operation.type = "\(selectedType.rawValue)"
        operation.category = selectedCategory

        do {
            try context.save()
            print("Operation saved successfully")
            delegate?.didAddOperation()
            dismiss(animated: true, completion: nil)
        } catch {
            print("Failed to save operation: \(error)")
        }
        
    
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
        
        return true
    }

    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        amountTextField.delegate = self
        self.title = "Add an operation"
        self.view.backgroundColor = AppColors.background
        setupCategories()
        setupAmountTextField()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setupAmountTextField() {
           let borderColor = UIColor(red: 116/255, green: 105/255, blue: 150/255, alpha: 1) // Цвет #746996
           
           // Установка цвета границы
           amountTextField.layer.borderColor = borderColor.cgColor
           amountTextField.layer.borderWidth = 1.0
           
           // Установка закругленных углов
           amountTextField.layer.cornerRadius = 10
           amountTextField.layer.masksToBounds = true
           
           // Установка цвета placeholder
           if let placeholderText = amountTextField.placeholder {
               amountTextField.attributedPlaceholder = NSAttributedString(
                   string: placeholderText,
                   attributes: [NSAttributedString.Key.foregroundColor: borderColor]
               )
           }
       }
    func setupCategories() {
        categories.removeAll()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if selectedType == .income {
            categories.append(fetchOrCreateCategory(name: "Salary", type: selectedType, context: context))
            categories.append(fetchOrCreateCategory(name: "Investment", type: selectedType, context: context))
            categories.append(fetchOrCreateCategory(name: "Loan", type: selectedType, context: context))
            categories.append(fetchOrCreateCategory(name: "Gifts", type: selectedType, context: context))
        } else {
            categories.append(fetchOrCreateCategory(name: "Shop", type: selectedType, context: context))
            categories.append(fetchOrCreateCategory(name: "Animals", type: selectedType, context: context))
            categories.append(fetchOrCreateCategory(name: "Cafe", type: selectedType, context: context))
            categories.append(fetchOrCreateCategory(name: "Health", type: selectedType, context: context))
            categories.append(fetchOrCreateCategory(name: "Home", type: selectedType, context: context))
            categories.append(fetchOrCreateCategory(name: "Travel", type: selectedType, context: context))
            categories.append(fetchOrCreateCategory(name: "Bank", type: selectedType, context: context))
            categories.append(fetchOrCreateCategory(name: "Beauty", type: selectedType, context: context))
            categories.append(fetchOrCreateCategory(name: "Sport", type: selectedType, context: context))
            categories.append(fetchOrCreateCategory(name: "Car", type: selectedType, context: context))
            categories.append(fetchOrCreateCategory(name: "Transport", type: selectedType, context: context))

        }
        collectionView.reloadData()
    }
    
  
    
    func fetchOrCreateCategory(name: String, type: OperationType, context: NSManagedObjectContext) -> Category {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND type == %@", name, "\(type.rawValue)")

        do {
            let categories = try context.fetch(fetchRequest)
            if let category = categories.first {
                return category
            } else {
                let newCategory = Category(context: context)
                newCategory.name = name
                newCategory.type = "\(type.rawValue)"

                
          
                
                
                if type == .income {
                    switch name {
                    case "Salary":
                        newCategory.icon = UIImage(named: "salary")?.withRenderingMode(.alwaysOriginal).pngData()
                        newCategory.color = try? NSKeyedArchiver.archivedData(withRootObject:UIColor().hex(0xFFCA2D), requiringSecureCoding: false)
                                
//                        newCategory.color = "#FFCA2D" // Gold color
                    case "Investment":
                        newCategory.icon = UIImage(named: "investment")?.withRenderingMode(.alwaysOriginal).pngData()
                        newCategory.color = try? NSKeyedArchiver.archivedData(withRootObject:UIColor().hex(0x7DFF2D), requiringSecureCoding: false)
                        
//                        newCategory.color = "#7DFF2D" // Gold color
                    case "Loan":
                        newCategory.icon = UIImage(named: "loans")?.withRenderingMode(.alwaysOriginal).pngData()
                        newCategory.color = try? NSKeyedArchiver.archivedData(withRootObject: UIColor().hex(0x2DFFD9), requiringSecureCoding: false)
                       
//                        newCategory.color = "#7DFF2D" // Gold color
                    case "Gifts":
                        newCategory.icon = UIImage(named: "gifts")?.withRenderingMode(.alwaysOriginal).pngData()
                        newCategory.color = try? NSKeyedArchiver.archivedData(withRootObject: UIColor().hex(0x2DCDFF), requiringSecureCoding: false)
                       
//                        newCategory.color = "#2DCDFF" // Gold color
                   
                    default:
                        break
                    }
                } else {
                    switch name {
                    case "Shop":
                        newCategory.icon = UIImage(named: "shop")?.withRenderingMode(.alwaysOriginal).pngData()
                        newCategory.color = try? NSKeyedArchiver.archivedData(withRootObject: UIColor().hex(0xFFCA2D), requiringSecureCoding: false)
                       
//                        newCategory.color = "#FFCA2D" // Gold color
                    case "Animals":
                        newCategory.icon = UIImage(named: "animals")?.withRenderingMode(.alwaysOriginal).pngData()
                        newCategory.color = try? NSKeyedArchiver.archivedData(withRootObject: UIColor().hex(0xBFE0FF), requiringSecureCoding: false)
//                        newCategory.color = "#BFE0FF" // Gold color
                    case "Cafe":
                        newCategory.icon = UIImage(named: "cafe")?.withRenderingMode(.alwaysOriginal).pngData()
                        newCategory.color = try? NSKeyedArchiver.archivedData(withRootObject: UIColor().hex(0xC1BFFF), requiringSecureCoding: false)
//
//                        newCategory.color = "#C1BFFF" // Gold color
                    case "Health":
                        newCategory.icon = UIImage(named: "health")?.withRenderingMode(.alwaysOriginal).pngData()
                        newCategory.color = try? NSKeyedArchiver.archivedData(withRootObject: UIColor().hex(0xFFBFBF), requiringSecureCoding: false)
//
//                        newCategory.color = "#FFBFBF" // Gold color
                    case "Travel":
                        newCategory.icon = UIImage(named: "travel")?.withRenderingMode(.alwaysOriginal).pngData()
                        newCategory.color = try? NSKeyedArchiver.archivedData(withRootObject: UIColor().hex(0x56CCFF), requiringSecureCoding: false)
//
//                        newCategory.color = "#56CCFF" // Gold color
                    case "Home":
                        newCategory.icon = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal).pngData()
                        newCategory.color = try? NSKeyedArchiver.archivedData(withRootObject: UIColor().hex(0xC1FFBF), requiringSecureCoding: false)
//
//                        newCategory.color = "#C1FFBF" // Gold color
                    case "Bank":
                        newCategory.icon = UIImage(named: "bank")?.withRenderingMode(.alwaysOriginal).pngData()
                        newCategory.color = try? NSKeyedArchiver.archivedData(withRootObject: UIColor().hex(0x6CF95F), requiringSecureCoding: false)
//
//                        newCategory.color = "#6CF95F" // Gold color
                    case "Beauty":
                        newCategory.icon = UIImage(named: "beauty")?.withRenderingMode(.alwaysOriginal).pngData()
                        newCategory.color = try? NSKeyedArchiver.archivedData(withRootObject: UIColor().hex(0xFFF1BF), requiringSecureCoding: false)
//
//                        newCategory.color = "#FFF1BF" // Gold color
                    case "Sport":
                        newCategory.icon = UIImage(named: "sport")?.withRenderingMode(.alwaysOriginal).pngData()
                        newCategory.color = try? NSKeyedArchiver.archivedData(withRootObject: UIColor().hex(0xFFE189), requiringSecureCoding: false)
//
//                        newCategory.color = "#FFE189" // Gold color
                    case "Car":
                        newCategory.icon = UIImage(named: "car")?.withRenderingMode(.alwaysOriginal).pngData()
                        newCategory.color = try? NSKeyedArchiver.archivedData(withRootObject: UIColor().hex(0xFEBFFF), requiringSecureCoding: false)
//
//                        newCategory.color = "#FEBFFF" // Gold color
                    case "Transport":
                        newCategory.icon = UIImage(named: "transport")?.withRenderingMode(.alwaysOriginal).pngData()
                        newCategory.color = try? NSKeyedArchiver.archivedData(withRootObject: UIColor().hex(0xE3FFBF), requiringSecureCoding: false)
//
//                        newCategory.color = "#E3FFBF" // Gold color
                    default:
                        break
                    }
                }
                return newCategory
            }
        } catch {
            print("Failed to fetch category: \(error)")
            return Category()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension AddCategoryViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategorySelectionCell", for: indexPath) as! CategorySelectionCell
        let category = categories[indexPath.row]
        cell.configure(with: category)
        
        
        // Configure appearance based on selection
        if indexPath == selectedIndexPath {
            cell.nameLabel.textColor = AppColors.redMain
        } else {
            cell.nameLabel.textColor = AppColors.white
        }
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 30
        let collectionViewSize = collectionView.frame.size.width - padding

        return CGSize(width: collectionViewSize / 4, height: collectionView.frame.size.height / 4)
    }
}

// MARK: - UICollectionViewDelegate
extension AddCategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Update UI to reflect selection
        if let previousIndexPath = selectedIndexPath {
                    if let previousCell = collectionView.cellForItem(at: previousIndexPath) as? CategorySelectionCell {
                       
                        previousCell.nameLabel.textColor = .white
                        switch  previousCell.nameLabel.text {
                        case "Shop":
                            previousCell.setIcon(with: UIImage(named: "salary")?.withRenderingMode(.alwaysOriginal).pngData())
                        case "Animals":
                            previousCell.setIcon(with: UIImage(named: "animals")?.withRenderingMode(.alwaysOriginal).pngData())
                        case "Cafe":
                            previousCell.setIcon(with: UIImage(named: "cafe")?.withRenderingMode(.alwaysOriginal).pngData())
                        case "Health":
                            previousCell.setIcon(with: UIImage(named: "health")?.withRenderingMode(.alwaysOriginal).pngData())
                        case "Travel":
                            previousCell.setIcon(with: UIImage(named: "travel")?.withRenderingMode(.alwaysOriginal).pngData())
                        case "Home":
                            previousCell.setIcon(with: UIImage(named: "home")?.withRenderingMode(.alwaysOriginal).pngData())
                        case "Bank":
                            previousCell.setIcon(with: UIImage(named: "bank")?.withRenderingMode(.alwaysOriginal).pngData())
                        case "Beauty":
                            previousCell.setIcon(with: UIImage(named: "beauty")?.withRenderingMode(.alwaysOriginal).pngData())
                        case "Sport":
                            previousCell.setIcon(with: UIImage(named: "sport")?.withRenderingMode(.alwaysOriginal).pngData())
                        case "Car":
                            previousCell.setIcon(with: UIImage(named: "car")?.withRenderingMode(.alwaysOriginal).pngData())
                        case "Transport":
                            previousCell.setIcon(with: UIImage(named: "transport")?.withRenderingMode(.alwaysOriginal).pngData())
                        case "Salary":
                            previousCell.setIcon(with: UIImage(named: "salary")?.withRenderingMode(.alwaysOriginal).pngData())
                        case "Investment":
                            previousCell.setIcon(with: UIImage(named: "investment")?.withRenderingMode(.alwaysOriginal).pngData())
                        case "Loan":
                            previousCell.setIcon(with: UIImage(named: "loans")?.withRenderingMode(.alwaysOriginal).pngData())
                        case "Gifts":
                            previousCell.setIcon(with: UIImage(named: "gifts")?.withRenderingMode(.alwaysOriginal).pngData())
                        default:
                            break
                        }
                    }
                }

                // Update the currently selected cell
                if let cell = collectionView.cellForItem(at: indexPath) as? CategorySelectionCell {
                    
                    cell.nameLabel.textColor = AppColors.redMain
                    switch  cell.nameLabel.text {
                    case "Shop":
                        cell.setIcon(with: UIImage(named: "shop-active")?.withRenderingMode(.alwaysOriginal).pngData())
                    case "Animals":
                        cell.setIcon(with: UIImage(named: "animals-active")?.withRenderingMode(.alwaysOriginal).pngData())
                    case "Cafe":
                        cell.setIcon(with: UIImage(named: "cafe-active")?.withRenderingMode(.alwaysOriginal).pngData())
                    case "Health":
                        cell.setIcon(with: UIImage(named: "health-active")?.withRenderingMode(.alwaysOriginal).pngData())
                    case "Travel":
                        cell.setIcon(with: UIImage(named: "travel-active")?.withRenderingMode(.alwaysOriginal).pngData())
                    case "Home":
                        cell.setIcon(with: UIImage(named: "home-active")?.withRenderingMode(.alwaysOriginal).pngData())
                    case "Bank":
                        cell.setIcon(with: UIImage(named: "bank-active")?.withRenderingMode(.alwaysOriginal).pngData())
                    case "Beauty":
                        cell.setIcon(with: UIImage(named: "beauty-active")?.withRenderingMode(.alwaysOriginal).pngData())
                    case "Sport":
                        cell.setIcon(with: UIImage(named: "sport-active")?.withRenderingMode(.alwaysOriginal).pngData())
                    case "Car":
                        cell.setIcon(with: UIImage(named: "car-active")?.withRenderingMode(.alwaysOriginal).pngData())
                    case "Transport":
                        cell.setIcon(with: UIImage(named: "transport-active")?.withRenderingMode(.alwaysOriginal).pngData())
                    case "Salary":
                        cell.setIcon(with: UIImage(named: "salary-active")?.withRenderingMode(.alwaysOriginal).pngData())
                    case "Investment":
                        cell.setIcon(with: UIImage(named: "investment-active")?.withRenderingMode(.alwaysOriginal).pngData())
                    case "Loan":
                        cell.setIcon(with: UIImage(named: "loans-active")?.withRenderingMode(.alwaysOriginal).pngData())
                    case "Gifts":
                        cell.setIcon(with: UIImage(named: "gifts-active")?.withRenderingMode(.alwaysOriginal).pngData())
                    default:
                        break
                    }
                }

                // Update the selected index path
                selectedIndexPath = indexPath
    }
}
    
    


