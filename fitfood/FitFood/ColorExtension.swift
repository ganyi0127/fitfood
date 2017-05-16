//
//  ColorExtension.swift
//  FitFood
//
//  Created by YiGan on 15/05/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
extension UIColor{
    convenience init(colorHex hex: UInt, alpha: CGFloat = 1) {
        var aph = alpha
        if aph < 0 {
            aph = 0
        }
        self.init(red: CGFloat((hex & 0xFF0000) >> 16) / 255,
                  green: CGFloat((hex & 0x00FF00) >> 8) / 255,
                  blue: CGFloat(hex & 0x0000FF) / 255,
                  alpha: alpha)
    }
}
