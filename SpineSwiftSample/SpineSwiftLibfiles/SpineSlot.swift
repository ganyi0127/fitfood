//
//  SpineSlot.swift
//  SpineSwiftSample
//
//  Created by YiGan on 9/26/16.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit
class SpineSlot: SKNode {
    
    var parentName:String?
    var color:UIColor?
    var currentAttachmentName:String?
    var defaultAttachmentName:String?
    
    func setup(_ slotJSON:[String: AnyObject], drawOrder:Int) {
        
        
        name = slotJSON["name"] as? String
        parentName = slotJSON["bone"] as? String
        
        if let result = slotJSON["color"]{
            color = result as? UIColor
        }
        
        defaultAttachmentName = slotJSON["attachment"] as? String
        zPosition = CGFloat(drawOrder) * 0.01
    }
    
    func createAnimation(_ animationName: String, timelineTypes: )
}
