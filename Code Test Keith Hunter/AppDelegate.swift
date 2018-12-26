//
//  AppDelegate.swift
//  Code Test Keith Hunter
//
//  Created by Keith Hunter on 12/21/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let store = FlatFileDataStore.shared
        if store.fetchAllContacts().isEmpty {
            try! store.prepopulate()
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: ContactListViewController(store: store))
        window?.makeKeyAndVisible()
        
        return true
    }

}
