
import UIKit

class GradientView: UIView {
    
    var gradientLayer: CAGradientLayer?

    var colors: [UIColor] = [UIColor.white, UIColor.red, UIColor.blue, UIColor.green] {
        didSet {
            setGradientBackground()
        }
    }

    var locations: [NSNumber] = [0.0, 0.25, 0.57, 1.0] {
        didSet {
            setGradientBackground()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }

    private func setGradientBackground() {
        gradientLayer?.removeFromSuperlayer()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
        self.gradientLayer = gradientLayer
    }
}

