//
//  JoinProjectOverlayViiew.swift
//  A4
//
//  Created by muyan on 5/2/25.
//
import UIKit
import Foundation

protocol JoinProjectOverlayDelegate: AnyObject {
    func didTapBackToAddProject()
}

class JoinProjectOverlayView: UIView {
    var onJoin: ((String) -> Void)?
    var onCancel: (() -> Void)?
    
    weak var delegate: JoinProjectOverlayDelegate?

    private let idField = UITextField()
    private let joinButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 20
        translatesAutoresizingMaskIntoConstraints = false
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        idField.placeholder = "Enter Project ID"
        idField.borderStyle = .roundedRect
        idField.translatesAutoresizingMaskIntoConstraints = false

        joinButton.setTitle("JOIN", for: .normal)
        joinButton.setTitleColor(.white, for: .normal)
        joinButton.backgroundColor = Theme.themeRed
        joinButton.layer.cornerRadius = 12
        joinButton.addTarget(self, action: #selector(joinTapped), for: .touchUpInside)
        joinButton.translatesAutoresizingMaskIntoConstraints = false

        cancelButton.setTitle("BACK", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = .gray
        cancelButton.layer.cornerRadius = 12
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        addSubview(idField)
        addSubview(joinButton)
        addSubview(cancelButton)

        NSLayoutConstraint.activate([
            idField.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            idField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            idField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            joinButton.topAnchor.constraint(equalTo: idField.bottomAnchor, constant: 20),
            joinButton.leadingAnchor.constraint(equalTo: idField.leadingAnchor),
            joinButton.trailingAnchor.constraint(equalTo: idField.trailingAnchor),
            joinButton.heightAnchor.constraint(equalToConstant: 50),

            cancelButton.topAnchor.constraint(equalTo: joinButton.bottomAnchor, constant: 12),
            cancelButton.leadingAnchor.constraint(equalTo: idField.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: idField.trailingAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func joinTapped() {
        guard let id = idField.text, !id.isEmpty else { return }
        onJoin?(id)
    }

    @objc private func cancelTapped() {
        self.removeFromSuperview()
        delegate?.didTapBackToAddProject()
    }

}
