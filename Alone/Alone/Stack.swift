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
    private var worldMap: [WorldType: [Int16: InputLevel]]!{
        get{
            return LevelData.share().getAllLevel()
        }
    }
    
    fileprivate var editProperty: InputLevelProperty?                   //存储当前编辑属性(一个临时对象)
    var textFieldMap = [InputLevelProperty: TextField]()                //存储属性标签
    fileprivate var globaTextField: UITextField?                        //输入框
    
    //MARK:- init
    init(){
        super.init(texture: nil, color: .lightGray, size: CGSize(width: win_size.width / 2, height: win_size.height))
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        globaTextField?.removeFromSuperview()
        globaTextField = nil
        removeAllChildren()
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
        
        //显示设置
        showSetting()
        
        //初始化选择地图field
        addLevels(world: .field)
    }
    
    //MARK:- 展开或关闭折叠页
    func run(_ action: SKAction, switched: Bool) {
        
        //清除文本输入
        if !switched{
            globaTextField?.removeFromSuperview()
            globaTextField = nil
        }
        
        //动画
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
        fieldWorld.position = CGPoint(x: -fieldWorld.size.width / 2, y: size.height * 0.25)
        addChild(fieldWorld)
        
        let castleWorld = Worldicon(world: .castle, clicked: selectedWorld)
        castleWorld.position = CGPoint(x: -castleWorld.size.width / 2, y: size.height * 0.05)
        addChild(castleWorld)
    }
    
    //MARK:- 显示配置
    private func showSetting(){
        
        let input = InputLevel()
        
        //完成分
        let completeScore = TextField(type: .completeScore, value: CGFloat(input.completeScore), clicked: selectedSetting)
        completeScore.position = CGPoint(x: size.width / 2 - completeScore.size.width * 0.7, y: size.height * 0.2 * 2)
        addChild(completeScore)
        textFieldMap[.completeScore] = completeScore
        
        //重复分
        let repeatScore = TextField(type: .repeatScore, value: CGFloat(input.repeatScore), clicked: selectedSetting)
        repeatScore.position = CGPoint(x: size.width / 2 - repeatScore.size.width * 0.7, y: size.height * 0.2 * 1.2)
        addChild(repeatScore)
        textFieldMap[.repeatScore] = repeatScore
        
        //完成时长
        let finishTime = TextField(type: .finishTime, value: input.finishTime, clicked: selectedSetting)
        finishTime.position = CGPoint(x: size.width / 2 - finishTime.size.width * 0.7, y: size.height * 0.2 * 0.4)
        addChild(finishTime)
        textFieldMap[.finishTime] = finishTime
        
        //点击数
        let touchTimes = TextField(type: .touchTimes, value: CGFloat(input.touchTimes), clicked: selectedSetting)
        touchTimes.position = CGPoint(x: size.width / 2 - touchTimes.size.width * 0.7, y: size.height * 0.2 * -0.4)
        addChild(touchTimes)
        textFieldMap[.touchTimes] = touchTimes
        
        //地图宽
        let width = TextField(type: .width, value: CGFloat(input.width), clicked: selectedSetting)
        width.position = CGPoint(x: size.width / 2 - width.size.width * 0.7, y: size.height * 0.2 * -1.2)
        addChild(width)
        textFieldMap[.width] = width
        
        //地图高
        let height = TextField(type: .height, value: CGFloat(input.height), clicked: selectedSetting)
        height.position = CGPoint(x: size.width / 2 - height.size.width * 0.7, y: size.height * 0.2 * -2)
        addChild(height)
        textFieldMap[.height] = height
    }
    
    //MARK:- 刷新关卡展示
    private func addLevels(world: WorldType){
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
    private func selectedWorld(world: WorldType){
        addLevels(world: world)
    }
    
    //MARK:- 选择setting回调
    private func selectedSetting(property: InputLevelProperty){
        
        //临时存储
        editProperty = property
        
        switch property {
        case .completeScore:
            break
        case .finishTime:
            break
        case .repeatScore:
            break
        case .touchTimes:
            break
        case .width:
            break
        case .height:
            break
        }
        
        if globaTextField == nil {
            globaTextField = UITextField()
            globaTextField?.frame = CGRect(x: view_size.width / 2 - 75, y: 0, width: 150, height: 40)
            globaTextField?.backgroundColor = .white
            globaTextField?.borderStyle = .roundedRect
            globaTextField?.autocapitalizationType = .none
            globaTextField?.autocorrectionType = .no
            globaTextField?.spellCheckingType = .no
            globaTextField?.keyboardType = .numbersAndPunctuation
            globaTextField?.returnKeyType = .done
            globaTextField?.delegate = self
            (scene as! EditScene).view?.addSubview(globaTextField!)
        }
        
        guard let textField = textFieldMap[property] else {
            globaTextField?.placeholder = property.rawValue
            return
        }
        globaTextField?.placeholder = property.rawValue + "\(textField.value ?? 0)"
        globaTextField?.becomeFirstResponder()
    }
    
    //MARK:- 选择levelicon回调
    private func clicked(world: WorldType, level: Int16, isNew: Bool){
        
        //初始化
        let editScene = scene as! EditScene
        editScene.world = world
        editScene.level = level
        if isNew {
            let inputLevel = InputLevel()
            textFieldMap[.completeScore]?.value = CGFloat(inputLevel.completeScore)
            textFieldMap[.repeatScore]?.value = CGFloat(inputLevel.repeatScore)
            textFieldMap[.finishTime]?.value = inputLevel.finishTime
            textFieldMap[.touchTimes]?.value = CGFloat(inputLevel.touchTimes)
            textFieldMap[.width]?.value = inputLevel.width
            textFieldMap[.height]?.value = inputLevel.height
            editScene.inputLevel = inputLevel
        }else{
            
            if let inputLevel = worldMap[world]?[level]{
                textFieldMap[.completeScore]?.value = CGFloat(inputLevel.completeScore)
                textFieldMap[.repeatScore]?.value = CGFloat(inputLevel.repeatScore)
                textFieldMap[.finishTime]?.value = inputLevel.finishTime
                textFieldMap[.touchTimes]?.value = CGFloat(inputLevel.touchTimes)
                textFieldMap[.width]?.value = inputLevel.width
                textFieldMap[.height]?.value = inputLevel.height
                
                editScene.inputLevel = inputLevel
            }
        }
        
        //切换回编辑页
        (parent as! MainCamera).stackSwitch = false
    }
}

//MARK:- 设置属性值 textfield
extension Stack: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, let property = editProperty{
            textFieldMap[property]?.value = CGFloat(Int16(text) ?? 0)
        }
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.removeFromSuperview()
        self.globaTextField = nil
    }
}
