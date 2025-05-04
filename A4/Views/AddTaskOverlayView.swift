//
//  AddTaskView.swift
//  A4
//
//  Created by muyan on 4/29/25.
//

import UIKit

protocol AddTaskOverlayViewDelegate: AnyObject {
    func didCreateTask(_ task: Task)
}
class AddTaskOverlayView: UIView {
    
    weak var delegate: AddTaskOverlayViewDelegate?


    var onSave: ((String, Int, String) -> Void)?
    var onCancel: (() -> Void)?


    private let titleField = UITextField()
    private var selectedPriority: Int = 0
    private let descriptionView = UITextView()
    private let priorityButtons: [UIButton] = (0..<10).map { i in
        let button = UIButton()
        button.tag = i
        button.layer.cornerRadius = 8
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.backgroundColor = [
            UIColor(red: 0.45, green: 0.75, blue: 0.55, alpha: 1),
            UIColor(red: 0.55, green: 0.75, blue: 0.45, alpha: 1),
            UIColor(red: 0.65, green: 0.75, blue: 0.35, alpha: 1),
            UIColor(red: 0.75, green: 0.75, blue: 0.30, alpha: 1),
            UIColor(red: 0.85, green: 0.75, blue: 0.25, alpha: 1),
            UIColor(red: 0.90, green: 0.65, blue: 0.20, alpha: 1),
            UIColor(red: 0.90, green: 0.50, blue: 0.20, alpha: 1),
            UIColor(red: 0.90, green: 0.40, blue: 0.20, alpha: 1),
            UIColor(red: 0.85, green: 0.30, blue: 0.25, alpha: 1),
            UIColor(red: 0.80, green: 0.25, blue: 0.25, alpha: 1)
        ][i]
        return button
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        layer.cornerRadius = 16
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 8
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        let titleLabel = makeLabel("Title")
        titleField.borderStyle = .roundedRect
        

        let priorityLabel = makeLabel("Priority")
        let priorityStack = UIStackView(arrangedSubviews: priorityButtons)
        priorityStack.axis = .horizontal
        priorityStack.spacing = 4
        priorityStack.distribution = .fillEqually

        priorityButtons.forEach { button in
            button.addTarget(self, action: #selector(prioritySelected(_:)), for: .touchUpInside)
        }

        let descriptionLabel = makeLabel("Description")
        descriptionView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        descriptionView.layer.cornerRadius = 12
        descriptionView.layer.borderColor = UIColor.gray.cgColor
        descriptionView.layer.borderWidth = 0.1
        descriptionView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        descriptionView.font = UIFont.systemFont(ofSize: 15)
        descriptionView.textColor = .black
        descriptionView.delegate = self

        let saveButton = makeActionButton("SAVE", color: Theme.themeRed)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        let cancelButton = makeActionButton("CANCEL", color: .lightGray)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            titleLabel, titleField,
            priorityLabel, priorityStack,
            descriptionLabel, descriptionView,
            saveButton, cancelButton
        ])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }

    private func makeLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = Theme.themeRed
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }

    private func makeActionButton(_ title: String, color: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 12
        button.backgroundColor = color
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }

    @objc private func prioritySelected(_ sender: UIButton) {
        selectedPriority = sender.tag
        priorityButtons.forEach { $0.layer.borderWidth = 0 }
        sender.layer.borderColor = UIColor.black.cgColor
        sender.layer.borderWidth = 2
    }

    @objc private func saveTapped() {
        let title = titleField.text ?? ""
        let description = descriptionView.text ?? ""
        guard !title.isEmpty, description.count <= 50 else { return }
        onSave?(title, selectedPriority, description)
    }

    @objc private func cancelTapped() {
        onCancel?()
    }
}

extension AddTaskOverlayView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 50 {
            textView.text = String(textView.text.prefix(50))
        }
    }
}
