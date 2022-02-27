//
//  SCNSolarSystem_iOSApp.swift
//  SCNSolarSystem-iOS
//
//  Created by Christophe on 27/02/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = self.window ?? UIWindow()
        self.window!.backgroundColor = UIColor.gray
        self.window!.rootViewController = ViewController()
        self.window!.makeKeyAndVisible()
        
        return true
    }
    
}
