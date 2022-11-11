//
//  TabbarViewController.swift
//  iOS-Clock
//
//  Created by Leroy on 2022/11/7.
//

import UIKit

class TabbarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbar()
    }
    
    func setupTabbar(){
        let alarmNav = UINavigationController(rootViewController: AlarmController())
        let timerNav = UINavigationController(rootViewController: TimerController())
        
        alarmNav.tabBarItem.image = UIImage(systemName: "alarm.fill")
        timerNav.tabBarItem.image = UIImage(systemName: "timer")
        
        alarmNav.title = "Alarm"
        timerNav.title = "Timer"
        
        
        self.tabBar.barTintColor = .clear
        self.tabBar.tintColor = .orange
        
        setViewControllers([alarmNav, timerNav], animated: false)
        
        alarmNav.navigationBar.prefersLargeTitles = true
        alarmNav.navigationBar.largeTitleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.white,
         .font: UIFont.boldSystemFont(ofSize: 34)]
    }
    
}
