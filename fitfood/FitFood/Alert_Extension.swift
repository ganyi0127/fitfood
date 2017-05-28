//
//  Alert_Extension.swift
//  FitFood
//
//  Created by YiGan on 28/05/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
extension UIAlertController{
    func setCustomStyle(){
        //设置所有action颜色
        actions.forEach{$0.setDefaultTextColor()}
    }
}

extension UIAlertAction{
    fileprivate func setDefaultTextColor(){
        setValue(word_default_color, forKey: "titleTextColor")
    }
}
