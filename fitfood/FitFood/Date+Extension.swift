//
//  Date+Extension.swift
//  FitFood
//
//  Created by YiGan on 16/06/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
extension Date{
    func isToday() -> Bool{
        let format = DateFormatter()
        format.dateFormat = "yyy-M-d"
        let str = format.string(from: self)
        let todayStr = format.string(from: Date())
        return str == todayStr
    }
}
