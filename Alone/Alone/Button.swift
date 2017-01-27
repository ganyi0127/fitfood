//
//  Button.swift
//  Alone
//
//  Created by YiGan on 05/12/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit
enum ButtonType: String{
    case edit = "edit"
    case home = "home"
    case menu = "menu"
    case world = "world"
    case pause = "pause"
    case shop = "shop"
    case save = "save"
    case stack = "stack"
    case delete = "delete"
    case destroyable = "destroyable"
}

class Button: SKSpriteNode {
    
    //按钮状态
    enum State {
        case on
        case off
    }
    
    fileprivate var closure: ((ButtonType)->())?            //点击回调
    fileprivate var textureMap = [State: SKTexture]()       //贴图
    fileprivate var type: ButtonType!                       //按钮类型
    
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
    
    init(type: ButtonType, clicked: ((ButtonType)->())?){

        //添加贴图
        textureMap[.on] = atlas.textureNamed("button_on")
        textureMap[.off] = atlas.textureNamed("button_off")
        
        super.init(texture: textureMap[.off], color: .clear, size: textureMap[.off]!.size())
        
        closure = clicked   //设置回调
        self.type = type    //设置类型
        
        label.text = type.rawValue
        
        if type == .shop {
            color = .red
        }
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        isUserInteractionEnabled = true
        
        zPosition = ZPos.menu
    }
    
    private func createContents(){
        
        //添加按钮标签
        addChild(label)
    }
}

extension Button{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        texture = textureMap[.on]
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        texture = textureMap[.off]
        closure?(type)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        texture = textureMap[.off]
        closure?(type)
    }
}
