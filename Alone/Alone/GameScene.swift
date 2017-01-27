//
//  GameScene.swift
//  Alone
//
//  Created by YiGan on 09/12/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit
class GameScene: SKScene {
    
    fileprivate var catNode: CatNode!
    private var objects = [Object]()    //存储所有物件
    private var outputLevel: OutputLevel?
    
    fileprivate var mainCamera: MainCamera!
    fileprivate var background: Background!
    fileprivate var screenSize: CGSize!
    fileprivate var world: WorldType!
    
    //MARK:- init
    init(world: WorldType, outputLevel: OutputLevel) {
        super.init(size: win_size)
        
        self.world = world
        
        let width = outputLevel.width
        let height = outputLevel.height
        screenSize = CGSize(width: width, height: height)
        self.outputLevel = outputLevel

        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        anchorPoint = .zero
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -4)
        physicsBody = {
            let physics = SKPhysicsBody(edgeLoopFrom: CGRect(origin: .zero, size: screenSize))
            physics.categoryBitMask = Mask.edgeLoop
            return physics
        }()
    }
    
    private func createContents(){
        
        //创建角色
        catNode = CatNode()
        catNode.position = CGPoint(x: catNode.size.width, y: catNode.size.height)
        addChild(catNode)
        
        //设置相机点击回调
        mainCamera = MainCamera(isEdit: false){
            buttonType in
            switch buttonType {
            case .home:
                //返回家园
                if let homeScene = SKScene(fileNamed: "HomeScene"){
                    homeScene.scaleMode = .aspectFill
                    self.view?.presentScene(homeScene)
                }

            case .world:
                //返回world
                //切换页面
                if let worldScene = WorldScene(fileNamed: "WorldScene"){
                    worldScene.scaleMode = .aspectFill
                    self.view?.presentScene(worldScene)
                }                
            default:
                break
            }
        }
        camera = mainCamera
        
        mainCamera.setPosition(sceneSize: screenSize)
        addChild(mainCamera)
        
        //创建物件
        if let output = outputLevel{
            output.outputObjectList.forEach(){
                outputObject in
                
                let object = Object(type: ObjectType(rawValue: outputObject.type)!)
                object.position = CGPoint(x: outputObject.x, y: outputObject.y)
                addChild(object)
                objects.append(object)
            }
        }
        
        //创建天空
        let sky = SKSpriteNode(texture: atlas.textureNamed("sky"))
        sky.anchorPoint = .zero
        sky.position = .zero
        sky.xScale = screenSize.width / sky.size.width
        sky.yScale = screenSize.height / sky.size.height
        addChild(sky)
        
        //添加背景
        background = Background(world: world, screenSize: screenSize)
        addChild(background)
    }
    
    //MARK: 游戏结束
    fileprivate func gameover(_ successful: Bool){
        
        if successful {            
            //返回家园
            if let homeScene = SKScene(fileNamed: "HomeScene"){
                homeScene.scaleMode = .aspectFill
                self.view?.presentScene(homeScene)
            }
        }else{
            //载入游戏页面
            let gameScene = GameScene(world: world, outputLevel: outputLevel!)
            gameScene.scaleMode = .aspectFill
            (self.scene as! GameScene).view?.presentScene(gameScene)
        }
    }
}

//MARK:- 触摸事件
extension GameScene{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        touches.forEach(){
            touch in
            
            let location = touch.location(in: self)
            
            //计算力大小
            let rect = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
            physicsWorld.enumerateBodies(in: rect){
                body, flag in
                
                //筛选物理体，仅作用于cat对象
                if let _: CatNode = body.node as? CatNode{

                    body.velocity = .zero
                    
                    let screenPos = self.view!.convert(location, from: self)//self.convertPoint(toView: location)   //获取view点击位置

                    let minForce: CGFloat = 2000
                    let maxForce: CGFloat = 22000                //初始力度
                    
                    var yForce = -minForce + (maxForce - minForce) * screenPos.y / view_size.height
                    
                    var xForce: CGFloat!
                    if screenPos.x > view_size.width / 2{
                        xForce = -(minForce + fabs(screenPos.x - view_size.width / 2) / view_size.width / 2 * (maxForce - minForce))
                    }else{
                        xForce = minForce + fabs(view_size.width / 2 - screenPos.x) / view_size.width / 2 * (maxForce - minForce)
                    }
                    
                    xForce = xForce * 2
                    
                    if xForce > maxForce{
                        xForce = maxForce
                    }else if xForce < -maxForce{
                        xForce = -maxForce
                    }
                    
                    if yForce > maxForce - minForce * 2{
                        yForce = maxForce - minForce * 2 
                    }else if yForce < -minForce{
                        yForce = -minForce
                    }
                    
                    let forceVector = CGVector(dx: xForce, dy: yForce)
                    body.applyForce(forceVector)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if let cat = catNode{
            mainCamera.setPointPosition(sceneSize: screenSize, pointPosition: cat.position)
        }
    }
}

//MARK:- 物理碰撞
extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        var bodyA = contact.bodyA
        var bodyB = contact.bodyB
        
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask{
            bodyA = contact.bodyB
            bodyB = contact.bodyA
        }
        
        if bodyA.categoryBitMask == Mask.cat && bodyB.categoryBitMask == Mask.edgeLoop{
            
        }else if bodyA.categoryBitMask == Mask.cat && bodyB.categoryBitMask == Mask.bad{
            //游戏失败
            gameover(false)
        }else if bodyA.categoryBitMask == Mask.cat && bodyB.categoryBitMask == Mask.finish{
            //游戏完成
            gameover(true)
        }else if bodyA.categoryBitMask == Mask.cat && bodyB.categoryBitMask == Mask.star{
            
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}
