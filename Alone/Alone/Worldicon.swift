//
//  Worldicon.swift
//  Alone
//
//  Created by YiGan on 06/12/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit
class Worldicon: SKSpriteNode {
    private var label = { () -> SKLabelNode in
        let label = SKLabelNode()
        label.fontColor = .white
        label.fontSize = 100
        label.position = .zero
        label.zPosition = 0.1
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        return label
    }()
    
    var closure: ((World)->())!
    
    //地图
    var world: World!{
        didSet{
            label.text = world.rawValue
        }
    }
    
    init(world: World, clicked: @escaping (World)->()){
        super.init(texture: nil, color: .black, size: CGSize(width: 400, height: 200))
        
        self.world = world
        
        self.closure = clicked
        
        label.text = world.rawValue
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        isUserInteractionEnabled = true
    }
    
    private func createContents(){
        
        addChild(label)
    }
}

extension Worldicon{
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        closure(world)
    }
}
