//
//  Tree.swift
//  Alone
//
//  Created by YiGan on 15/12/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit
class Tree: SKSpriteNode {
    init(){
        let tex = atlas.textureNamed("tree1")
        super.init(texture: tex, color: .clear, size: tex.size())
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        anchorPoint = CGPoint(x: 0.5, y: 0)
        zPosition = 2
    }
    
    private func createContents(){
        
    }
}
