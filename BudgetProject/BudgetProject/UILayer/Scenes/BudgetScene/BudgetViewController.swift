import UIKit
import DGCharts
import CoreData

enum OperationType: Int {
    case expense
    case income
}

enum TimePeriod: Int {
    case day
    case week
    case month
    case year
    // Убираем .all, если его нет в перечислении
}

class BudgetViewController: UIViewController, AddCategoryDelegate {
    func didAddOperation() {
        updateView()

    }
    
    
    
    
    weak var coordinator: BudgetCoordinator?
    var operationStatistic: OperationStatistic = OperationStatistic()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pieChartContainer: UIView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var segmentControlView: UIView!
    @IBOutlet weak var periodSegmentControlView: UIView!
 
    
    @IBOutlet weak var labelBudget: UILabel!
    var pieChartView: PieChartView!
    let periodSegmentedControl1 = UISegmentedControl(items: ["", "", "", ""]) // Убираем "All"
    let segmentedControl = UISegmentedControl(items: ["Expenses", "Income"])
    
    private var selectedType: OperationType = .expense
    private var categories: [Category] = []
    private var operations: [Operation] = []
    var categoryData: [(Category, Double)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
             segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.backgroundColor = .clear
        segmentedControl.tintColor = .clear

        segmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentedControl.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        segmentedControl.setBackgroundImage(UIImage(), for: .highlighted, barMetrics: .default)
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)

        // Устанавливаем изображения с contentMode и content insets
        let expensesFalse = UIImage(named: "ExpensesFalse")?.withRenderingMode(.alwaysOriginal)
        let incomeFalse = UIImage(named: "IncomeFalse")?.withRenderingMode(.alwaysOriginal)
        let expensesTrue = UIImage(named: "ExpensesTrue")?.withRenderingMode(.alwaysOriginal)

