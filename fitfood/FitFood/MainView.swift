//
//  CalProgressView.swift
//  FitFood
//
//  Created by YiGan on 28/05/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class MainView: UIView {
    
    //父视图
    private var mainVC: MainVC!
    
    //layer动画
    private let strokeAnim: CABasicAnimation = {
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.fromValue = 0
        anim.duration = 1.5
        anim.fillMode = kCAFillModeBoth
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        anim.isRemovedOnCompletion = false
        return anim
    }()
    
    //MARK:-当前摄入卡路里值
    var intakeCaloria: CGFloat = 0{
        didSet{
            let animKey = "novalue"
            if let weighItem = coredateHandler.currentWeightItem(){
                bottomShape.removeAnimation(forKey: animKey)
                bottomShape.lineWidth = 10
                
                strokeAnim.toValue = Float(intakeCaloria) / (20 * weighItem.weight)
                frontShape.add(strokeAnim, forKey: nil)
                
                
            }else{
                let anim = CAKeyframeAnimation(keyPath: "opacity")
                anim.values = [2, 0.5, 2]
                anim.keyTimes = [0, 0.5, 1]
                anim.duration = 1.5
                anim.fillMode = kCAFillModeBoth
                anim.repeatCount = HUGE
                anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                anim.isRemovedOnCompletion = false
                bottomShape.add(anim, forKey: animKey)
            }
        }
    }
    
    //MARK:图形
    private let frontShape = CAShapeLayer()
    private let bottomShape = CAShapeLayer()
    
    
    //MARK:- init ************************************************************************
    override func didMoveToSuperview() {
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        config()
        createContents()
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        
        drawCalProgress()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    //MARK:绘制cal进度条
    private func drawCalProgress(){
        
        mainVC = viewController() as! MainVC
        
        //主按钮
        let mainButtonFrame = mainVC.mainButton.frame
        
        //目标视图
        let targetViewFrame = mainVC.targetView.frame
        
        //临时参数
        let beginHeight = mainButtonFrame.origin.y                                                  //开始点高度
        let endHeight = targetViewFrame.origin.y + targetViewFrame.height - naviagtion_height!      //结束点高度
        let height = beginHeight - endHeight                                                        //整体高度
        let subsectionCount = 6                                                                     //分段数
        let ailgnHeight: CGFloat = 20                                                               //两端高度
        let intervalHeight = (height - ailgnHeight * 2) / CGFloat(subsectionCount - 2)              //中间段高度
        let smallRadius: CGFloat = 10                                                               //小圈半径
        let bigRadius = intervalHeight / 2                                                          //大圈半径
        let halfWidth = (frame.width * 0.85 - bigRadius * 2) / 2                                     //左右偏差范围
        
        //创建贝塞尔曲线
        let bezier = UIBezierPath()
        for i in 0..<(subsectionCount + 2) {
            if i == 0 {
                //开始
                bezier.move(to: CGPoint(x: frame.width / 2, y: beginHeight))
            }else if i == 1{
                //第一个小圈
                bezier.addArc(withCenter: CGPoint(x: frame.width / 2 + smallRadius, y: beginHeight - ailgnHeight + smallRadius),
                              radius: smallRadius,
                              startAngle: -.pi,
                              endAngle: -.pi / 2,
                              clockwise: true)
            }else if i == subsectionCount{
                //最后一个小圈
                bezier.addArc(withCenter: CGPoint(x: frame.width / 2 - smallRadius, y: endHeight + ailgnHeight - smallRadius),
                              radius: smallRadius,
                              startAngle: .pi / 2,
                              endAngle: 0,
                              clockwise: false)
            }else if i == subsectionCount + 1{
                //结束
                bezier.addLine(to: CGPoint(x: frame.width / 2, y: endHeight))
            }else{
                let isRightDirection = i % 2 == 0
                let centerX = frame.width / 2 + halfWidth * (isRightDirection ? 1 : -1)
                bezier.addArc(withCenter: CGPoint(x: centerX, y: beginHeight - ailgnHeight - CGFloat(i - 1) * intervalHeight + bigRadius),
                              radius: bigRadius,
                              startAngle: .pi / 2,
                              endAngle: -.pi / 2,
                              clockwise: !isRightDirection)
            }
        }
        
        //绘制底部图形
        bottomShape.path = bezier.cgPath
        bottomShape.lineWidth = 10
        bottomShape.strokeColor = UIColor.lightGray.cgColor
        bottomShape.fillColor = nil
        bottomShape.lineCap = kCALineCapButt
        layer.addSublayer(bottomShape)
        
        //绘制前层图形
        frontShape.path = bezier.cgPath
        frontShape.lineWidth = 12
        frontShape.strokeColor = UIColor.green.cgColor
        frontShape.fillColor = nil
        frontShape.lineCap = kCALineCapButt
        layer.addSublayer(frontShape)
        
        //动画
        strokeAnim.toValue = 0.0
        frontShape.add(strokeAnim, forKey: nil)
    }
}
