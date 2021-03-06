//
//  CalProgressView.swift
//  FitFood
//
//  Created by YiGan on 28/05/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
import CoreMotion
class MainView: UIView {
    
    //父视图
    private var mainVC: MainVC!
    
    //运动管理器
    let motionManager = CMMotionManager()
    
    //layer路径动画
    private let strokeAnim: CABasicAnimation = {
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.fromValue = 0
        anim.duration = 1.5
        anim.fillMode = kCAFillModeBoth
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        anim.isRemovedOnCompletion = false
        return anim
    }()
    
    //layer颜色动画
    private let colorAnim: CABasicAnimation = {
        let anim = CABasicAnimation(keyPath: "strokeColor")
        anim.fromValue = UIColor.yellow.cgColor
        anim.duration = 1.5
        anim.fillMode = kCAFillModeBoth
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        anim.isRemovedOnCompletion = false
        return anim
    }()
    
    //MARK:-当前摄入卡路里值
    var intakeCaloria: CGFloat = 0{
        didSet{
            
            guard intakeCaloria != oldValue else {
                return
            }
            
            let animKey = "novalue"
            if let weightItem = coredateHandler.currentWeightItem(){
                bottomShape.removeAnimation(forKey: animKey)
                bottomShape.lineWidth = 10
                
                var targetCaloria = weightItem.weight * 20
                var curTargetCaloria: Float = 0
                //计算基础消耗
                if let user = coredateHandler.currentUser(){
                    let weight = weightItem.weight //获取体重
                    let gender = user.gender                //获取性别
                    
                    let calendar = Calendar.current
                    let birthdayYear = calendar.component(.year, from: user.birthday! as Date)
                    let currentYear = calendar.component(.year, from: Date())
                    let age = currentYear - birthdayYear    //获取年龄
                    
                    var dailyCal: Float                     //获取日常消耗卡路里
                    if gender == 0 {    //女
                        if age > 18 && age < 30 {
                            dailyCal = weight * 14.6 + 450
                        }else if age >= 30 && age < 60{
                            dailyCal = weight * 8.6 + 830
                        }else if age >= 60{
                            dailyCal = weight * 10.4 + 600
                        }else{
                            dailyCal = weight * 8.6 + 450   //女性婴儿期(选最低标准)
                        }
                    }else{              //男
                        if age > 18 && age < 30 {
                            dailyCal = weight * 15.2 + 680
                        }else if age >= 30 && age < 60{
                            dailyCal = weight * 11.5 + 830
                        }else if age >= 60{
                            dailyCal = weight * 13.4 + 490
                        }else{
                            dailyCal = weight * 11.5 + 490  //男性婴儿期(选最低标准)
                        }
                    }
                    
                    if selectDate.isToday() {
                        let passIntervalTime = Float(selectDate.timeIntervalSince(coredateHandler.translate(selectDate)))
                        let beforeSleepIntervalTime: Float = 60 * 60 * 4        //一天结束前4小时
                        let beginingOfDayIntervalTime: Float = 60 * 60 * 5      //早晨5小时
                        var intervalTime = passIntervalTime - beginingOfDayIntervalTime
                        if intervalTime < 0{
                            intervalTime = 0
                        }
                        let timeProgress = intervalTime / (60 * 60 * 24 - beforeSleepIntervalTime - beginingOfDayIntervalTime)
                        curTargetCaloria = dailyCal * timeProgress
                    }else{
                        curTargetCaloria = dailyCal
                    }
                    targetCaloria = dailyCal
                }
                
                //添加路径动画
                strokeAnim.fromValue = Float(oldValue) / targetCaloria
                strokeAnim.toValue = Float(intakeCaloria) / targetCaloria
                frontShape.add(strokeAnim, forKey: nil)
                
                //获取颜色
                func getColor(withIntokenCaloria intokenCaloria: Float, targetCaloria: Float) -> CGColor{
                    var r: CGFloat = 255
                    var g: CGFloat = 255
                    let b: CGFloat = 0
                    
                    var deltaCaloria = fabsf(intokenCaloria - targetCaloria)
                    if intokenCaloria < targetCaloria {
                        r = CGFloat(1 - deltaCaloria / targetCaloria) * 155 + 100
                    }else{
                        let beyondCaloria: Float = 500
                        if deltaCaloria > beyondCaloria{
                            deltaCaloria = beyondCaloria
                        }
                        r = CGFloat(deltaCaloria / beyondCaloria) * 155 + 100
                        g = CGFloat(1 - deltaCaloria / beyondCaloria) * 155 + 100
                    }
                    
                    let color = UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
                    return color.cgColor
                }
                
                //添加颜色动画
                colorAnim.fromValue = getColor(withIntokenCaloria: Float(oldValue), targetCaloria: curTargetCaloria)
                colorAnim.toValue = getColor(withIntokenCaloria: Float(intakeCaloria), targetCaloria: curTargetCaloria)
                frontShape.add(colorAnim, forKey: nil)
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
    
    //MARK:-当前摄入的水份
    private var intakeWater: CGFloat = 0{
        didSet{
            
            guard intakeWater != oldValue else {
                return
            }
            
            let animKey = "wave"
            var paths: [CGPath]
            if let weightItem = coredateHandler.currentWeightItem(){
                let toValue = (1 - intakeWater / CGFloat(40 * weightItem.weight))
                
                paths = getWaterPathsAnim(with: toValue)
            }else{
                paths = getWaterPathsAnim(with: 1)
            }
            
            let anim = CAKeyframeAnimation(keyPath: "path")
            anim.values = paths
            anim.duration = 3
            anim.isRemovedOnCompletion = false
            anim.fillMode = kCAFillModeBoth
            anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            waterShape.add(anim, forKey: animKey)
        }
    }
    var waters: CGFloat = 0{
        didSet{
            intakeWater = waters
        }
    }
    
    //MARK:图形
    private let frontShape = CAShapeLayer()
    private let bottomShape = CAShapeLayer()
    private let waterShape = CAShapeLayer()
    
    private var xGravity: Double = 0{
        didSet{
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                self.waterShape.transform = CATransform3DMakeRotation(CGFloat(self.xGravity * 0.1), 0, 0, -1)
            }, completion: nil)
        }
    }
    
    private var isInit = false
    
    
    //MARK:- init ************************************************************************
    override func didMoveToSuperview() {
        
        if !isInit{
            isInit = true
            config()
            createContents()
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        
        drawWaterProgress()
        drawCalProgress()
        
        startGyroUpdates()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    // 开始获取陀螺仪数据
    func startGyroUpdates() {
        //判断设备支持情况
        guard motionManager.isGyroAvailable else {
            return
        }
        
        //设置刷新时间间隔
        motionManager.gyroUpdateInterval = 1
        
        
        //开始实时获取数据
        if let queue = OperationQueue.current{
            //重力
            motionManager.startDeviceMotionUpdates(to: queue, withHandler: {
                data, error in
                guard error == nil else {
                    print(error!)
                    return
                }
                // 有更新
                if self.motionManager.isDeviceMotionActive {
                    if let gravity = data?.gravity {
                        self.xGravity = gravity.x
                    }
                }
            })
        }
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
    
    //MARK:绘制水份进度
    private func drawWaterProgress(){
        waterShape.lineWidth = 0
        waterShape.fillColor = UIColor.blue.withAlphaComponent(0.1).cgColor
        layer.addSublayer(waterShape)
    }
        
    private func getWaterPathsAnim(with progress: CGFloat) -> [CGPath]{
        
        //直线开始点
        let point0 = CGPoint(x: view_size.width + 100, y: view_size.height * progress)
        //底部点
        let point1 = CGPoint(x: view_size.width + 100, y: view_size.height + 100)
        let point2 = CGPoint(x: -100, y: view_size.height + 100)
        
        
        //水波高度
        let minWaveHeight: CGFloat = 0
        let maxWaveHeight: CGFloat = 8
        let waveHeightCount: Int = 10
        let waveDelta: CGFloat = (minWaveHeight - maxWaveHeight) / CGFloat(waveHeightCount)
        let minWaveLength: CGFloat = 23
        let maxWaveLength: CGFloat = 45

        //绘制水
        var paths = [CGPath]()
        for (i, waveHeight) in stride(from: maxWaveHeight, to: minWaveHeight, by: waveDelta).enumerated(){
            
            //直线结束点
            let posX = -CGFloat(i) * (100 / CGFloat(waveHeightCount)) - 100
            let point3 = CGPoint(x: posX, y: view_size.height * progress)
            
            let bezier = UIBezierPath()
            bezier.move(to: point0)
            bezier.addLine(to: point1)
            bezier.addLine(to: point2)
            bezier.addLine(to: point3)
            
            
            //浪长
            let waveLength = minWaveLength + (maxWaveLength - minWaveLength) / CGFloat(waveHeightCount) * CGFloat(i)

            //绘制波浪
            for (j, wavePosX) in stride(from: point3.x, to: view_size.width, by: waveLength * 2).enumerated(){
                
                //起始波浪为平面
                var deltaHeight = waveHeight * (i % 2 == 0 ? 1 : -1) * ( j % 2 == 0 ? 1 : -1)
                if i == 0{
                    deltaHeight = 0
                }
                
                //浪高
                bezier.addQuadCurve(to: CGPoint(x: wavePosX,
                                                y: point3.y),
                                    controlPoint: CGPoint(x: wavePosX - waveLength / 2,
                                                          y: point3.y + deltaHeight))
            }

            bezier.close()
            
            paths.append(bezier.cgPath)
        }
        
        return paths
    }
}
