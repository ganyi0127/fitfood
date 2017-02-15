//
//  SpineNode.swift
//  SpineSwiftSample
//
//  Created by YiGan on 9/25/16.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit
class SpineNode: SKNode {
    
    //图片集
    private var atlas:SKTextureAtlas?
    
    var version:String?
    var currentSkinName = "default"
    var originSize:CGSize?
    
    var spineBoneList = [SpineBone]()
    var spineSlotList = [SpineSlot]()
    var animationNameList = [String]()
    var longestDurationMap = [String: TimeInterval]()
    
    //MARK:- init
    init(_ JSONName:String, atlasName:String, skinName:String?) {
        super.init()
        
        atlas = SKTextureAtlas(named: atlasName)
        
        //add JSON
        let jsonPath = Bundle.main.path(forResource: JSONName, ofType: "json")
        let json = NSDictionary(contentsOfFile: jsonPath!) as? [String: AnyObject]
        
        
        //info-------------------------------------------
        let skeleton = json?["skeleton"] as! [String: AnyObject]
        version = skeleton["spine"] as? String
        let width = skeleton["width"] as! CGFloat
        let height = skeleton["height"] as! CGFloat
        originSize = CGSize(width: width, height: height)
        
        //bones-------------------------------------------
        let bones = json?["bones"] as! [[String: AnyObject]]
        bones.forEach(){
            bone in
            
            let spineBone = SpineBone()
            spineBone.setup(JSON: bone)
            spineBoneList.append(spineBone)
        }
        //add_bones
        spineBoneList.forEach(){
            bone in
            
            if bone.parentName != nil{
                spineBoneList.forEach(){
                    parentBone in
                    if parentBone.name == bone.parentName{
                        parentBone.addChild(bone)
                    }
                }
            }else{
                addChild(bone)
            }
        }
        var dAngle:CGFloat = 0
        var parent:SKNode?
        spineBoneList.forEach(){
            bone in

            dAngle = 0
            if bone.inheritRotation == false {
                parent = bone.parent
                while let nextParent = parent {
                    if nextParent.isKind(of: SpineBone.self) {
                        dAngle = dAngle + nextParent.zRotation
                    }
                    parent = nextParent.parent
                }
            }
            bone.zRotation = bone.zRotation - dAngle
            bone.setDefaultAndBase()
        }
        
        //slots-------------------------------------------
        let slots = json?["slots"] as! [[String: AnyObject]]
        slots.enumerated().forEach(){
            index, slot in
            
            let spineSlot = SpineSlot()
            spineSlot.setup(slot, drawOrder: index)
            
            spineBoneList.forEach(){
                bone in
                if bone.name == spineSlot.parentName{
                    bone.addChild(spineSlot)
                }
            }
            
            spineSlotList.append(spineSlot)
        }
        
        if let result = skinName{
            currentSkinName = result
        }
        
        //skin-------------------------------------------
        let skin = (json?["skins"] as! [String: AnyObject])[currentSkinName] as! [String: AnyObject]
        skin.forEach(){
            (elementName, elementJSON) in
            
            var spineSlot = SpineSlot()
            spineSlotList.forEach(){
                slot in
                if slot.name == elementName{
                    spineSlot = slot
                }
            }
            
            (elementJSON as! [String: AnyObject]).forEach(){
                (attachmentName, attachmentJSON) in
                
                let spineAttachment = SpineAttachment(texture: atlas?.textureNamed(attachmentName))
                spineAttachment.setup(attachmentName, attributes: attachmentJSON as! [String: AnyObject])
                
                if let slotColor = spineSlot.color {
                    spineAttachment.color = slotColor
                    spineAttachment.colorBlendFactor = 0.5
                }
                    
                if spineAttachment.name == spineSlot.defaultAttachmentName{
                    spineAttachment.isHidden = false
                    spineSlot.currentAttachmentName = spineAttachment.name
                }
                
                spineSlot.addChild(spineAttachment)
            }
        }
        
        //animation-------------------------------------------
        let animationJSON = json?["animation"] as! [String: AnyObject]
        animationJSON.forEach(){
            animationName, animationData in
            
            animationNameList.append(animationName)
            
            let longestDuration = findLongestDuration(animationData: animationData as! [String : AnyObject])
            longestDurationMap[animationName] = longestDuration
            
            let slotAnimationMap = (animationData as! [String: AnyObject])["slots"]
            var slotList = [String]()
            
            (slotAnimationMap as! [String: AnyObject]).forEach(){
                slotName, timelineType in
                
                spineSlotList.forEach(){
                    slot in
                    if slot.name == slotName{
                        slotList.append(slotName)
                        slot.create
                    }
                }
            }
        }
    }
    
    private func findLongestDuration(animationData:[String: AnyObject]) -> TimeInterval {
        
        var longestDuration = TimeInterval(0)
        for (_, json1):(String, AnyObject) in animationData{
            for (_,json2):(String, AnyObject) in json1 as! [String: AnyObject] {
                for (_, json3):(String, AnyObject) in json2 as! [String: AnyObject] {
                    for(_,json4):(String, AnyObject) in json3 as! [String: AnyObject] {
                        let currentDuration = (json4 as! [String: AnyObject])["time"] as! Double
                        if longestDuration < currentDuration {
                            longestDuration = currentDuration
                        }
                    }
                }
            }
        }
        return longestDuration
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
