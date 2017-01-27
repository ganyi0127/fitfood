//
//  EditScene.swift
//  Alone
//
//  Created by YiGan on 05/12/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit
class EditScene: SKScene {
    
    //精度
    private let position_accuracy: Int16 = 80
    
    fileprivate var mainCamera: MainCamera!
    fileprivate var sceneSize: CGSize!{
        didSet{
            sky.xScale = self.sceneSize.width / sky.size.width * sky.xScale
            sky.yScale = self.sceneSize.height / sky.size.height * sky.yScale
        }
    }
    
    private var pinch: UIPinchGestureRecognizer!
    private var doubleTap: UITapGestureRecognizer!
    private var mainCameraScale: CGFloat = 1        //当前摄像机缩放比率
    
    //天空
    fileprivate lazy var sky: SKSpriteNode = { () -> SKSpriteNode in
        let sky = SKSpriteNode(texture: atlas.textureNamed("sky"))
        sky.anchorPoint = .zero
        sky.position = .zero
        sky.xScale = self.sceneSize.width / sky.size.width
        sky.yScale = self.sceneSize.height / sky.size.height
        return sky
    }()
    
    fileprivate var editObject: Object?{
        didSet{
            guard let editObj = editObject else {
                mainCamera.destroyableButton.isHidden = true
                return
            }
            mainCamera.destroyableButton.isHidden = false
            self.mainCamera.destroyableButton.xScale = editObj.destroyable ? 0.5 : 1
        }
    }//存储当前修改物件(一个临时对象)
    
    fileprivate var objects = [Object]()                //存储所有添加物件
    
    //MARK:- 导入关卡(setOnly)
    var inputLevel: InputLevel!{
        didSet{
            //移除修改
            removeChildren(in: objects)
            objects.removeAll()
            
            //刷新地图
            sceneSize = CGSize(width: inputLevel.width, height: inputLevel.height)
            inputLevel.inputObjectList.forEach(){
                inputObject in
                
                let object = Object(type: ObjectType(rawValue: inputObject.type)!, edit: true)
                object.position = CGPoint(x: inputObject.x, y: inputObject.y)
                object.destroyable = inputObject.destroyable
                addChild(object)
                objects.append(object)
            }
        }
    }
    
    //MARK:- 地图信息
    var world: WorldType?           //地图
    var level: Int16?               //关卡
    
