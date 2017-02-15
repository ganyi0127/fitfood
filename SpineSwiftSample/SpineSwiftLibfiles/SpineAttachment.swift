//
//  SpineAttachment.swift
//  SpineSwiftSample
//
//  Created by YiGan on 9/26/16.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit
class SpineAttachment: SKSpriteNode {
    
    var action = [String: SKAction]()
    
    func setup(_ attachmentName: String, attributes: [String: AnyObject]){
        
        name = attachmentName
        
        if let x = attributes["x"], let y = attributes["y"]{
            let posX = x as! CGFloat
            let posY = y as! CGFloat
            position = CGPoint(x: posX, y: posY)
        }
        
        if let result = attributes["scaleX"]{
            xScale = result as! CGFloat
        }
        
        if let result = attributes["scaleY"]{
            yScale = result as! CGFloat
        }
        
        if let result = attributes["rotation"]{
            zRotation = (result as! CGFloat) * CGFloat(M_PI) / 180
        }
        
        let width = attributes["width"] as! CGFloat
        let height = attributes["height"] as! CGFloat
        size = CGSize(width: width, height: height)
        
        isHidden = true
    }
    
    func createAnimation(animationName:String, attachmentTimelines:[String: AnyObject], longestDuration:TimeInterval) {
        var duration:TimeInterval = 0
        var elapsedTime:TimeInterval = 0
        var actionSequenceForAttachment = [SKAction]()
        
        attachmentTimelines.forEach(){
            _, timeline in
            
            
            duration = TimeInterval((timeline as! [String: AnyObject])["time"] as! Double) - elapsedTime
            elapsedTime = TimeInterval((timeline as! [String: AnyObject])["time"] as! Double)
            actionSequenceForAttachment.append(SKAction.wait(forDuration: duration))
            if name == (timeline as! [String: AnyObject])["name"] as? String {
                actionSequenceForAttachment.append(SKAction.unhide())
            } else {
                actionSequenceForAttachment.append(SKAction.hide())
            }
        }
     
     
        let gabageTime = longestDuration - elapsedTime
        let gabageAction = SKAction.wait(forDuration: gabageTime)
        actionSequenceForAttachment.append(gabageAction)
        
        
        action[animationName] = SKAction.sequence(actionSequenceForAttachment)
     
    }
}
