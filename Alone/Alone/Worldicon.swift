//
//  Worldicon.swift
//  Alone
//
//  Created by YiGan on 06/12/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit
class Worldicon: SKSpriteNode {
    
    //按钮状态
    enum State {
        case on
        case off
    }
    
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
    
    fileprivate var textureMap = [State: SKTexture]()       //贴图
    
    var closure: ((WorldType)->())!
    
    //地图
    var world: WorldType!{
        didSet{
            label.text = world.rawValue
        }
    }
    
    init(world: WorldType, clicked: @escaping (WorldType)->()){
        //添加贴图
        textureMap[.on] = atlas.textureNamed("button_on")
        textureMap[.off] = atlas.textureNamed("button_off")
        
        super.init(texture: textureMap[.off], color: .clear, size: textureMap[.off]!.size())
        
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        texture = textureMap[.on]
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        texture = textureMap[.off]
        closure(world)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        texture = textureMap[.off]
    }
}