    //MARK:- init
    init(world: WorldType?, level: Int16?, inputLevel: InputLevel) {
        super.init(size: win_size)
        
        sceneSize = CGSize(width: inputLevel.width, height: inputLevel.height)
        self.world = world
        self.level = level
        
        
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
        
        //设置相机点击回调
        mainCamera = MainCamera(isEdit: true){
            buttonType in
            switch buttonType {
            case .home:
                //返回家园
                if let homeScene = SKScene(fileNamed: "HomeScene"){
                    homeScene.scaleMode = .aspectFill
                    self.view?.presentScene(homeScene)
                }
            case .delete:
                //删除选择物件
                if let editObj = self.editObject{
                    editObj.removeFromParent()
                    if let index = self.objects.index(of: editObj){
                        self.objects.remove(at: index)
                    }
                    self.editObject = nil
                }
            case .destroyable:
                //设置为一次性物品
                if let editObj = self.editObject{
                    editObj.destroyable = !editObj.destroyable
                    self.mainCamera.destroyableButton.xScale = editObj.destroyable ? 0.5 : 1
                }
            case .save:
                //保存关卡
                let textFieldMap = self.mainCamera.stack.textFieldMap
                let defaultInput = InputLevel()

                var inputLevel = InputLevel()
                inputLevel.completeScore = Int16(textFieldMap[.completeScore]?.value ?? CGFloat(defaultInput.completeScore))
                inputLevel.repeatScore = Int16(textFieldMap[.repeatScore]?.value ?? CGFloat(defaultInput.repeatScore))
                inputLevel.finishTime = textFieldMap[.finishTime]?.value ?? defaultInput.finishTime
                inputLevel.touchTimes = Int16(textFieldMap[.touchTimes]?.value ?? CGFloat(defaultInput.touchTimes))
                let floatWidth = textFieldMap[.width]?.value ?? defaultInput.width
                var width = Int16(floatWidth)
                let widthRemainder = width % self.position_accuracy - (width % self.position_accuracy >= self.position_accuracy / 2 ? self.position_accuracy : 0)
                width = width - widthRemainder
                inputLevel.width = CGFloat(width)
                let floatHeight = textFieldMap[.height]?.value ?? defaultInput.height
                var height = Int16(floatHeight)
                let heightRemainder = height % self.position_accuracy - (height % self.position_accuracy >= self.position_accuracy / 2 ? self.position_accuracy : 0)
                height = height - heightRemainder
                inputLevel.height = CGFloat(height)
                var inputObjectList = [InputObject]()
                self.objects.forEach(){
                    object in
                    var inputObject = InputObject()
                    inputObject.destroyable = object.destroyable
                    inputObject.type = object.type.rawValue
                    var posX = Int16(object.position.x)
                    let posXRemainder = posX % self.position_accuracy - (posX % self.position_accuracy >= self.position_accuracy / 2 ? self.position_accuracy : 0)
                    posX = posX - posXRemainder
                    inputObject.x = CGFloat(posX)
                    var posY = Int16(object.position.y)
                    let posYRemainder = posY % self.position_accuracy - (posY % self.position_accuracy >= self.position_accuracy / 2 ? self.position_accuracy : 0)
                    posY = posY - posYRemainder
                    inputObject.y = CGFloat(posY)
                    inputObjectList.append(inputObject)
                }
                inputLevel.inputObjectList = inputObjectList
                
                //写入关卡
                guard let wld = self.world, let lev = self.level else{
                    let message = "需传入地图与关卡"
                    debugPrint(message)
                    break
                }
                LevelData.share().update(world: wld, level: lev, inputObject: inputLevel){
                    complete in
                    if complete{
                        //写入完成
                        //self.mainCamera.stackSwitch = false
                    }else{
                        debugPrint("写入失败")
                    }
                }
            default:
                break
            }
        }
        camera = mainCamera
        mainCamera.setPosition(sceneSize: sceneSize)
        addChild(mainCamera)
        
        
        //添加工具栏
        let editTool = EditTool()
        editTool.position = CGPoint(x: win_size.width / 2 - editTool.size.width / 2, y: 0)
        mainCamera.addChild(editTool)
    }
    
    //MARK:- 添加物件
    func add(object objectType: ObjectType){

        let object = Object(type: objectType, edit: true)
        object.position = CGPoint(x: sceneSize.width / 2, y: sceneSize.height / 2)
        addChild(object)
        
        objects.append(object)
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach(){
            touch in
            let location = touch.location(in: self)
            let nodeList = nodes(at: location)
            
            if !nodeList.isEmpty{
                let node = nodeList[0]
                if node is Object{
                    editObject = node as? Object
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach(){
            touch in
            let curLoc = touch.location(in: self)
            let preLoc = touch.previousLocation(in: self)
            
            let delta = CGSize(width: preLoc.x - curLoc.x, height: preLoc.y - curLoc.y)
            if let object = editObject{
                var objX = object.position.x - delta.width
                if objX < 0{
                    objX = 0
                }else if objX > sceneSize.width{
                    objX = sceneSize.width
                }
                
                var objY = object.position.y - delta.height
                if objY < 0{
                    objY = 0
                }else if objY > sky.size.height{
                    objY = sky.size.height
                }
                object.position = CGPoint(x: objX, y: objY)
            }else{
                mainCamera.setPosition(sceneSize: sceneSize, deltaPosition: delta)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach(){
            touch in
            let location = touch.location(in: self)
            let nodeList = nodes(at: location)
            
            if nodeList.isEmpty{
                editObject = nil
            }else{
                let node = nodeList[0]
                if !(node is Object){
                    editObject = nil
                }
            }
        }
    }
}
