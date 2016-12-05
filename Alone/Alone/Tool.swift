//
//  Tool.swift
//  Alone
//
//  Created by YiGan on 05/12/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit
//物件类型
enum ObjectType: Int16{
    case ground = 0
    case wall
    case river
    case bird
    case plat
    case rock
}
//贴图集
let textureNameMap: [ObjectType: String] = [.ground: "ground",
                                           .bird: "bird",
                                           .rock: "rock",
                                           .river: "river",
                                           .plat: "plat",
                                           .wall: "wall"]


class Tool: SKSpriteNode {
    
    var type: ObjectType!
    
    init(type: ObjectType){
        let texName: String = textureNameMap[type]!
        let tex = atlas.textureNamed(texName)
        print(tex, texName)
        super.init(texture: tex, color: .clear, size: tex.size())

        self.type = type
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        
    }
}
