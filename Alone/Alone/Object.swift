//
//  Object.swift
//  Alone
//
//  Created by YiGan on 06/12/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit

class Object: SKSpriteNode {
    var type: ObjectType!
    var destroyable = false
    
    //MARK:- init
    init(type: ObjectType){
        let texName: String = objectNameMap[type]!
        let tex = atlas.textureNamed(texName)
        super.init(texture: tex, color: .clear, size: tex.size())
        
        self.type = type
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        zPosition = ZPos.object
        
        //添加物理体
        physicsBody = {
            let physics: SKPhysicsBody = SKPhysicsBody(rectangleOf: size)
            physics.categoryBitMask = Mask.box
            physics.affectedByGravity = false
            physics.isDynamic = false
            physics.mass = 0.5
            return physics
        }()
    }
    
    private func createContents(){
        
    }
}
