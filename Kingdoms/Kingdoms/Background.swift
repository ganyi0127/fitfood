//
//  Background.swift
//  Kingdoms
//
//  Created by YiGan on 2017/2/3.
//  Copyright © 2017年 YiGan. All rights reserved.
//

import SpriteKit
class Background: SKNode {
    override init(){
        super.init()
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        position = .zero
    }
    
    private func createContents(){
        
    }
}
