//
//  SceneDelegate.swift
//  RxGithub
//
//  Created by Michal Ziobro on 22/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import UIKit
import Firebase

import Swinject
import SwinjectStoryboard

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var container: Container!


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        setup()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate {
    
    private func setup() {
        
        // DI
        container = Container() { container in
            
            // Model
            container.register(NetworkType.self) { _ in
                Network()
            }
            
            container.register(GithubServiceType.self) { r in
                GithubService(network: r.resolve(NetworkType.self)!)
            }
            
            container.register(CommentServiceType.self) { r in
                CommentService()
            }
            
            // View Model
            container.register(SearchViewModelType.self) { r in
                SearchViewModel(
                    network: r.resolve(NetworkType.self)!,
                    service: r.resolve(GithubServiceType.self)!,
                    commentService: r.resolve(CommentServiceType.self)!)
            }
            
            // Views
            container.storyboardInitCompleted(UINavigationController.self) { _, _ in }
            container.storyboardInitCompleted(SearchViewController.self) { r, c in
                c.viewModel = r.resolve(SearchViewModelType.self)
            }
            container.storyboardInitCompleted(ProfileViewController.self) { _, _ in }
            container.storyboardInitCompleted(CommentsViewController.self) { _, _ in }
        }
        
        // Firebase
        FirebaseApp.configure()
        
        // Initial Screen
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        
        self.window = window
        
        let bundle = Bundle(for: SearchViewController.self)
        let storyboard = SwinjectStoryboard.create(name: "Main", bundle: bundle, container: container)
        window.rootViewController = storyboard.instantiateInitialViewController()
    }
}
