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
//贴图集_icon
let objectIconNameMap: [ObjectType: String] = [.ground: "ground",
                                               .bird: "bird",
                                               .rock: "rock",
                                               .river: "river",
                                               .plat: "plat",
                                               .wall: "wall"]
//贴图集
let objectNameMap: [ObjectType: String] = [.ground: "ground",
                                           .bird: "bird",
                                           .rock: "rock",
                                           .river: "river",
                                           .plat: "plat",
                                           .wall: "wall"]

//Icon
class Toolicon: SKSpriteNode {
    
    var type: ObjectType!
    
    init(type: ObjectType){
        let texName: String = objectIconNameMap[type]!
        let tex = atlas.textureNamed(texName)
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
