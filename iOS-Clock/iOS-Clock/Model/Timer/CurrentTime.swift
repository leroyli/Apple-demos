//
//  CurrentTime.swift
//  iOS-Clock
//
//  Created by Leroy on 2022/11/7.
//

import UIKit

class CurrentTime: UIView {
    static let shared = CurrentTime()
    var date = Date()
    var calendar = Calendar.current
    
    func getCurrentTime() -> (hour: Int, min: Int, sec: Int) {
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        return (hour, minutes, seconds)
    }
    
    func updateTime() {
        if #available(iOS 15, *) {
            date = Date.now
        } else {
            // Fallback on earlier versions
            
        }
        calendar = Calendar.current
    }
}
