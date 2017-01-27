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
    
    private var edit = false
    
    //MARK:- init
    init(type: ObjectType, edit: Bool = false){
        let texName: String = objectNameMap[type]!
        let tex = atlas.textureNamed(texName)
        super.init(texture: tex, color: .clear, size: tex.size())
        
        self.type = type
        self.edit = edit
        
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        zPosition = ZPos.object
        
        //编辑状态下直接返回
        guard !edit else {
            return
        }
        
        //添加物理体
        physicsBody = {
            let physics: SKPhysicsBody = SKPhysicsBody(rectangleOf: size)
            physics.categoryBitMask = Mask.box
            physics.affectedByGravity = false
            physics.isDynamic = false
            physics.mass = 0.5
            return physics
        }()
        
        //特殊逻辑
        switch type as ObjectType {
        case .bird:
            physicsBody?.categoryBitMask = Mask.bad
            
            //动作
            randomAction()

        case .plat:
            physicsBody?.categoryBitMask = Mask.finish
        default:
            break
        }
    }
    
    private func createContents(){
        
    }
    
    //MARK:- 随机动作
    private func randomAction(){
        
        let posY: CGFloat = 500
        let toMovAct = { () -> SKAction in
            let action = SKAction.moveBy(x: 0, y: posY, duration: 1)
            action.timingMode = .easeInEaseOut
            return action
        }()

        let fromMovAct = { () -> SKAction in
            let action = SKAction.moveBy(x: 0, y: -posY, duration: 1)
            action.timingMode = .easeInEaseOut
            return action
        }()
        let seqAct = SKAction.sequence([toMovAct, fromMovAct])
        let action = SKAction.repeatForever(seqAct)
        run(action)
    }
}
