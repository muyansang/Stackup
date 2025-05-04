//
//  TaskCell.swift
//  A4
//
//  Created by muyan on 5/1/25.
//

import UIKit

class TaskCell: UITableViewCell {

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let bgView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(task: Task, rank: Int) {
        titleLabel.text = task.title
        subtitleLabel.text = task.subtitle ?? ""

        let priority = task.priority
        let color = [
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
        ][priority.clamped(to: 0...9)]


        bgView.backgroundColor = color
        self.backgroundColor = .clear
    }


    private func setup() {
        bgView.layer.cornerRadius = 16
        bgView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bgView)

        [titleLabel, subtitleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            bgView.addSubview($0)
        }

        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white

        subtitleLabel.font = UIFont.systemFont(ofSize: 13)
        subtitleLabel.textColor = .white
        subtitleLabel.numberOfLines = 2

        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            titleLabel.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 16),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 16),
            subtitleLabel.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -12)
        ])
    }
    
    func animateSelection() {
        UIView.animate(withDuration: 0.1,
                       animations: {
                           self.bgView.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
                       }, completion: { _ in
                           UIView.animate(withDuration: 0.1) {
                               self.bgView.transform = .identity
                           }
                       })
    }

}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
