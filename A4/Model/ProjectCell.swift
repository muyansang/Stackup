//
//  ProjectCell.swift
//  A4
//
//  Created by muyan on 5/1/25.
//
import UIKit
import Foundation

class ProjectCell: UICollectionViewCell {
    private let nameLabel = UILabel()
    private let idLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = Theme.themeRed
        layer.cornerRadius = 16
        clipsToBounds = true

        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center

        idLabel.font = UIFont.systemFont(ofSize: 12)
        idLabel.textColor = .white
        idLabel.textAlignment = .center
        idLabel.numberOfLines = 2
        idLabel.lineBreakMode = .byWordWrapping

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(nameLabel)
        contentView.addSubview(idLabel)

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            idLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            idLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            idLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 8),
            idLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8)
        ])
    }

    func configure(name: String, id: String) {
        idLabel.text = "Project ID:\n\(id)"
        nameLabel.text = name
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(name: String, id: String, color: UIColor) {
        nameLabel.text = name
        idLabel.text = "Project ID: \(id)"
        backgroundColor = color
        layer.cornerRadius = 16
    }
    
    func startShaking() {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
        animation.values = [-0.05, 0.05, -0.05]
        animation.duration = 0.2
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        layer.add(animation, forKey: "shaking")
    }

    func stopShaking() {
        layer.removeAnimation(forKey: "shaking")
    }


}
