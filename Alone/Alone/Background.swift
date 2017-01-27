//
//  Background.swift
//  Alone
//
//  Created by YiGan on 29/11/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit
class Background: SKNode {
    
    private var world: WorldType!
    private var screenSize: CGSize!
    
    //MARK:- init
    init(world: WorldType, screenSize: CGSize) {
        super.init()
        
        self.world = world
        self.screenSize = screenSize
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        
        switch world as WorldType {
        case .field:
            
            //添加灌木
            let tex = atlas.textureNamed("bush")
            let originBush = SKSpriteNode(texture: tex)
            (0..<Int16(screenSize.width / tex.size().width + 1)).forEach(){
                index in
                
                let bush: SKSpriteNode = originBush.copy() as! SKSpriteNode
                bush.zPosition = 1
                bush.anchorPoint = CGPoint(x: 0, y: 0)
                bush.position = CGPoint(x: CGFloat(index) * bush.size.width, y: 0)
                addChild(bush)
            }
            
            //添加树
            let originTree = Tree()
            (0..<Int16(screenSize.width / 300)).forEach(){
                index in
                
                let tree = originTree.copy() as! SKSpriteNode
                let posX = CGFloat(arc4random_uniform(UInt32(screenSize.width)))
                tree.position = CGPoint(x: posX, y: 0)
                addChild(tree)
            }
            
        default:
            break
        }
    }
}
