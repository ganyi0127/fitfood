//
//  MainCamera.swift
//  Alone
//
//  Created by YiGan on 05/12/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit
class MainCamera: SKCameraNode {
    
    var clicked: ((ButtonType)->())?    //点击回调
    
    private var isEdit = false          //判断是否为编辑模式
    
    //打开或关闭折叠页面
    var stackSwitch = false {
        didSet{
            stack(stackSwitch)
        }
    }
    
    //折叠面板-设置
    private let stack = Stack()

    
    //MARK:- init
    init(isEdit: Bool = false, clicked: ((ButtonType)->())? = nil) {
        super.init()
        
        self.isEdit = isEdit
        
        self.clicked = clicked
        
        config()
        createContents()
    }
    
    private func config(){
        name = "camera"
    }
    
    private func createContents(){
        if isEdit {
            initEdit()
        }
    }
    
    //MARK:- 添加编辑内容
    private func initEdit(){
        
        //创建家园按钮
        let homeButton = Button(type: .home, clicked: clicked)
        homeButton.position = CGPoint(x: win_size.width / 2 - homeButton.size.width * 1.5, y: win_size.height / 2 - homeButton.size.height * 0.7)
        addChild(homeButton)
        
        //删除按钮
        let deleteButton = Button(type: .delete, clicked: clicked)
        deleteButton.position = CGPoint(x: win_size.width / 2 - deleteButton.size.width * 1.5, y: win_size.height / 2 - deleteButton.size.height * 2)
        addChild(deleteButton)
        
        //添加折叠按钮
        let stackButton = Button(type: .stack){ _ in
            self.stackSwitch = !self.stackSwitch
        }
        stackButton.position = CGPoint(x: -win_size.width / 2 + stackButton.size.width / 2, y: -win_size.height / 2 + stackButton.size.height / 2)
        stackButton.zPosition = stackButton.zPosition + 1
        addChild(stackButton)
        
        //-添加折叠窗
        addChild(stack)
        
        
        //创建保存按钮
        let saveButton = Button(type: .save, clicked: clicked)
        saveButton.position = CGPoint(x: -stack.size.width / 2 + saveButton.size.width / 2, y: stack.size.height / 2 - saveButton.size.height / 2)
        stack.addChild(saveButton)
        
    }
    
    //MARK:- 控制折叠面板
    private func stack(_ switched: Bool){
        var x: CGFloat!
        if switched{
            x = -win_size.width / 2 + stack.size.width / 2
        }else{
            x = -win_size.width / 2 - stack.size.width / 2
        }
        let movAct = SKAction.moveTo(x: x, duration: 0.5)
        movAct.timingMode = .easeInEaseOut
        stack.run(movAct, switched: switched)
    }
    
    //MARK:- 设置摄像机位置
    func setPosition(sceneSize: CGSize, deltaPosition: CGSize = .zero){
        
        position = CGPoint(x: position.x + deltaPosition.width, y: position.y + deltaPosition.height)
        
        if position.x + win_size.width / 2 * 0 > sceneSize.width {
            position.x = sceneSize.width - win_size.width / 2 * 0
        }else if position.x - win_size.width / 2 < 0{
            position.x = win_size.width / 2
        }
        
        if position.y + win_size.height / 2 > sceneSize.height {
            position.y = sceneSize.height - win_size.height / 2
        }else if position.y - win_size.height / 2 < 0{
            position.y = win_size.height / 2
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
