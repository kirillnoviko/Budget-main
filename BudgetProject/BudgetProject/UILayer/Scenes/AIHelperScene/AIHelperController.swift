//
//  AIHelperController.swift
//  BudgetProject
//
//  Created by User on 3.08.24.
//

import Foundation

import UIKit
class AIHelperController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    weak var coordinator: AiHelperCoordinator?


        @IBOutlet weak var tableView: UITableView!

        @IBOutlet weak var messageTextView: PlaceholderTextView!
        @IBOutlet weak var sendButton: UIButton!
        @IBOutlet weak var containerView: UIView!
        var messages = [Message]()

        override func viewDidLoad() {
            super.viewDidLoad()
            
            setupNavigationBar()
            
            
            tableView.delegate = self
            tableView.dataSource = self
            tableView.estimatedRowHeight = 44.0
            tableView.rowHeight = UITableView.automaticDimension
            
            containerView.layer.cornerRadius = 10
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor.gray.cgColor
            containerView.layer.masksToBounds = true
            
            messageTextView.delegate = self
            messageTextView.isScrollEnabled = false
            messageTextView.textContainer.lineBreakMode = .byWordWrapping
            messageTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            messageTextView.placeholder = "Введите текст здесь..."
                    
//            messageTextView.layer.borderColor = UIColor.lightGray.cgColor
//            messageTextView.layer.borderWidth = 1.0
            messageTextView.layer.cornerRadius = 5.0
            
            // Настройка фона для сообщений пользователя
        
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
        titleLabel.text = "Helper"
        titleLabel.font = UIFont(name: "OpenSans-SemiBold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        
        self.navigationItem.titleView = titleLabel
    }

        @IBAction func sendMessage(_ sender: UIButton) {
            guard let text = messageTextView.text, !text.isEmpty else { return }
            let message = Message(text: text, isIncoming: false)
            messages.append(message)
            tableView.reloadData()
            messageTextView.text = ""
            scrollToBottom()
            sendToChatGPT(message: text)
            updateTextViewHeight()
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return messages.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
            let message = messages[indexPath.row]
            cell.configure(with: message)
            return cell
        }

        func sendToChatGPT(message: String) {
            let apiKey = "YOUR_OPENAI_API_KEY"
            let url = URL(string: "https://api.openai.com/v1/engines/davinci-codex/completions")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let parameters: [String: Any] = [
                "prompt": message,
                "max_tokens": 50
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else { return }

                if let response = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = response["choices"] as? [[String: Any]],
                   let text = choices.first?["text"] as? String {

                    DispatchQueue.main.async {
                        let incomingMessage = Message(text: text.trimmingCharacters(in: .whitespacesAndNewlines), isIncoming: true)
                        self.messages.append(incomingMessage)
                        self.tableView.reloadData()
                        self.scrollToBottom()
                    }
                }
            }
            task.resume()
        }

        func scrollToBottom() {
            if messages.count > 0 {
                let indexPath = IndexPath(row: messages.count - 1, section: 0)
                tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }

        func textViewDidChange(_ textView: UITextView) {
            updateTextViewHeight()
        }

        func updateTextViewHeight() {
            let size = CGSize(width: messageTextView.frame.width, height: .infinity)
            let estimatedSize = messageTextView.sizeThatFits(size)

            // Ограничение высоты до 2 строк
            let maxHeight: CGFloat = 36 // Примерная высота двух строк текста
            messageTextView.isScrollEnabled = estimatedSize.height > maxHeight
            messageTextView.constraints.forEach { (constraint) in
                if constraint.firstAttribute == .height {
                    constraint.constant = min(estimatedSize.height, maxHeight)
                }
            }
        }
    }
