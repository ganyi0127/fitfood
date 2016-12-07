//
//  Levelicon.swift
//  Alone
//
//  Created by YiGan on 06/12/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit
class Levelicon: SKSpriteNode {
    
    private var label = { () -> SKLabelNode in
        let label = SKLabelNode()
        label.fontColor = .white
        label.fontSize = 60
        label.position = .zero
        label.zPosition = 0.1
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        return label
    }()
    
    fileprivate var isNew: Bool = false
    
    var closure: ((World, Int16, Bool)->())!
    
    //地图
    var world: World!
    //关卡数
    var level: Int16!{
        didSet{
            label.text = "\(level)" + (isNew ? "new" : "")
        }
    }
    
    init(world: World, level: Int16, isNew: Bool = false, clicked: @escaping (World, Int16, Bool)->()){
        super.init(texture: nil, color: .red, size: CGSize(width: 200, height: 200))
        
        self.world = world
        self.isNew = isNew      //1
        self.level = level      //2
        
        self.closure = clicked
        
        label.text = "\(level)" + (isNew ? "new" : "")
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

extension Levelicon{
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        closure?(world, level, isNew)
    }
}
