//
//  Ground.swift
//  Kingdoms
//
//  Created by YiGan on 05/02/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import SpriteKit
class Ground: SKNode {
    
    private var backNode: SKNode?
    private var middleNode: SKNode?
    private var frontNode: SKNode?
    
    //移动速度
    private let moveDuration: TimeInterval = 1
    private let backSpeed: CGFloat = 20
    private let middleSpeed: CGFloat = 50
    private let frontSpeed: CGFloat = 50
    
    //enemy
    private lazy var enemy1: SKSpriteNode = {
        let enemy = SKSpriteNode(color: .red, size: CGSize(width: 80, height: 120))
        enemy.zPosition = ZPos.enemy
        return enemy
    }()
    private lazy var enemy2: SKSpriteNode = {
        let enemy = SKSpriteNode(color: .red, size: CGSize(width: 80, height: 120))
        enemy.zPosition = ZPos.enemy
        return enemy
    }()
    private lazy var enemy3: SKSpriteNode = {
        let enemy = SKSpriteNode(color: .red, size: CGSize(width: 80, height: 120))
        enemy.zPosition = ZPos.enemy
        return enemy
    }()
    private lazy var enemyList: [SKSpriteNode] = [self.enemy1, self.enemy2, self.enemy3]
    private var calculateFrame: CGRect {
        guard let node = middleNode else{
            return .zero
        }
        return node.calculateAccumulatedFrame()
    }
    
    //MARK:- init
    override init() {
        super.init()
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        position = CGPoint(x: 0, y: (scene_size.height - ground_size.height) / 2)
    }
    
    private func createContents(){
        
        if let groundScene = SKScene(fileNamed: "1"){
            
            backNode = groundScene.childNode(withName: "back")
            backNode?.removeFromParent()
            if backNode != nil{
                backNode?.children.forEach{$0.zPosition = ZPos.background}
                addChild(backNode!)
            }
            
            middleNode = groundScene.childNode(withName: "middle")
            middleNode?.removeFromParent()
            if middleNode != nil {
                middleNode?.children.forEach{$0.zPosition = ZPos.middleground}
                addChild(middleNode!)
            }
            
            frontNode = groundScene.childNode(withName: "front")
            frontNode?.removeFromParent()
            if frontNode != nil {
                frontNode?.children.forEach{$0.zPosition = ZPos.frontground}
                addChild(frontNode!)
            }
        }
        
        let posX = -ground_size.width / 2 + ground_size.width * 0.8 + (calculateFrame.width - ground_size.width) / CGFloat(enemyList.count) * 0
        let posY = -ground_size.height / 2 + 80
        let enemyPos = CGPoint(x: posX, y: posY)
        
        enemy1.position = enemyPos
        addChild(enemy1)
    }
    
    //MARK:- 移动到下一波
    func next(wave: Int, closure: (Bool)->()){
        guard wave < enemyList.count else {
            closure(true)
            return
        }
        
        closure(false)
        
        let posX = -(calculateFrame.width - scene_size.width) / CGFloat(enemyList.count) * CGFloat(wave)
        let moveAct = SKAction.moveTo(x: posX, duration: moveDuration)
        run(moveAct)
        
        let backPosx = (calculateFrame.width - scene_size.width) * 0.4 / CGFloat(enemyList.count) * CGFloat(wave)
        let backMove = SKAction.moveTo(x: backPosx, duration: moveDuration)
        backNode?.run(backMove)
        
        let frontPosx = -(calculateFrame.width - scene_size.width) * 0.2 / CGFloat(enemyList.count) * CGFloat(wave)
        let frontMove = SKAction.moveTo(x: frontPosx, duration: moveDuration)
        frontNode?.run(frontMove)
    }
    
    //MARK:- update
    func update(_ currentTime: TimeInterval) {
        
    }
}
