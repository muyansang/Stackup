//
//  LogoViewController.swift
//  A4
//
//  Created by Vin Bui on 10/31/23.
//

import UIKit

class LogoViewController: UIViewController {

    override func loadView() {
        self.view = LogoView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
    }

    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
            self.transitionToNextScreen()
        }
    }

    private func transitionToNextScreen() {
        let projectVC = ProjectViewController()
        let nav = UINavigationController(rootViewController: projectVC)
        nav.setNavigationBarHidden(true, animated: false)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = nav
            window.makeKeyAndVisible()
        }
    }
}
