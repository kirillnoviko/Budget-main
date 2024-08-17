import UIKit

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var circle: UIView!
    private let underlineView = UIView()  // Вид для подчеркивающей линии
  
    

    private let ringView = RingView()

        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            commonInit()
        }
        
        func configure(with category: Category, totalAmount: Double, categoryAmount: Double, color: UIColor) {
            nameLabel.text = category.name
            amountLabel.text = "\(categoryAmount)"
            percentageLabel.text = String(format: "%.2f%%", (categoryAmount / totalAmount) * 100)
            ringView.setColor(color)
        }

       private func commonInit() {
            // Настройка RingView
            ringView.translatesAutoresizingMaskIntoConstraints = false
            underlineView.translatesAutoresizingMaskIntoConstraints = false
                  
            // Доступ к circle возможен только после полной загрузки xib/Storyboard
        }
        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Убедимся, что circle не является nil и добавим ringView здесь
            circle.addSubview(ringView)
            contentView.addSubview(underlineView)
            underlineView.backgroundColor = AppColors.redMain
           
            setupConstraints()
        }

        private func setupConstraints() {
            // Установка констрейнтов для RingView
            NSLayoutConstraint.activate([
                ringView.leadingAnchor.constraint(equalTo: circle.leadingAnchor, constant: 0),
                ringView.topAnchor.constraint(equalTo: circle.topAnchor, constant: 0),
                ringView.bottomAnchor.constraint(equalTo: circle.bottomAnchor, constant: 0),
                ringView.trailingAnchor.constraint(equalTo: circle.trailingAnchor, constant: 0)
              
            ])
            NSLayoutConstraint.activate([
                      underlineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                      underlineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                      underlineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                      underlineView.heightAnchor.constraint(equalToConstant: 1)  // Толщина линии
                  ])
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            // Обновляем размеры и размещение элементов, если необходимо
        }
}
