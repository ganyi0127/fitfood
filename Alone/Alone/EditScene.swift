//
//  EditScene.swift
//  Alone
//
//  Created by YiGan on 05/12/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit
class EditScene: SKScene {
    
    fileprivate let mainCamera = MainCamera()
    fileprivate var sceneSize: CGSize!
    
    private var pinch: UIPinchGestureRecognizer!
    private var doubleTap: UITapGestureRecognizer!
    private var mainCameraScale: CGFloat = 1        //当前摄像机缩放比率
    
    //天空
    private lazy var sky: SKSpriteNode = { () -> SKSpriteNode in
        let sky = SKSpriteNode(texture: atlas.textureNamed("sky"))
        sky.anchorPoint = .zero
        sky.position = .zero
        sky.xScale = self.sceneSize.width / sky.size.width
        sky.yScale = self.sceneSize.height / sky.size.height
        return sky
    }()
    
    //MARK:- init
    init(inputLevel: InputLevel) {
        super.init(size: win_size)
        
        sceneSize = CGSize(width: inputLevel.width, height: inputLevel.height)
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        //添加手势
        pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinch(gesture:)))
        view.addGestureRecognizer(pinch)
        
        doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTap(gesture:)))
        doubleTap.numberOfTouchesRequired = 1
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
    }
    
    override func willMove(from view: SKView) {
        //移除手势
        view.removeGestureRecognizer(pinch)
        view.removeGestureRecognizer(doubleTap)
        super.willMove(from: view)
    }
    
    private func config(){
        
        anchorPoint = CGPoint(x: 0, y: 0)
        
        //添加背景
        addChild(sky)
        
    }
    
    private func createContents(){
        
        camera = mainCamera
        mainCamera.setPosition(sceneSize: sceneSize)
        addChild(mainCamera)
        
        //创建家园按钮
        let homeButton = Button(type: .home){
           
            if let homeScene = SKScene(fileNamed: "HomeScene"){
                homeScene.scaleMode = .aspectFill
                self.view?.presentScene(homeScene)
            }
        }
        homeButton.position = CGPoint(x: win_size.width / 2 - homeButton.size.width * 2, y: win_size.height / 2 - homeButton.size.height * 0.7)
        mainCamera.addChild(homeButton)

        //添加工具栏
        let editTool = EditTool()
        editTool.position = CGPoint(x: win_size.width / 2 - editTool.size.width / 2, y: 0)
        mainCamera.addChild(editTool)
        
//        let h1 = Button(type: .shop, clicked: {})
//        h1.position = CGPoint.zero
//        mainCamera.addChild(h1)
//        
//        //测试
//        let b1 = Button(type: .shop, clicked: {})
//        b1.position = CGPoint.zero
//        addChild(b1)
//        
//        let b2 = Button(type: .shop, clicked: {})
//        b2.position = CGPoint(x: win_size.width, y: win_size.height)
//        addChild(b2)
//        
//        let b3 = Button(type: .shop, clicked: {})
//        b3.position = CGPoint(x: sceneSize.width, y: sceneSize.height)
//        addChild(b3)
    }
    
    //MARK:- 捏合手势
    @objc private func pinch(gesture: UIPinchGestureRecognizer){
        
        var scale = 1 / gesture.scale
        if scale > 1{
            if scale > 3{
                scale = 3
            }
            mainCameraScale *= (scale - 1) * 0.1 + 1
            if mainCameraScale > 4{
                mainCameraScale = 4
            }
            mainCamera.setScale(mainCameraScale)
        }else{

            if gesture.scale > 3{
                scale = 1 / 3
            }
            
            mainCameraScale *= 1 / ((1 / scale - 1) * 0.1 + 1)
            if mainCameraScale < 1{
                mainCameraScale = 1
            }
            mainCamera.setScale(mainCameraScale)
        }
    }
    
    //MARK:- 双击手势
    @objc private func doubleTap(gesture: UITapGestureRecognizer){
        mainCamera.setScale(1)
    }
}

//MARK:- 触摸事件
extension EditScene{
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach(){
            touch in
            let curLoc = touch.location(in: self)
            let preLoc = touch.previousLocation(in: self)
            
            let delta = CGSize(width: preLoc.x - curLoc.x, height: preLoc.y - curLoc.y)
            mainCamera.setPosition(sceneSize: sceneSize, deltaPosition: delta)
        }
    }
}
