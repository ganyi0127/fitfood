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
    
    //判断是否为点击
    fileprivate var isClicked = true
    
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
            
            //滑动
            let delta = curLoc.y - preLoc.y
            tools.position.y += delta
            
        }
        
        isClicked = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //回弹
        let toolsHeight = tools.calculateAccumulatedFrame().size.height
        if toolsHeight < size.height {
            if tools.position.y - size.height / 2 - toolsHeight > -size.height || tools.position.y < size.height / 2{
                tools.position.y = size.height / 2
            }
        }else{
            if tools.position.y - size.height / 2 - toolsHeight > -size.height{
                tools.position.y = size.height / 2 + toolsHeight - size.height
            }else if tools.position.y < size.height / 2{
                tools.position.y = size.height / 2
            }
        }
        
        touches.forEach(){
            touch in
            let location = touch.location(in: self)
            let nodeList = nodes(at: location)
            
            //添加物件
            if !nodeList.isEmpty{
                let node = nodeList[0]
                if node is Toolicon{
                    if isClicked {
                        (scene as! EditScene).add(object: (node as! Toolicon).type)
                    }else{
                        isClicked = true
                    }
                }
            }

        }
    }
}
