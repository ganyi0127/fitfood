//
//  ToolNode.swift
//  Alone
//
//  Created by YiGan on 05/12/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit
class Tools: SKNode {
    
    var size: CGSize!
    
    init(size: CGSize){
        super.init()
        
        self.size = size
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
    }
    
    private func createContents(){
    
        textureNameMap.enumerated().forEach(){
            index, element in
            let node = Tool(type: element.key)
            node.position = CGPoint(x: 0, y: -node.size.height - node.size.height * CGFloat(index))
            addChild(node)
        }
    }
}
