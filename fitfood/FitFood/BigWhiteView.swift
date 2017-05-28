//
//  BigWhiteView.swift
//  FitFood
//
//  Created by YiGan on 24/05/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class BigWhiteView: UIView {
    
    var top: CGFloat = 0
    var width: CGFloat = 0
    
    var weight: CGFloat = 0{
        didSet{
            drawBigWhite()
        }
    }
    
    var height: CGFloat = 0{
        didSet{
            drawBigWhite()
        }
    }
    
    var genderIsGirl = false{
        didSet{
            drawBigWhite()
        }
    }
    
    private var bigWhiteFillColor: UIColor{
        return genderIsGirl ? .magenta : .white
    }
    
    private let head = CAShapeLayer()           //static
    private let leftEye = CAShapeLayer()        //static
    private let rightEye = CAShapeLayer()       //static
    private let mouth = CAShapeLayer()          //static
    private let body = CAShapeLayer()
    private let leftHand = CAShapeLayer()
    private let rightHand = CAShapeLayer()
    private let leftLeg = CAShapeLayer()
    private let rightLeg = CAShapeLayer()
    private let shadow = CAShapeLayer()
    
    
    //箭头
    private lazy var upArrow: UIView = {
        return UIView()
    }()
    
    //MARK:- init******************************************
    init(){
        super.init(frame: CGRect(origin: .zero, size: view_size))
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        isUserInteractionEnabled = false
    }
    
    private func createContents(){
        
        //添加
        layer.addSublayer(shadow)
        body.addSublayer(leftHand)
        body.addSublayer(rightHand)
        head.addSublayer(leftEye)
        head.addSublayer(rightEye)
        head.addSublayer(mouth)
        body.addSublayer(head)
        layer.addSublayer(body)
        layer.addSublayer(leftLeg)
        layer.addSublayer(rightLeg)
        
    }
    
    private func drawBigWhite(){
        /*
         锚点定位到腿中间水平面
         */
        
        let offsetPoint = CGPoint(x: frame.width / 2, y: frame.height * 0.8)
        let offsetTransform = CGAffineTransform(translationX: offsetPoint.x, y: offsetPoint.y)
        
        //转换为大白的身高体重
        let bigWhiteWeight = weight * 2
        let bigWhiteHeight = height + 30
        
        let headWidthRadius: CGFloat = 20 + bigWhiteWeight * 0.05
        let headHeightRadius: CGFloat = 10 + bigWhiteHeight * 0.05
        let bodyWidthRadius: CGFloat = 10 + bigWhiteWeight * 0.15 - bigWhiteHeight * 0.02
        let bodyHeightRadius: CGFloat = 20 + bigWhiteHeight * 0.4
        let bodyHeadRadius: CGFloat = -bigWhiteHeight * 0.05
        let handShoulderRadius: CGFloat = 5 + bigWhiteHeight * 0.05
        let handWidthRadius: CGFloat = bigWhiteWeight * 0.1 - bigWhiteHeight * 0.02
        let handHeightRadius: CGFloat = 10 + bigWhiteHeight * 0.3
        let legWidthRadius: CGFloat = bigWhiteWeight * 0.05 + bigWhiteHeight * 0.01
        let legHeightRadius: CGFloat = bigWhiteHeight * 0.15
        
        let offsetLeftHandTransform = CGAffineTransform(translationX: -bodyWidthRadius * 0.8, y: -legHeightRadius * 2 - bodyHeightRadius * 1.3)
        let offsetRightHandTransform = CGAffineTransform(translationX: bodyWidthRadius * 0.8, y: -legHeightRadius * 2 - bodyHeightRadius * 1.3)
        
        let offsetLeftLegTransform = CGAffineTransform(translationX: -bodyWidthRadius * 0.3, y: 0)
        let offsetRightLegTransform = CGAffineTransform(translationX: bodyWidthRadius * 0.3, y: 0)
        
        let offsetBodyTransform = CGAffineTransform(translationX: 0, y: -legHeightRadius * 2 - bodyHeightRadius * 1.8)
        let offsetHeadTransform = CGAffineTransform(translationX: 0, y: -legHeightRadius * 2 - bodyHeightRadius * 1.8 + headHeightRadius * 0.5)
        
        let offsetMouthAndEyesTransform = CGAffineTransform(translationX: 0, y: -legHeightRadius * 2 - bodyHeightRadius * 1.8 + headHeightRadius * 0.5)
        
        
        top = offsetTransform.ty + offsetHeadTransform.ty - headHeightRadius
        width = bodyWidthRadius
        
        //绘制body
        let bodyBezier = UIBezierPath()
        bodyBezier.move(to: CGPoint(x: 0, y: -bodyHeadRadius).applying(offsetTransform).applying(offsetBodyTransform))
        bodyBezier.addCurve(to: CGPoint(x: bodyWidthRadius, y: bodyHeightRadius).applying(offsetTransform).applying(offsetBodyTransform),
                            controlPoint1: CGPoint(x: bodyWidthRadius * 0.5, y: -bodyHeadRadius).applying(offsetTransform).applying(offsetBodyTransform),
                            controlPoint2: CGPoint(x: bodyWidthRadius, y: -bodyHeadRadius).applying(offsetTransform).applying(offsetBodyTransform))
        bodyBezier.addCurve(to: CGPoint(x: 0, y: bodyHeightRadius * 2 - bodyHeadRadius).applying(offsetTransform).applying(offsetBodyTransform),
                            controlPoint1: CGPoint(x: bodyWidthRadius, y: bodyHeightRadius * 2 - bodyHeadRadius).applying(offsetTransform).applying(offsetBodyTransform),
                            controlPoint2: CGPoint(x: bodyWidthRadius, y: bodyHeightRadius * 2 - bodyHeadRadius).applying(offsetTransform).applying(offsetBodyTransform))
        bodyBezier.addCurve(to: CGPoint(x: -bodyWidthRadius, y: bodyHeightRadius).applying(offsetTransform).applying(offsetBodyTransform),
                            controlPoint1: CGPoint(x: -bodyWidthRadius, y: bodyHeightRadius * 2 - bodyHeadRadius).applying(offsetTransform).applying(offsetBodyTransform),
                            controlPoint2: CGPoint(x: -bodyWidthRadius, y: bodyHeightRadius * 2 - bodyHeadRadius).applying(offsetTransform).applying(offsetBodyTransform))
        bodyBezier.addCurve(to: CGPoint(x: 0, y: -bodyHeadRadius).applying(offsetTransform).applying(offsetBodyTransform),
                            controlPoint1: CGPoint(x: -bodyWidthRadius, y: -bodyHeadRadius).applying(offsetTransform).applying(offsetBodyTransform),
                            controlPoint2: CGPoint(x: -bodyWidthRadius * 0.5, y: -bodyHeadRadius).applying(offsetTransform).applying(offsetBodyTransform))
        bodyBezier.close()
        body.path = bodyBezier.cgPath
        body.fillColor = bigWhiteFillColor.cgColor
        
        
        //绘制left hand
        let leftHandBezier = UIBezierPath()
        leftHandBezier.move(to: CGPoint(x: 0, y: -handShoulderRadius).applying(offsetTransform).applying(offsetLeftHandTransform))
        leftHandBezier.addCurve(to: CGPoint(x: handWidthRadius, y: 0).applying(offsetTransform).applying(offsetLeftHandTransform),
                                controlPoint1: CGPoint(x: handWidthRadius, y: -handShoulderRadius).applying(offsetTransform).applying(offsetLeftHandTransform),
                                controlPoint2: CGPoint(x: handWidthRadius, y: -handShoulderRadius).applying(offsetTransform).applying(offsetLeftHandTransform))
        leftHandBezier.addCurve(to: CGPoint(x: 0, y: handHeightRadius * 2 - handShoulderRadius).applying(offsetTransform).applying(offsetLeftHandTransform),
                                controlPoint1: CGPoint(x: handWidthRadius, y: handHeightRadius).applying(offsetTransform).applying(offsetLeftHandTransform),
                                controlPoint2: CGPoint(x: handWidthRadius * 0.8, y: handHeightRadius * 2 - handShoulderRadius).applying(offsetTransform).applying(offsetLeftHandTransform))
        leftHandBezier.addCurve(to: CGPoint(x: -handWidthRadius, y: handHeightRadius).applying(offsetTransform).applying(offsetLeftHandTransform),
                                controlPoint1: CGPoint(x: -handWidthRadius * 0.8, y: handHeightRadius * 2 - handShoulderRadius).applying(offsetTransform).applying(offsetLeftHandTransform),
                                controlPoint2: CGPoint(x: -handWidthRadius, y: handHeightRadius * 2 - handShoulderRadius).applying(offsetTransform).applying(offsetLeftHandTransform))
        leftHandBezier.addCurve(to: CGPoint(x: 0, y: -handShoulderRadius).applying(offsetTransform).applying(offsetLeftHandTransform),
                                controlPoint1: CGPoint(x: -handWidthRadius * 0.6, y: 0).applying(offsetTransform).applying(offsetLeftHandTransform),
                                controlPoint2: CGPoint(x: -handWidthRadius * 0.1, y: -handShoulderRadius).applying(offsetTransform).applying(offsetLeftHandTransform))
        leftHandBezier.close()
        leftHand.path = leftHandBezier.cgPath
        leftHand.fillColor = bigWhiteFillColor.cgColor
        
        //绘制right hand
        let rightHandBezier = UIBezierPath()
        rightHandBezier.move(to: CGPoint(x: 0, y: -handShoulderRadius).applying(offsetTransform).applying(offsetRightHandTransform))
        rightHandBezier.addCurve(to: CGPoint(x: -handWidthRadius, y: 0).applying(offsetTransform).applying(offsetRightHandTransform),
                                 controlPoint1: CGPoint(x: -handWidthRadius, y: -handShoulderRadius).applying(offsetTransform).applying(offsetRightHandTransform),
                                 controlPoint2: CGPoint(x: -handWidthRadius, y: -handShoulderRadius).applying(offsetTransform).applying(offsetRightHandTransform))
        rightHandBezier.addCurve(to: CGPoint(x: 0, y: handHeightRadius * 2 - handShoulderRadius).applying(offsetTransform).applying(offsetRightHandTransform),
                                 controlPoint1: CGPoint(x: -handWidthRadius, y: handHeightRadius).applying(offsetTransform).applying(offsetRightHandTransform),
                                 controlPoint2: CGPoint(x: -handWidthRadius * 0.8, y: handHeightRadius * 2 - handShoulderRadius).applying(offsetTransform).applying(offsetRightHandTransform))
        rightHandBezier.addCurve(to: CGPoint(x: handWidthRadius, y: handHeightRadius).applying(offsetTransform).applying(offsetRightHandTransform),
                                 controlPoint1: CGPoint(x: handWidthRadius * 0.8, y: handHeightRadius * 2 - handShoulderRadius).applying(offsetTransform).applying(offsetRightHandTransform),
                                 controlPoint2: CGPoint(x: handWidthRadius, y: handHeightRadius * 2 - handShoulderRadius).applying(offsetTransform).applying(offsetRightHandTransform))
        rightHandBezier.addCurve(to: CGPoint(x: 0, y: -handShoulderRadius).applying(offsetTransform).applying(offsetRightHandTransform),
                                 controlPoint1: CGPoint(x: handWidthRadius * 0.6, y: 0).applying(offsetTransform).applying(offsetRightHandTransform),
                                 controlPoint2: CGPoint(x: handWidthRadius * 0.1, y: -handShoulderRadius).applying(offsetTransform).applying(offsetRightHandTransform))
        rightHandBezier.close()
        rightHand.path = rightHandBezier.cgPath
        rightHand.fillColor = bigWhiteFillColor.cgColor
        
        //绘制left leg
        let leftLegBezier = UIBezierPath()
        leftLegBezier.move(to: CGPoint(x: 0, y: -legHeightRadius * 2).applying(offsetTransform).applying(offsetLeftLegTransform))
        leftLegBezier.addCurve(to: CGPoint(x: legWidthRadius * 2 * 0.3, y: -legHeightRadius * 2 * 0.7).applying(offsetTransform).applying(offsetLeftLegTransform),
                               controlPoint1: CGPoint(x: legWidthRadius * 2 * 0.3, y: -legHeightRadius * 2).applying(offsetTransform).applying(offsetLeftLegTransform),
                               controlPoint2: CGPoint(x: legWidthRadius * 2 * 0.3, y: -legHeightRadius * 2).applying(offsetTransform).applying(offsetLeftLegTransform))
        leftLegBezier.addCurve(to: CGPoint.zero.applying(offsetTransform).applying(offsetLeftLegTransform),
                               controlPoint1: CGPoint(x: legWidthRadius * 2 * 0.3, y: -legHeightRadius * 2 * 0.2).applying(offsetTransform).applying(offsetLeftLegTransform),
                               controlPoint2: CGPoint(x: legWidthRadius * 2 * 0.1, y: 0).applying(offsetTransform).applying(offsetLeftLegTransform))
        leftLegBezier.addCurve(to: CGPoint(x: -legWidthRadius * 2 * 0.7, y: -legHeightRadius * 2 * 0.7).applying(offsetTransform).applying(offsetLeftLegTransform),
                               controlPoint1: CGPoint(x: -legWidthRadius, y: 0).applying(offsetTransform).applying(offsetLeftLegTransform),
                               controlPoint2: CGPoint(x: -legWidthRadius * 2 * 0.7, y: -legHeightRadius * 0.2).applying(offsetTransform).applying(offsetLeftLegTransform))
        leftLegBezier.addCurve(to: CGPoint(x: 0, y: -legHeightRadius * 2).applying(offsetTransform).applying(offsetLeftLegTransform),
                               controlPoint1: CGPoint(x: -legWidthRadius * 2 * 0.7, y: -legHeightRadius * 2).applying(offsetTransform).applying(offsetLeftLegTransform),
                               controlPoint2: CGPoint(x: -legWidthRadius * 2 * 0.7, y: -legHeightRadius * 2).applying(offsetTransform).applying(offsetLeftLegTransform))
        leftLegBezier.close()
        leftLeg.path = leftLegBezier.cgPath
        leftLeg.fillColor = bigWhiteFillColor.cgColor
        
        //绘制right leg
        let rightLegBezier = UIBezierPath()
        rightLegBezier.move(to: CGPoint(x: 0, y: -legHeightRadius * 2).applying(offsetTransform).applying(offsetRightLegTransform))
        rightLegBezier.addCurve(to: CGPoint(x: -legWidthRadius * 2 * 0.3, y: -legHeightRadius * 2 * 0.7).applying(offsetTransform).applying(offsetRightLegTransform),
                                controlPoint1: CGPoint(x: -legWidthRadius * 2 * 0.3, y: -legHeightRadius * 2).applying(offsetTransform).applying(offsetRightLegTransform),
                                controlPoint2: CGPoint(x: -legWidthRadius * 2 * 0.3, y: -legHeightRadius * 2).applying(offsetTransform).applying(offsetRightLegTransform))
        rightLegBezier.addCurve(to: CGPoint.zero.applying(offsetTransform).applying(offsetRightLegTransform),
                                controlPoint1: CGPoint(x: -legWidthRadius * 2 * 0.3, y: -legHeightRadius * 2 * 0.2).applying(offsetTransform).applying(offsetRightLegTransform),
                                controlPoint2: CGPoint(x: -legWidthRadius * 2 * 0.1, y: 0).applying(offsetTransform).applying(offsetRightLegTransform))
        rightLegBezier.addCurve(to: CGPoint(x: legWidthRadius * 2 * 0.7, y: -legHeightRadius * 2 * 0.7).applying(offsetTransform).applying(offsetRightLegTransform),
                                controlPoint1: CGPoint(x: legWidthRadius, y: 0).applying(offsetTransform).applying(offsetRightLegTransform),
                                controlPoint2: CGPoint(x: legWidthRadius * 2 * 0.7, y: -legHeightRadius * 0.2).applying(offsetTransform).applying(offsetRightLegTransform))
        rightLegBezier.addCurve(to: CGPoint(x: 0, y: -legHeightRadius * 2).applying(offsetTransform).applying(offsetRightLegTransform),
                                controlPoint1: CGPoint(x: legWidthRadius * 2 * 0.7, y: -legHeightRadius * 2).applying(offsetTransform).applying(offsetRightLegTransform),
                                controlPoint2: CGPoint(x: legWidthRadius * 2 * 0.7, y: -legHeightRadius * 2).applying(offsetTransform).applying(offsetRightLegTransform))
        rightLegBezier.close()
        rightLeg.path = rightLegBezier.cgPath
        rightLeg.fillColor = bigWhiteFillColor.cgColor
        
        //绘制head
        let headBezier = UIBezierPath()
        headBezier.move(to: CGPoint(x: -headWidthRadius, y: 0).applying(offsetTransform).applying(offsetHeadTransform))
        headBezier.addCurve(to: CGPoint(x: 0, y: -headHeightRadius).applying(offsetTransform).applying(offsetHeadTransform),
                            controlPoint1: CGPoint(x: -headWidthRadius, y: -headHeightRadius * 0.8).applying(offsetTransform).applying(offsetHeadTransform),
                            controlPoint2: CGPoint(x: -headWidthRadius * 0.8, y: -headHeightRadius * 0.9).applying(offsetTransform).applying(offsetHeadTransform))
        headBezier.addCurve(to: CGPoint(x: headWidthRadius, y: 0).applying(offsetTransform).applying(offsetHeadTransform),
                            controlPoint1: CGPoint(x: headWidthRadius * 0.8, y: -headHeightRadius * 0.9).applying(offsetTransform).applying(offsetHeadTransform),
                            controlPoint2: CGPoint(x: headWidthRadius, y: -headHeightRadius * 0.8).applying(offsetTransform).applying(offsetHeadTransform))
        headBezier.addCurve(to: CGPoint(x: 0, y: headHeightRadius).applying(offsetTransform).applying(offsetHeadTransform),
                            controlPoint1: CGPoint(x: headWidthRadius, y: headHeightRadius * 0.8).applying(offsetTransform).applying(offsetHeadTransform),
                            controlPoint2: CGPoint(x: headWidthRadius * 0.8, y: headHeightRadius * 0.9).applying(offsetTransform).applying(offsetHeadTransform))
        headBezier.addCurve(to: CGPoint(x: -headWidthRadius, y: 0).applying(offsetTransform).applying(offsetHeadTransform),
                            controlPoint1: CGPoint(x: -headWidthRadius * 0.8, y: headHeightRadius * 0.9).applying(offsetTransform).applying(offsetHeadTransform),
                            controlPoint2: CGPoint(x: -headWidthRadius, y: headHeightRadius * 0.8).applying(offsetTransform).applying(offsetHeadTransform))
        headBezier.close()
        head.path = headBezier.cgPath
        head.fillColor = bigWhiteFillColor.cgColor
        head.shadowColor = UIColor.gray.cgColor
        head.shadowRadius = 4
        head.shadowOffset = CGSize(width: 0, height: 2)
        
        //绘制left eye
        let leftEyeBezier = UIBezierPath(arcCenter: CGPoint(x: -headWidthRadius * 0.6, y: 0).applying(offsetTransform).applying(offsetMouthAndEyesTransform),
                                         radius: headWidthRadius * 0.2,
                                         startAngle: 0,
                                         endAngle: .pi * 2,
                                         clockwise: true)
        leftEye.path = leftEyeBezier.cgPath
        
        //随机执行left eye动画
        /*
        let animKey = "lefteye"
        let random = arc4random_uniform(100)
        if random == 0 && leftEye.animation(forKey: animKey) == nil{
            let leftEyeCloseBezier = UIBezierPath(rect: CGRect(x: -headWidthRadius * 0.6 - headWidthRadius * 0.2, y: -1, width: headWidthRadius * 0.2, height: 2).applying(offsetTransform).applying(offsetMouthAndEyesTransform))
            leftEye.fillColor = UIColor.black.cgColor
            let eyesAnim = CAKeyframeAnimation(keyPath: "path")
            eyesAnim.keyTimes = [0, 1]
            eyesAnim.values = [leftEyeBezier.cgPath, leftEyeCloseBezier.cgPath]
            eyesAnim.duration = 1
            eyesAnim.isRemovedOnCompletion = true
            eyesAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            eyesAnim.fillMode = kCAFillModeBoth
            leftEye.add(eyesAnim, forKey: animKey)
        }
         */
        
        //绘制right eye
        let rightEyeBezier = UIBezierPath(arcCenter: CGPoint(x: headWidthRadius * 0.6, y: 0).applying(offsetTransform).applying(offsetMouthAndEyesTransform), radius: headWidthRadius * 0.2, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        rightEye.path = rightEyeBezier.cgPath
        rightEye.fillColor = UIColor.black.cgColor
        
        //绘制mouth
        let mouthBezier = UIBezierPath()
        mouthBezier.move(to: CGPoint(x: -headWidthRadius * 0.6, y: 0).applying(offsetTransform).applying(offsetMouthAndEyesTransform))
        mouthBezier.addLine(to: CGPoint(x: headWidthRadius * 0.6, y: 0).applying(offsetTransform).applying(offsetMouthAndEyesTransform))
        mouth.path = mouthBezier.cgPath
        mouth.lineWidth = 2
        mouth.strokeColor = UIColor.black.cgColor
        
        //绘制shadow
        let shadowBezier = UIBezierPath(ovalIn: CGRect(x: -bodyWidthRadius, y: -view_size.height * 0.01, width: bodyWidthRadius * 2, height: view_size.height * 0.01 * 2).applying(offsetTransform))
        shadow.path = shadowBezier.cgPath
        shadow.fillColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        shadow.shadowRadius = 5
    }
}
