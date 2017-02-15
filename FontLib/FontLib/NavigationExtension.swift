//
//  NavigationExtension.swift
//  FontLib
//
//  Created by YiGan on 22/01/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
extension UINavigationController{
    open override func awakeFromNib() {
        navigationBar.backgroundColor = default_color
        
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }
}
