

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var userMessageBackground: GradientView!
    @IBOutlet weak var chatGPTMessageBackground: GradientView!
    @IBOutlet weak var userMessageLabel: UILabel!
    @IBOutlet weak var chatGPTMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Настройка фона для сообщений пользователя
        userMessageBackground.layer.cornerRadius = 15
        userMessageBackground.clipsToBounds = true
        userMessageBackground.colors = [
            UIColor.white,
            UIColor(red: 0.97, green: 0.62, blue: 0.87, alpha: 1.00), // F79FDD
            UIColor(red: 1.00, green: 0.85, blue: 0.88, alpha: 1.00), // FFD8E0
            UIColor(red: 0.95, green: 0.49, blue: 0.56, alpha: 1.00)  // F27D90
        ]
        userMessageBackground.locations = [0.0, 0.25, 0.57, 1.0]

        // Настройка фона для сообщений ChatGPT
        chatGPTMessageBackground.layer.cornerRadius = 15
        chatGPTMessageBackground.clipsToBounds = true
        chatGPTMessageBackground.colors = [
            UIColor.white,
            UIColor(red: 0.97, green: 0.62, blue: 0.87, alpha: 1.00), // F79FDD
            UIColor(red: 1.00, green: 0.85, blue: 0.88, alpha: 1.00), // FFD8E0
            UIColor(red: 0.95, green: 0.49, blue: 0.56, alpha: 1.00)  // F27D90
        ]
        chatGPTMessageBackground.locations = [0.0, 0.25, 0.57, 1.0]

        userMessageLabel.numberOfLines = 0
        chatGPTMessageLabel.numberOfLines = 0
    }
    
    func configure(with message: Message) {
        if message.isIncoming {
            chatGPTMessageLabel.text = message.text
            chatGPTMessageBackground.isHidden = false
            userMessageBackground.isHidden = true
            chatGPTMessageLabel.textAlignment = .left
        } else {
            userMessageLabel.text = message.text
            userMessageBackground.isHidden = false
            chatGPTMessageBackground.isHidden = true
            userMessageLabel.textAlignment = .right
            userMessageLabel.textColor = .white
        }
    }
}

