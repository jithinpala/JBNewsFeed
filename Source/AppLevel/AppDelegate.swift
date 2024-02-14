//
//  AppDelegate.swift
//  JBNewsFeed
//
//  Created by Jithin Balan on 30/8/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        setRootViewController(for: &window)
        return true
    }
    
    private func setRootViewController(for window: inout UIWindow?) {
        let viewModel = NewsListViewModel()
        let newsListViewController = NewsListViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: newsListViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

