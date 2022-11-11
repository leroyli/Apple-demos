//
//  Notification.swift
//  iOS-Clock
//
//  Created by Leroy on 2022/11/7.
//

import UIKit
import NotificationCenter
import AVFoundation


class UserNotification{
    var contentHandler: ((UNNotificationContent) -> Void)?
    
    static func addNotificationRequest(alarm: AlarmInfo) {
        
        let current = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Clock"
        content.subtitle = "Alarm"
        content.categoryIdentifier = "alarm"
        content.sound = .default
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: alarm.date)
        let minute = calendar.component(.minute, from: alarm.date)
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.id.uuidString, content: content, trigger: trigger)
        current.add(request) { error in
            if(error == nil){
                print("successfully")
            }else{
                print("error")
            }
        }
    }
    
    static func addTimerNotification() {
        let current = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Timer"
        content.subtitle = "Timer Ended"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)

        current.add(request)
    }

}


extension AppDelegate:UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        completionHandler([.sound, .badge, .banner])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        print("did tap notification")
        completionHandler()
    }
}
