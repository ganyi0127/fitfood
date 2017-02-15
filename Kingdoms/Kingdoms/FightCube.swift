//
//  FightCube.swift
//  Kingdoms
//
//  Created by YiGan on 26/01/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import SpriteKit
enum FightCubeType: Int {
    case none = 0       //无
    case attack         //攻击
    case defense        //防御
    case magic          //魔法
    case tenacity       //坚韧
    case special        //特殊
}
class FightCube: SKSpriteNode {
    
    //标记删除
    var markDelete = false
    
    //类型
    var type: FightCubeType?{
        didSet{
            if type == .special{
                let specialTex = SKTexture(imageNamed: "resource/cube/special_front")
                texture = specialTex
            }
        }
    }
    
    var isPower = false{
        didSet{
            let backTex = SKTexture(imageNamed: "resource/cube/" + texName + "_back")
            let back = SKSpriteNode(texture: backTex, size: backTex.size())
            back.zPosition = -0.1
            addChild(back)
        }
    }
    
    //坐标
    var coordinate: (row: Int, line: Int)!{
        didSet{
            let row = coordinate.row, line = coordinate.line
            
            let posX = CGFloat(line) * cube_size!.width + cube_size!.width / 2 - matrix_size.width / 2
            let posY = matrix_size.width / 2 - CGFloat(row) * cube_size!.height - cube_size!.height / 2
            
            let targetPosition = CGPoint(x: posX, y: posY)
            
            let moveAct = SKAction.move(to: targetPosition, duration: move_time)
            moveAct.timingMode = .easeOut
            run(moveAct)
            
            //test
            label.text = "\(row)_\(line)"
        }
    }
    
    //test
    private lazy var label: SKLabelNode = {
        let label: SKLabelNode = SKLabelNode(fontNamed: font_name)
        label.fontColor = .black
        label.zPosition = 0.1
        label.fontSize = 40
        label.horizontalAlignmentMode = .center
        return label
    }()
    
    //test
    private var markDot: SKSpriteNode?
    
    //标记单次遍历
    var isMarked = false{
        didSet{
            if isMarked {
                if markDot == nil{
                    markDot = SKSpriteNode(color: .white, size: CGSize(width: 5, height: 5))
                    markDot?.zPosition = 0.2
                    addChild(markDot!)
                }
            }else{
                if markDot != nil{
                    markDot!.removeFromParent()
                    markDot = nil
                }
            }
        }
    }
    
    private var texName = ""
    
    //MARK:- init
    init(_ type: FightCubeType) {
        self.type = type
        switch self.type! {
        case .attack:
            texName = "attack"
        case .special:
            texName = "special"
        case .defense:
            texName = "defense"
        case .magic:
            texName = "magic"
        case .tenacity:
            texName = "tenacity"
        default:
            texName = ""
        }
        let tex = SKTexture(imageNamed: "resource/cube/" + texName + "_front")
        super.init(texture: tex, color: .clear, size: tex.size())
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        zPosition = ZPos.cube
    }
    
    private func createContents(){
        addChild(label)
    }
}
