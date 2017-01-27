//
//  World.swift
//  Alone
//
//  Created by YiGan on 09/12/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit
class World: SKSpriteNode {
    
    private var worldType: WorldType!
    private var levels: [Int16: OutputLevel]!{
        didSet{
            (0..<Int16(levels.count)).forEach(){
                index in
                let level = index + 1
                
                if let outputLevel = levels[level]{
                    let levelicon = Levelicon(world: self.worldType, level: level){
                        world, level, _ in

                        //载入游戏页面
                        let gameScene = GameScene(world: world, outputLevel: outputLevel)
                        gameScene.scaleMode = .aspectFill
                        (self.scene as! WorldScene).view?.presentScene(gameScene)
                    }
                    let widthInterval = self.size.width * 0.25
                    let heightInterval = self.size.height * 0.25
                    levelicon.position = CGPoint(x: -self.size.width / 2 + CGFloat(index % 3 + 1) * widthInterval, y: CGFloat(index / 3 + 1) * heightInterval)
                    levelicon.zPosition = 0.1
                    addChild(levelicon)
                }
            }
        }
    }
    
    init(worldType: WorldType){
        let tex = atlas.textureNamed("world_bg")
        super.init(texture: tex, color: .clear, size: tex.size())
        
        self.worldType = worldType
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        zPosition = ZPos.menu
    }
    
    private func createContents(){
        levels = LevelData.share().selectAllLevels()[worldType]
    }
}
