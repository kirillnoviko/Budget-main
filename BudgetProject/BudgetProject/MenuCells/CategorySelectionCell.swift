import UIKit

class CategorySelectionCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
      @IBOutlet weak var nameLabel: UILabel!

    func configure(with category: Category) {
            if let iconData = category.icon {
                iconImageView.image = UIImage(data: iconData)
            }
            nameLabel.text = category.name
        }

    func setIcon(with iconData: Data?) {
        if let data = iconData {
            iconImageView.image = UIImage(data: data)
        } else {
            iconImageView.image = nil // Если нет данных, устанавливаем nil
        }
    }
}
