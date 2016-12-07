//
//  GameScene.swift
//  Alone
//
//  Created by YiGan on 28/11/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var catNode: CatNode?
    
    override func didMove(to view: SKView) {
        
        camera = nil
        
        config()
        createContents()
    }
    
    private func config(){
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -4)
        physicsBody = {
            let physics = SKPhysicsBody(edgeLoopFrom: CGRect(origin: .zero, size: win_size))
            physics.categoryBitMask = Mask.edgeLoop
            return physics
        }()
    }
    
    private func createContents(){
        
        //创建角色
        catNode = CatNode()
        addChild(catNode!)
        
        //创建测试障碍物
        let box = Platform()
        addChild(box)
        
        //创建编辑按钮
        let editButton = Button(type: .edit){
            _ in
            //获取原始关卡并切换
            if let inputLevel = LevelData.share().get(world: .field, level: 1){
                
                let editScene = EditScene(world: nil, level: nil, inputLevel: inputLevel)
                editScene.scaleMode = .aspectFill
                self.view?.presentScene(editScene)
            }
        }
        editButton.position = CGPoint(x: size.width - editButton.size.width, y: size.height - editButton.size.height)
        addChild(editButton)
    }
}

//MARK:- 触摸事件
extension GameScene{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        touches.forEach(){
            touch in
            
            let location = touch.location(in: self)
            
            //计算力大小
            let rect = CGRect(x: 0, y: 0, width: win_size.width, height: win_size.height)
            physicsWorld.enumerateBodies(in: rect){
                body, flag in
                
                //筛选物理体，仅作用于cat对象
                if let node: CatNode = body.node as? CatNode{
                    
                    //计算点位置
                    let originPoint = CGPoint(x: node.position.x, y: node.position.y + node.size.height)
                    
                    //触摸距离
                    let touchDistance = sqrt(pow(originPoint.x - location.x, 2) + pow(originPoint.y - location.y, 2))
                    
                    let radius = node.size.width / 2              //目标半径
                    let fitDistance = radius * 4.0                  //最适合距离
                    let nearDistance = radius * 0.4                 //最近适配距离
                    let longDistance = radius * 7                   //最远适配距离
                    let baseRadix: CGFloat = 35000
                    let factor = baseRadix / touchDistance          //初始力度
                    
                    var force: CGFloat      //计算力度
                    if touchDistance >= nearDistance && touchDistance <= fitDistance {
                        //近点计算
                        force = factor - factor * pow((touchDistance - fitDistance) / (nearDistance - fitDistance), 2)
                    }else if touchDistance > fitDistance && touchDistance <= longDistance{
                        //远点计算
                        force = factor - factor * pow((touchDistance - fitDistance) / (longDistance - fitDistance), 2)
                    }else{
                        force = 0
                    }
                    
                    //力向量
                    let forceVector = CGVector(dx: (originPoint.x - location.x) * force * 0.5, dy: (originPoint.y - location.y) * force * 0.5)
                    
                    print("force vector:\n\(forceVector)")
                    //为合适物理体添加力
                    body.applyForce(forceVector)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

//MARK:- 物理碰撞
extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        var bodyA = contact.bodyA
        var bodyB = contact.bodyB
        
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask{
            bodyA = contact.bodyB
            bodyB = contact.bodyA
        }
        
        if bodyA.categoryBitMask == Mask.cat && bodyB.categoryBitMask == Mask.edgeLoop{
            
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}
