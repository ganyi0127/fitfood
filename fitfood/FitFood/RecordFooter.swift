//
//  RecordFooter.swift
//  FitFood
//
//  Created by YiGan on 08/06/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class RecordFooter: UIView {
    
    private var type: RecordType!
    
    //MARK:- init ***************************************************************************
    init(originY: CGFloat){
        let frame = CGRect(x: 0, y: originY, width: view_size.width - 8 * 2, height: 8)
        super.init(frame: frame)
        
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        backgroundColor = .clear
        
        //绘制背景
        let radius: CGFloat = 2
        let bezier = UIBezierPath()
        bezier.move(to: .zero)
        bezier.addLine(to: CGPoint(x: 0, y: frame.height - radius))
        bezier.addQuadCurve(to: CGPoint(x: radius, y: frame.height), controlPoint: CGPoint(x: 0, y: frame.height))
        bezier.addLine(to: CGPoint(x: frame.width - radius, y: frame.height))
        bezier.addQuadCurve(to: CGPoint(x: frame.width, y: frame.height - radius), controlPoint: CGPoint(x: frame.width, y: frame.height))
        bezier.addLine(to: CGPoint(x: frame.width, y: 0))
        bezier.addLine(to: .zero)
        bezier.close()
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezier.cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 0
        layer.addSublayer(shapeLayer)
    }
}
