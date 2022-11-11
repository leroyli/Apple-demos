//
//  Day.swift
//  iOS-Clock
//
//  Created by Leroy on 2022/11/7.
//

import UIKit

enum Day:Int, Codable, CaseIterable{
    case Sun = 0,Mon,Tue,Wed,Thu,Fri,Sat
    
    var dayString:String{
        switch self{
            case .Sun: return "Every Sunday"
            case .Mon: return "Every Monday"
            case .Tue: return "Every Tuesday"
            case .Wed: return "Every Wednesday"
            case .Thu: return "Every Thursday"
            case .Fri: return "Every Friday"
            case .Sat: return "Every Saturday"
        }
    }
    
    var dayText:String{
        switch self{
            case .Sun: return "Sun"
            case .Mon: return "Mon"
            case .Tue: return "Tue"
            case .Wed: return "Wed"
            case .Thu: return "Thu"
            case .Fri: return "Fri"
            case .Sat: return "Sat"
        }
    }
    
}
