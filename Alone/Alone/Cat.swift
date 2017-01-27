//
//  Player.swift
//  Alone
//
//  Created by YiGan on 29/11/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit
class CatNode: SKSpriteNode {
    
    var enemgy: Int16?          //精力
    var level: Int16?           //等级
    var birthday: Date?         //生日
    var ranking: Int16?         //排名
    
    private let dataHandler = DataHandler.share()
    
    //MARK:- init
    init(){
        let texture = atlas.textureNamed("player_default")
        super.init(texture: texture, color: .clear, size: texture.size())

        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        position = CGPoint(x: win_size.width / 2, y: win_size.height / 2)
        zPosition = ZPos.cat
        
        //读取数据
        dataHandler.selectCat(type: 0, using: {
            cat in
            enemgy = cat.energy
            level = cat.level
            birthday = cat.birthday as Date?
            ranking = cat.ranking
        }){
            error in
            //错误处理
            debugPrint(error)
        }
    }
    
    private func createContents(){

        //添加物理体
        physicsBody = {
            guard let tex = texture else{
                return nil
            }
            let physics: SKPhysicsBody = SKPhysicsBody(texture: tex, size: tex.size())
            physics.categoryBitMask = Mask.cat
            physics.contactTestBitMask = Mask.bird | Mask.star | Mask.bad | Mask.finish
            physics.affectedByGravity = true
            physics.allowsRotation = false
            physics.isDynamic = true
            physics.mass = 0.5
            return physics
        }()
    }
}
