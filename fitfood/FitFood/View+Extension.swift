//
//  ViewExtension.swift
//  FitFood
//
//  Created by YiGan on 26/05/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
extension UIView{
    func viewController() -> UIViewController?{
        var result: AnyObject? = self
        while result != nil {
            result = (result as! UIResponder).next
            if let res = result{
                if res.isKind(of: UIViewController.self) {
                    break
                }
            }else{
                return nil
            }
        }
        
        return result as? UIViewController
    }
}
