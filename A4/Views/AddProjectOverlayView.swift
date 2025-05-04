//
//  AddProjectOverlayView.swift
//  A4
//
//  Created by muyan on 5/1/25.
//

import UIKit

protocol AddProjectOverlayDelegate: AnyObject {
    func didTapJoinButton()
}

class AddProjectOverlayView: UIView {
    var onSave: ((String, UIColor, String) -> Void)?
    var onCancel: (() -> Void)?
    weak var delegate: AddProjectOverlayDelegate?

    private let nameField = UITextField()
    private let colorStack = UIStackView()
    private let saveButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    public let joinButton = UIButton(type: .system)

    private let colorOptions: [UIColor] = [
        UIColor(red: 0.925, green: 0.686, blue: 0.827, alpha: 1), 
        UIColor(red: 0.588, green: 0.764, blue: 0.933, alpha: 1),
        UIColor(red: 0.604, green: 0.800, blue: 0.635, alpha: 1),
        UIColor(red: 0.976, green: 0.835, blue: 0.482, alpha: 1),
        UIColor(red: 0.945, green: 0.686, blue: 0.502, alpha: 1),
        UIColor(red: 0.776, green: 0.682, blue: 0.878, alpha: 1)
    ]
    private var selectedColor: UIColor?
    private var selectedButton: UIButton?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        layer.cornerRadius = 20
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 8

        nameField.placeholder = "Project Name"
        nameField.borderStyle = .roundedRect
        nameField.translatesAutoresizingMaskIntoConstraints = false

        colorStack.axis = .horizontal
        colorStack.spacing = 8
        colorStack.distribution = .fillEqually
        colorStack.translatesAutoresizingMaskIntoConstraints = false
        colorOptions.forEach { color in
            let button = UIButton(type: .system)
            button.backgroundColor = color
            button.layer.cornerRadius = 8
            button.addTarget(self, action: #selector(selectColor(_:)), for: .touchUpInside)
            colorStack.addArrangedSubview(button)
        }

        saveButton.setTitle("CONTINUE", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = Theme.themeRed
        saveButton.layer.cornerRadius = 12
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = .gray
        cancelButton.layer.cornerRadius = 12
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)

        joinButton.setTitle("JOIN with Project ID", for: .normal)
        joinButton.setTitleColor(Theme.themeRed, for: .normal)
        joinButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        joinButton.translatesAutoresizingMaskIntoConstraints = false
        joinButton.addTarget(self, action: #selector(joinTapped), for: .touchUpInside)

        [nameField, colorStack, saveButton, cancelButton, joinButton].forEach(addSubview)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            nameField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            colorStack.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 16),
            colorStack.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            colorStack.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            colorStack.heightAnchor.constraint(equalToConstant: 40),

            saveButton.topAnchor.constraint(equalTo: colorStack.bottomAnchor, constant: 24),
            saveButton.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 50),

            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 12),
            cancelButton.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),

            joinButton.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 16),
            joinButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    @objc private func saveTapped() {
        guard let name = nameField.text, !name.isEmpty,
              let color = selectedColor else {
            return
        }

        let shortId = generateShortId()

        let today = Date()
        UserDefaults.standard.set(today, forKey: "startDate-\(shortId)")

        onSave?(name, color, shortId)


    }
    
    func generateShortId(length: Int = 6) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).compactMap { _ in characters.randomElement() })
    }



    @objc private func joinTapped() {
        onCancel?()
        delegate?.didTapJoinButton()
    }

    @objc private func cancelTapped() {
        onCancel?()
    }

    @objc private func selectColor(_ sender: UIButton) {
        selectedButton?.layer.borderWidth = 0
        selectedButton = sender
        selectedColor = sender.backgroundColor
        sender.layer.borderColor = UIColor.black.cgColor
        sender.layer.borderWidth = 2
    }
    
    
}
