
import UIKit

class RingView: UIView {

    private let circleLayer = CAShapeLayer()
    private var circleColor: UIColor = .red // Начальный цвет по умолчанию

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCircle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCircle()
    }
    
    private func setupCircle() {
        // Удаляем предыдущий слой, если он есть
        circleLayer.removeFromSuperlayer()
        
        // Определяем параметры круга
        let ringWidth: CGFloat = 3
        
        // Определяем центр и радиус круга
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - ringWidth / 2
                
        // Создаем путь круга
        let circlePath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0,
            endAngle: .pi * 2,
            clockwise: true
        )
        
        // Настраиваем CAShapeLayer для круга
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor // Без обводки
        circleLayer.strokeColor = circleColor.cgColor // Заполняем круг цветом
        circleLayer.lineWidth = ringWidth
        
        // Добавляем слой к view
        layer.addSublayer(circleLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Обновляем размер и положение круга при изменении размеров view
        setupCircle()
    }

    // Новый метод для установки цвета круга
    func setColor(_ color: UIColor) {
        circleColor = color
        circleLayer.strokeColor = color.cgColor
        setNeedsLayout() // Обновляем layout для применения изменений
    }
}
