//
//  ImageExtension.swift
//  FontLib
//
//  Created by YiGan on 23/01/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
extension UIImage{
    //MARK:- 根据尺寸重新绘制图像
    func transfromImage(size: CGSize) -> UIImage?{
        let resultSize = CGSize(width: size.width * 2, height: size.height * 2)
        UIGraphicsBeginImageContext(resultSize)
        self.draw(in: CGRect(origin: .zero, size: resultSize))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImage(cgImage: result!.cgImage!, scale: 2, orientation: UIImageOrientation.up)
    }
}
