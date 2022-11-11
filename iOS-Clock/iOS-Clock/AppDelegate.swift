//
//  AppDelegate.swift
//  iOS-Clock
//
//  Created by Leroy on 2022/11/3.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let vc = TabbarViewController()
        window?.rootViewController = vc
        setupNotification()
        
        return true
    }
    
    func setupNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge, .carPlay], completionHandler: { (granted, error) in
            if granted {
                 print("accept")
            } else {
                 print("not accept")
            }
        })
        
        UNUserNotificationCenter.current().delegate = self
    }

}


