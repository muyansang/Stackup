//
//  LogoView.swift
//  A4
//
//  Created by muyan on 4/29/25.
//


import UIKit

class LogoView: UIView {

    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 255/255, green: 83/255, blue: 83/255, alpha: 1.0)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = UIColor(red: 255/255, green: 83/255, blue: 83/255, alpha: 1.0)
        setupView()
    }

    private func setupView() {
        addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
}
