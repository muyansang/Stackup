//
//  AddCell.swift
//  A4
//
//  Created by muyan on 5/1/25.
//
import UIKit
import Foundation

class AddCell: UICollectionViewCell {
    private let plusLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.95, alpha: 1)
        layer.cornerRadius = 16
        clipsToBounds = true

        plusLabel.text = "+"
        plusLabel.font = UIFont.boldSystemFont(ofSize: 40)
        plusLabel.textColor = Theme.themeRed
        plusLabel.textAlignment = .center

        plusLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(plusLabel)

        NSLayoutConstraint.activate([
            plusLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            plusLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
