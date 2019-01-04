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
        
        if AppDefaults.firstUse {
            try! store.prepopulate()
            AppDefaults.firstUse = false
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: ContactListViewController(store: store))
        window?.makeKeyAndVisible()
        
        return true
    }

}

private struct AppDefaults {
    
    private static let firstUseKey = "isFirstUse"
    
    static var firstUse: Bool {
        get {
            guard let isFirstUse = UserDefaults.standard.object(forKey: AppDefaults.firstUseKey) as? Bool else {
                return true
            }
            return isFirstUse
        }
        set { UserDefaults.standard.set(newValue, forKey: AppDefaults.firstUseKey) }
    }
    
}
