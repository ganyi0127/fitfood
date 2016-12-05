//
//  Box.swift
//  Alone
//
//  Created by YiGan on 01/12/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit
class Platform: SKSpriteNode {
    init(){
        super.init(texture: nil, color: .yellow, size: CGSize(width: 200, height: 50))
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        position = CGPoint(x: win_size.width * 0.3, y: win_size.height / 2)
        zPosition = ZPos.box
    }
    
    private func createContents(){
        
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
}
