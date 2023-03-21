//
//  SceneDelegate.swift
//  Notes
//
//  Created by Natalia Pashkova on 21.03.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let sceneWindow = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: sceneWindow)
        self.window = window
        let nav = UINavigationController()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
         guard let vc = storyboard.instantiateViewController(identifier: "NotesViewController") as? NotesViewController else {
             print("ViewController not found")
             return
         }
        nav.viewControllers = [vc]
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }
}

