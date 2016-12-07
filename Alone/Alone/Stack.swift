//
//  Stack.swift
//  Alone
//
//  Created by YiGan on 06/12/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit
class Stack: SKSpriteNode {
    
    private let levelStack = SKSpriteNode(color: .gray, size: CGSize(width: win_size.width / 2, height: win_size.height))   //关卡折叠页面
    
    //存储所有关卡信息
    private var worldMap: [World: [Int16: InputLevel]]!{
        get{
            return LevelData.share().getAllLevel()
        }
    }
    
    //MARK:- init
    init(){
        super.init(texture: nil, color: .lightGray, size: CGSize(width: win_size.width / 2, height: win_size.height))
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        position = CGPoint(x: -win_size.width / 2 - size.width / 2, y: 0)
        zPosition = ZPos.menu
    }
    
    private func createContents(){
       
        //初始化关卡折叠页面
        levelStack.position = .zero
        levelStack.zPosition = 1
        addChild(levelStack)
        
        //显示地图
        showWorld()
        
        //初始化选择地图field
        addLevels(world: .field)
    }
    
    //MARK:- 展开或关闭折叠页
    func run(_ action: SKAction, switched: Bool) {
        run(action){
            var x: CGFloat!
            if switched{
                x = self.size.width / 2 + self.levelStack.size.width / 2
            }else{
                x = 0
            }
            let movAct = SKAction.moveTo(x: x, duration: 0.3)
            self.levelStack.run(movAct)
        }
    }
    
    //MARK:- 显示地图
    private func showWorld(){
        
        let fieldWorld = Worldicon(world: .field, clicked: selectedWorld)
        fieldWorld.position = CGPoint(x: 0, y: size.height * 0.25)
        addChild(fieldWorld)
        
        let castleWorld = Worldicon(world: .castle, clicked: selectedWorld)
        castleWorld.position = CGPoint(x: 0, y: size.height * 0.05)
        addChild(castleWorld)
    }
    
    //MARK:- 刷新关卡展示
    private func addLevels(world: World){
        levelStack.removeAllChildren()
        
        guard let levels = worldMap[world] else {
            return
        }
        
        //排列
        (1...levels.count+1).forEach(){
            index in
            var isNew = false
            if index == levels.count + 1{
                isNew = true
            }
            
            let levelicon = Levelicon(world: world, level: Int16(index), isNew: isNew, clicked: clicked)
            levelicon.position = CGPoint(x: -levelStack.size.width * 0.3 + CGFloat(index % 3) * levelicon.size.width * 1.2,
                                         y: levelStack.size.height * 0.3 - CGFloat(index / 3) * levelicon.size.height * 1.2)
            levelStack.addChild(levelicon)
        }
    }
    
    //MARK:- 选择world回调
    private func selectedWorld(world: World){
        addLevels(world: world)
    }
    
    //MARK:- 选择levelicon回调
    private func clicked(world: World, level: Int16, isNew: Bool){
        
        //初始化
        let editScene = scene as! EditScene
        editScene.world = world
        editScene.level = level
        if isNew {
            var inputLevel = InputLevel()
            inputLevel.completeScore = 100
            inputLevel.finishTime = 60
            inputLevel.repeatScore = 20
            inputLevel.height = win_size.height
            inputLevel.width = win_size.width
            inputLevel.touchTimes = 50
            
            editScene.inputLevel = inputLevel
        }else{
            
            editScene.inputLevel = worldMap[world]?[level]
        }
        
        //切换回编辑页
        (parent as! MainCamera).stackSwitch = false
    }
}
