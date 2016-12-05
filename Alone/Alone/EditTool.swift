//
//  EditTool.swift
//  Alone
//
//  Created by YiGan on 05/12/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit
class EditTool: SKSpriteNode {
    
    //工具集合
    fileprivate lazy var tools: Tools = { ()->Tools in
        let tools = Tools(size: self.size)
        tools.position = CGPoint(x: 0, y: self.size.height / 2)
        return tools
    }()
    
    
    //MARK:- init
    init(){
        super.init(texture: nil, color: .lightGray, size: CGSize(width: win_size.width * 0.1, height: win_size.height * 0.95))
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        zPosition = ZPos.menu
        isUserInteractionEnabled = true
    }
    
    private func createContents(){
        
        let tools = Tools(size: size)
        
        addChild(tools)
    }
}

//MARK:- 触摸事件
extension EditTool{
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach(){
            touch in
            let curLoc = touch.location(in: self)
            let preLoc = touch.previousLocation(in: self)
            
            let delta = preLoc.y - curLoc.y
            
            tools.position.y += delta
            
            if tools.position.y - tools.size.height > 0{
                tools.position.y = tools.size.height
            }
        }
    }
}
