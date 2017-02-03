//
//  FightCube.swift
//  Kingdoms
//
//  Created by YiGan on 26/01/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import SpriteKit
enum FightCubeType: Int {
    case none = 0
    case attack
    case defense
    case magic
    case tenacity
    case special
}
class FightCube: SKSpriteNode {
    
    //标记删除
    var markDelete = false
    
    //类型
    var type: FightCubeType?{
        didSet{
            if type == .special{
                color = .black
            }
        }
    }
    
    var isPower = false{
        didSet{
            alpha = 0.5
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
        }
    }
    
    //MARK:- init
    init(_ type: FightCubeType) {
        self.type = type
        var color: SKColor
        switch self.type! {
        case .attack:
            color = .red
        case .special:
            color = .black
        case .defense:
            color = .yellow
        case .magic:
            color = .purple
        case .tenacity:
            color = .green
        default:
            color = .clear
        }
        
        super.init(texture: nil, color: color, size: cube_size!)
        
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
