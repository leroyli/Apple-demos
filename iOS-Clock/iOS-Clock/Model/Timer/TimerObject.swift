//
//  TimerObject.swift
//  iOS-Clock
//
//  Created by Leroy on 2022/11/7.
//

import UIKit

class TimerObject {
    var timer = Timer()
    
    func startTimer(timeIntervar: Double, selector: Selector, target: UIViewController?) {
        self.timer = Timer(timeInterval: timeIntervar, target: target, selector: selector, userInfo: nil, repeats: true)
        
        RunLoop.current.add(self.timer, forMode: .common)
    }
    
    func startTimer2(timeIntervar: Double, target: UIViewController, block: @escaping () -> Void) {
        self.timer = Timer.scheduledTimer(withTimeInterval: timeIntervar, repeats: true, block: { _ in
            block()
        })

        RunLoop.current.add(self.timer, forMode: .common)
    }

    func invalidate() {
        timer.invalidate()
    }
}
