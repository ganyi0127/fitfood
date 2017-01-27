//
//  Worlds.swift
//  Alone
//
//  Created by YiGan on 09/12/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit
class Worlds: SKNode {
    
    let interval = win_size.width * 0.75
    var worldMap = [WorldType: World]()
    
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
        
    } 
    
    private func createContents(){
        
        //创建沙盒
        let fieldWorld = World(worldType: .field)
        fieldWorld.position = CGPoint(x: 0, y: 0)
        addChild(fieldWorld)
        worldMap[.field] = fieldWorld
        
        let castleWorld = World(worldType: .castle)
        castleWorld.position = CGPoint(x: interval, y: 0)
        addChild(castleWorld)
        worldMap[.castle] = castleWorld
        
    }
}
