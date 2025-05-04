//
//  SceneDelegate.swift
//  A4
//
//  Created by Vin Bui on 10/31/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        
        // Set the initial page as Logo View Controller
        let rootVC = LogoViewController()
        window.rootViewController = rootVC
        self.window = window
        window.makeKeyAndVisible()
    }
}