        segmentedControl.setImage(expensesFalse, forSegmentAt: 0)
        segmentedControl.setImage(incomeFalse, forSegmentAt: 1)

        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setImage(expensesTrue, forSegmentAt: 0)
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)

        // Настройка отступов содержимого
        for index in 0..<segmentedControl.numberOfSegments {
            segmentedControl.setContentPositionAdjustment(UIOffset(horizontal: -10, vertical: 0), forSegmentType: .left, barMetrics: .default)
            segmentedControl.setContentPositionAdjustment(UIOffset(horizontal: -10, vertical: 0), forSegmentType: .right, barMetrics: .default)
        }

        // Добавляем segmentedControl на вью
        self.segmentControlView.addSubview(segmentedControl)
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: segmentControlView.topAnchor, constant: 0),
            segmentedControl.leadingAnchor.constraint(equalTo: segmentControlView.leadingAnchor, constant: 0),
            segmentedControl.trailingAnchor.constraint(equalTo: segmentControlView.trailingAnchor, constant: 0),
            segmentedControl.bottomAnchor.constraint(equalTo: segmentControlView.bottomAnchor, constant: 0)
        ])

        // Настройка второго UISegmentedControl
        periodSegmentedControl1.translatesAutoresizingMaskIntoConstraints = false
        periodSegmentedControl1.backgroundColor = .clear
        periodSegmentedControl1.tintColor = .clear

        periodSegmentedControl1.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        periodSegmentedControl1.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        periodSegmentedControl1.setBackgroundImage(UIImage(), for: .highlighted, barMetrics: .default)
        periodSegmentedControl1.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)

        let dayFalse = UIImage(named: "DayFalse")?.withRenderingMode(.alwaysOriginal)
        let weekFalse = UIImage(named: "WeekFalse")?.withRenderingMode(.alwaysOriginal)
        let monthFalse = UIImage(named: "MonthFalse")?.withRenderingMode(.alwaysOriginal)
        let yearFalse = UIImage(named: "YearFalse")?.withRenderingMode(.alwaysOriginal)
        let dayTrue = UIImage(named: "DayTrue")?.withRenderingMode(.alwaysOriginal)

        periodSegmentedControl1.setImage(dayFalse, forSegmentAt: 0)
        periodSegmentedControl1.setImage(weekFalse, forSegmentAt: 1)
        periodSegmentedControl1.setImage(monthFalse, forSegmentAt: 2)
        periodSegmentedControl1.setImage(yearFalse, forSegmentAt: 3)
       
        periodSegmentedControl1.selectedSegmentIndex = 0
        periodSegmentedControl1.setImage(dayTrue, forSegmentAt: 0)
        periodSegmentedControl1.addTarget(self, action: #selector(periodSegmentChanged(_:)), for: .valueChanged)

        // Добавляем segmentedControl на вью
        self.periodSegmentControlView.addSubview(periodSegmentedControl1)
        NSLayoutConstraint.activate([
            
             periodSegmentedControl1.leadingAnchor.constraint(equalTo: periodSegmentControlView.leadingAnchor, constant: 0),
            periodSegmentedControl1.trailingAnchor.constraint(equalTo: periodSegmentControlView.trailingAnchor, constant: 0),
            periodSegmentedControl1.topAnchor.constraint(equalTo: periodSegmentControlView.topAnchor, constant: 0),
             periodSegmentedControl1.bottomAnchor.constraint(equalTo: periodSegmentControlView.bottomAnchor, constant: 0)
      
        ])

        buttonAdd.layer.zPosition = 99999
        setupPieChartView()
        collectionView.dataSource = self
        collectionView.delegate = self
        updateView()
    }
    func deleteStore() {
        let storeCoordinator = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.persistentStoreCoordinator
        
        if let storeURL = storeCoordinator.persistentStores.first?.url {
            do {
                try FileManager.default.removeItem(at: storeURL)
            } catch let error as NSError {
                print("Could not delete store. \(error), \(error.userInfo)")
            }
        }
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
        titleLabel.text = "Budget"
        titleLabel.font = UIFont(name: "OpenSans-SemiBold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        
        self.navigationItem.titleView = titleLabel
    }

    private func setupSegmentedControls() {
        setupSegmentedControl(segmentedControl, items: ["Expenses", "Income"], images: ["ExpensesFalse", "IncomeFalse"], activeImages: ["ExpensesTrue", "IncomeTrue"], action: #selector(segmentChanged(_:)))
        
        setupSegmentedControl(periodSegmentedControl1, items: ["Day", "Week", "Month", "Year"], images: ["DayFalse", "WeekFalse", "MonthFalse", "YearFalse"], activeImages: ["DayTrue", "WeekTrue", "MonthTrue", "YearTrue"], action: #selector(periodSegmentChanged(_:)))
        
        segmentedControl.selectedSegmentIndex = 0
        periodSegmentedControl1.selectedSegmentIndex = 0
    }
    
    private func setupSegmentedControl(_ control: UISegmentedControl, items: [String], images: [String], activeImages: [String], action: Selector) {
        control.translatesAutoresizingMaskIntoConstraints = false
        control.backgroundColor = .clear
        control.tintColor = .clear
        control.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        control.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        control.setBackgroundImage(UIImage(), for: .highlighted, barMetrics: .default)
        control.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        for (index, image) in images.enumerated() {
            control.setImage(UIImage(named: image)?.withRenderingMode(.alwaysOriginal), forSegmentAt: index)
        }
        for (index, image) in activeImages.enumerated() {
            if control.selectedSegmentIndex == index {
                control.setImage(UIImage(named: image)?.withRenderingMode(.alwaysOriginal), forSegmentAt: index)
            }
        }
        control.addTarget(self, action: action, for: .valueChanged)
        self.view.addSubview(control)
    }
    
    private func setupPieChartView() {
        pieChartView = PieChartView(frame: pieChartContainer.bounds)
        if let pieChartView = pieChartView {
            pieChartContainer.addSubview(pieChartView)
            pieChartView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                pieChartView.topAnchor.constraint(equalTo: pieChartContainer.topAnchor, constant: 0),
                pieChartView.leadingAnchor.constraint(equalTo: pieChartContainer.leadingAnchor, constant: 0),
                pieChartView.trailingAnchor.constraint(equalTo: pieChartContainer.trailingAnchor, constant: 0),
                pieChartView.bottomAnchor.constraint(equalTo: pieChartContainer.bottomAnchor, constant: 0)
            ])
            // Настройка отображения
            pieChartView.holeRadiusPercent = 0.8 // Установите это значение в зависимости от желаемого размера отверстия в середине
            pieChartView.holeColor = UIColor.clear // Установите цвет отверстия на прозрачный
            pieChartView.transparentCircleColor = AppColors.background //
            pieChartView.isUserInteractionEnabled = false
            pieChartView.highlightPerTapEnabled = false
           
            pieChartView.rotationEnabled = false

            // Отключение подписей и элементов
            pieChartView.drawSlicesUnderHoleEnabled = false
            pieChartView.usePercentValuesEnabled = false
            pieChartView.chartDescription.enabled = false
            pieChartView.legend.enabled = false
            pieChartView.drawCenterTextEnabled = false
            
            pieChartView.drawEntryLabelsEnabled = false
             
                pieChartView.transparentCircleRadiusPercent = 0.55
               pieChartView.drawHoleEnabled = true
         
              
               
        }
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        let images = ["ExpensesTrue", "IncomeTrue"]
        let inactiveImages = ["ExpensesFalse", "IncomeFalse"]
        
        for index in 0..<sender.numberOfSegments {
            sender.setImage(UIImage(named: inactiveImages[index])?.withRenderingMode(.alwaysOriginal), forSegmentAt: index)
        }
        sender.setImage(UIImage(named: images[sender.selectedSegmentIndex])?.withRenderingMode(.alwaysOriginal), forSegmentAt: sender.selectedSegmentIndex)
//        selectedType = OperationType(rawValue: sender.selectedSegmentIndex) ?? .income
        selectedType = segmentedControl.selectedSegmentIndex == 0 ? .expense : .income
        updateView()
    }
    
    @IBAction func periodSegmentChanged(_ sender: UISegmentedControl) {
        let images = ["DayTrue", "WeekTrue", "MonthTrue", "YearTrue"]
        let inactiveImages = ["DayFalse", "WeekFalse", "MonthFalse", "YearFalse"]
        
        for index in 0..<sender.numberOfSegments {
            sender.setImage(UIImage(named: inactiveImages[index])?.withRenderingMode(.alwaysOriginal), forSegmentAt: index)
        }
        sender.setImage(UIImage(named: images[sender.selectedSegmentIndex])?.withRenderingMode(.alwaysOriginal), forSegmentAt: sender.selectedSegmentIndex)
        updateView()
    }
    
  
      
      @IBAction func addCategoryTapped(_ sender: UIButton) {
          let storyboard = UIStoryboard(name: "UIAddCategory", bundle: nil)
          if let addVC = storyboard.instantiateViewController(withIdentifier: "AddCategoryViewController") as? AddCategoryViewController {
              addVC.modalPresentationStyle = .formSheet // Попробуйте использовать .formSheet
              addVC.delegate = self
              addVC.selectedType = segmentedControl.selectedSegmentIndex == 0 ? .expense : .income
              present(addVC, animated: true, completion: nil)
          } else {
              print("AddCategoryViewController could not be instantiated")
          }
  
      }
    
    func updateView() {
        let period = TimePeriod(rawValue: periodSegmentedControl1.selectedSegmentIndex) ?? .month
        let startDate = getStartDate(for: period)
        let endDate = Date()
        operations = fetchOperations(for: selectedType , from: startDate, to: endDate)
        updateCategories()
        updateCollectionView()
//        collectionView.reloadData()
        updatePieChart()
        updateBalance()
    }
    
    func fetchOperations(for type: OperationType, from startDate: Date, to endDate: Date) -> [Operation] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Operation> = Operation.fetchRequest()
        
        let typeString = "\(type.rawValue)"
        let startNSDate = startDate as NSDate
        let endNSDate = endDate as NSDate
        print("Fetching operations with type: \(typeString), start date: \(startNSDate), end date: \(endNSDate)")
        
        fetchRequest.predicate = NSPredicate(format: "type == %@ AND date >= %@ AND date <= %@", typeString, startNSDate, endNSDate)
        
        do {
            return try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch operations: \(error), \(error.userInfo)")
            return []
        }
    }
    func fetchAllOperations() -> [Operation] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Operation> = Operation.fetchRequest()
        
        // Нет фильтров по типу или дате
        fetchRequest.predicate = nil  // Все операции
        
        do {
            return try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch operations: \(error), \(error.userInfo)")
            return []
        }
    }
    func updateCollectionView() {
        let categoryTotals = aggregateData()
        categoryData = Array(categoryTotals) // Преобразуем в массив пар (Category, Double)
        self.collectionView.reloadData()
    }
    func aggregateData() -> [Category: Double] {
        var categoryTotals = [Category: Double]()
        
        for operation in operations {
            guard let category = operation.category else { continue }
            categoryTotals[category, default: 0] += operation.amount
        }
        
        return categoryTotals
    }
    func updateCategories() {
        let categoryAmounts = operations.reduce(into: [Category: Double]()) { result, operation in
            let category = operation.category!
            result[category, default: 0] += operation.amount
        }
        categories = Array(categoryAmounts.keys)
    }
    
    func getStartDate(for period: TimePeriod) -> Date {
        let calendar = Calendar.current
        switch period {
        case .day:
            return calendar.startOfDay(for: Date())
        case .week:
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))
            return startOfWeek ?? Date()
        case .month:
            return calendar.date(from: calendar.dateComponents([.year, .month], from: Date())) ?? Date()
        case .year:
            return calendar.date(from: calendar.dateComponents([.year], from: Date())) ?? Date()
        }
    }
    func colorFromData(_ data: Data?) -> UIColor? {
        guard let data = data else { return nil }
        return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor
    }
    func updatePieChart() {

        let categoryTotals = aggregateData()
            let totalAmount = categoryTotals.values.reduce(0, +)
            let dataEntries = categoryTotals.map { (category, total) in
                return PieChartDataEntry(value: total / totalAmount * 100, label: category.name)
            }
            
            let dataSet = PieChartDataSet(entries: dataEntries, label: "Categories")
        dataSet.colors = categoryTotals.keys.map { category in
        
               return colorFromData(category.color) ?? .gray // Используйте цвет из категории
           }
        
            let data = PieChartData(dataSet: dataSet)
            pieChartView.data = data
            pieChartView.notifyDataSetChanged()
    }
    
    func updateBalance() {
       var operationsAll: [Operation] = []
        operationsAll = fetchAllOperations()
        let income = operationsAll.filter { $0.type == "\(OperationType.income.rawValue)" }.reduce(0) { $0 + $1.amount }
          let expense = operationsAll.filter { $0.type == "\(OperationType.expense.rawValue)" }.reduce(0) { $0 + $1.amount }
          let balance = income - expense
          
       
        // Убедитесь, что шрифт добавлен в проект и зарегистрирован
               guard let font = UIFont(name: "OpenSans-Semibold", size: 24) else {
                   print("Font not found")
                   return
               }

               // Установка атрибутов шрифта
               let attributes: [NSAttributedString.Key: Any] = [
                   .font: font,
                   .paragraphStyle: {
                       let paragraphStyle = NSMutableParagraphStyle()
                       paragraphStyle.lineHeightMultiple = 32.68 / 24 // Высота строки = 32.68px, размер шрифта = 24px
                       return paragraphStyle
                   }()
               ]
               
        let textWith = String(format: "%.2f", (balance))
        var attributedString = NSAttributedString(string: "$\(textWith)", attributes: attributes)
        balanceLabel.attributedText = attributedString
        
        let attributes1: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "OpenSans-Semibold", size: 12) as Any,
            .paragraphStyle: {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineHeightMultiple = 16.34 / 12 // Высота строки = 32.68px, размер шрифта = 24px
                return paragraphStyle
            }()
        ]
        attributedString = NSAttributedString(string: "Your Budget", attributes: attributes1)
     
        labelBudget.attributedText = attributedString
        
    }
}

extension BudgetViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
          
          let (category, total) = categoryData[indexPath.item]
          let totalAmount = aggregateData().values.reduce(0, +)
          
        cell.configure(with: category, totalAmount: totalAmount, categoryAmount: total, color: colorFromData(category.color)!)
          
          return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let collectionViewSize = collectionView.frame.size.width - padding

        return CGSize(width: collectionViewSize, height: collectionView.frame.size.height / 3)
    }
}
