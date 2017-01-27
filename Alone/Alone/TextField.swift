//
//  TextField.swift
//  Alone
//
//  Created by YiGan on 06/12/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit
//MARK:- inputLevel属性
enum InputLevelProperty: String{
    case repeatScore = "重复得分"
    case completeScore = "完成得分"
    case finishTime = "限制时间(s)"
    case touchTimes = "点击次数"
    case width = "地图(宽)"
    case height = "地图(高)"
}
class TextField: SKSpriteNode {
    
    fileprivate var closure: ((InputLevelProperty)->())?            //点击回调
    fileprivate var type: InputLevelProperty!                       //属性类型
    var value: CGFloat?{
        didSet{
            guard let lb = label else {
                label = SKLabelNode()
                label?.fontColor = .black
                label?.fontSize = 50
                label?.position = .zero
                label?.zPosition = 0.1
                label?.horizontalAlignmentMode = .center
                label?.verticalAlignmentMode = .center
                label?.text = type.rawValue + (value == nil ? "" : "\(value!)")
                return
            }
            lb.text = type.rawValue + (value == nil ? "" : "\(value!)")
        }
    }//属性值
    
    private var label: SKLabelNode?
    
    init(type: InputLevelProperty, value: CGFloat?, clicked: ((InputLevelProperty)->())?){
        super.init(texture: nil, color: .green, size: CGSize(width: 300, height: 150))
        
        closure = clicked   //设置回调
        self.type = type    //设置类型
        self.value = value
        
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
        
        //添加按钮标签
        label = SKLabelNode()
        label?.fontColor = .black
        label?.fontSize = 50
        label?.position = .zero
        label?.zPosition = 0.1
        label?.horizontalAlignmentMode = .center
        label?.verticalAlignmentMode = .center
        label?.text = type.rawValue + (value == nil ? "" : "\(value!)")
        addChild(label!)
    }
}

extension TextField{
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        closure?(type)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        closure?(type)
    }
}
