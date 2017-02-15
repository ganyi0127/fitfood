//
//  SpineBone.swift
//  SpineSwiftSample
//
//  Created by YiGan on 9/25/16.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit
class SpineBone: SKSpriteNode {
    
    var parentName:String?
    var length:CGFloat?
    var inheritRotation = true
    var inheritScale = true
    
    private var defaultPosition = CGPoint.zero
    private var defaultXScale:CGFloat = 1
    private var defaultYScale:CGFloat = 1
    private var defaultRotation:CGFloat = 0
    private var basePosition = CGPoint.zero
    private var baseXScale:CGFloat = 1
    private var baseYScale:CGFloat = 1
    private var baseRotation:CGFloat = 0
    
    func setup(JSON: [String: AnyObject]){
        
        name = JSON["name"] as? String
        
        if let result = JSON["parent"]{
            parentName = result as? String
        }
        
        if let result = JSON["length"]{
            length = result as? CGFloat
            size.width = length!
        }
        
        if let x = JSON["x"], let y = JSON["y"]{
            position = CGPoint(x: x as! CGFloat, y: y as! CGFloat)
        }
        
        if let result = JSON["scaleX"]{
            xScale = result as! CGFloat
        }
        
        if let result = JSON["scaleY"]{
            yScale = result as! CGFloat
        }
        
        if let result = JSON["rotation"]{
            zRotation = (result as! CGFloat) * CGFloat(M_PI) / 180
        }
        
        if let result = JSON["inheritRotation"]{
            inheritRotation = result as! Bool
        }
        
        if let result = JSON["inheritScale"]{
            inheritScale = result as! Bool
        }
    }
    
    func setDefaultAndBase(){
        
        defaultPosition = position
        defaultRotation = zRotation
        defaultXScale = xScale
        defaultYScale = yScale
        basePosition = position
        baseRotation = zRotation
        baseXScale = xScale
        baseYScale = yScale
    }
}
