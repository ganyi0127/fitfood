//
//  GameScene.swift
//  Kingdoms
//
//  Created by YiGan on 25/01/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private lazy var fightBase: FightBase = {
        return FightBase(rowCount: 7, lineCount: 7)
    }()
    
    //MARK:- 无用方法
    override func sceneDidLoad() {
    }
    
    //MARK:- init
    override func didMove(to view: SKView) {
        config()
        createContents()
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        addChild(fightBase)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}

//MARK;- touch
extension GameScene{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
