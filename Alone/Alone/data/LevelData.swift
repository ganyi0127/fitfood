//
//  Data.swift
//  Alone
//
//  Created by YiGan on 02/12/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import UIKit
//MARK:- 世界类型
enum WorldType: String{
    case field = "field"
    case castle = "castle"
}

//MARK:- 完成等级
enum CompletionStatus: Int16{
    case undone = 0
    case normal
    case good
    case perfect
}
//MARK:- 导出物件
struct OutputObject {
    var type: Int16 = 0
    var x: CGFloat = 0
    var y: CGFloat = 0
}
//MARK:- 导出场景
struct OutputLevel {
    var score: Int16 = 0
    var completionStatus = CompletionStatus.undone
    var finishTime: CGFloat = 0
    var touchTime: Int16 = 0
    var bestTime: CGFloat = 0
    var width: CGFloat = 0
    var height: CGFloat = 0
    var outputObjectList = [OutputObject]()
}

//MARK:- 导入物件
struct InputObject {
    var destroyable: Bool = false
    var type: Int16 = 0
    var x: CGFloat = 0
    var y: CGFloat = 0
}
//MARK:- 导入关卡
struct InputLevel {
    var repeatScore: Int16 = 20
    var completeScore: Int16 = 100
    var finishTime: CGFloat = 60
    var touchTimes: Int16 = 50
    var width: CGFloat = default_ground_size.width
    var height: CGFloat = default_ground_size.height
    var inputObjectList = [InputObject]()
}

//MARK:- 关卡管理类
class LevelData {
    
    //MARK:- 文件名
    private let fileName = "LevelData"
    
    //MARK:- document路径
    private lazy var documentPath: String = {
        let documentPathList = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return documentPathList[0] + "/" + self.fileName + ".plist"
    }()
    
    //MARK:- 本地路径
    private lazy var localPath: String = {
        guard let lPath: String = Bundle.main.path(forResource: self.fileName, ofType: "plist") else{
            return ""
        }
        return lPath
    }()
    
    //MARK:- 读取文件
    private var originData: NSMutableDictionary{
        let fileManager = FileManager.default
        let fileExist = fileManager.fileExists(atPath: documentPath)
        var result: NSMutableDictionary!
        if fileExist {
            result = NSMutableDictionary(contentsOfFile: documentPath)
        }else{
            result = NSMutableDictionary(contentsOfFile: localPath)
        }
        return result
    }
    
    //MARK:- 获取单例
    private static let __once = LevelData()
    class func share()->LevelData{
        return __once
    }
    
    //MARK:- init
    private init(){
        
    }

    //MARK:- 根据关卡获取内容
    func select(world: WorldType = .field, level lev: Int16) -> OutputLevel?{
        guard let level:NSDictionary = (originData.value(forKey: world.rawValue) as? NSDictionary)?.value(forKey: "\(lev)") as? NSDictionary else{
            return nil
        }
        
        let completed = level.value(forKey: "completed") as? Int16 ?? 0
        var score = level.value(forKey: "repeatScore") as? Int16 ?? 0
        
        var completionStatus: CompletionStatus!
        switch completed {
        case 0:
            completionStatus = .undone
            score = level.value(forKey: "completeScore") as? Int16 ?? 0
        case 1:
            completionStatus = .normal
        case 2:
            completionStatus = .good
        case 3:
            completionStatus = .perfect
        default:
            break
        }
        
        var outputObjectList = [OutputObject]()
        let objectList = level.value(forKey: "objects") as! NSArray
        objectList.forEach(){
            body in
            if let obj: NSDictionary = body as? NSDictionary{
                let destroyable = obj.value(forKey: "destroyable") as! Bool
                if completed == 0 || (!destroyable && completed != 0){
                    var object = OutputObject()
                    object.type = obj.value(forKey: "type") as? Int16 ?? 0
                    object.x = obj.value(forKey: "x") as? CGFloat ?? 0
                    object.y = obj.value(forKey: "y") as? CGFloat ?? 0
                    outputObjectList.append(object)
                }
            }
        }
        
        //返回
        var outputLevel = OutputLevel()
        outputLevel.completionStatus = completionStatus
        outputLevel.score = score
        outputLevel.finishTime = level.value(forKey: "finishTime") as? CGFloat ?? 60    //默认关卡时间
        outputLevel.bestTime = level.value(forKey: "bestTime") as? CGFloat ?? 0
        outputLevel.outputObjectList = outputObjectList
        outputLevel.width = level.value(forKey: "width") as? CGFloat ?? default_ground_size.width
        outputLevel.height = level.value(forKey: "height") as? CGFloat ?? default_ground_size.height
        return outputLevel
    }
    
    //MARK:- 获取所有关卡
    func selectAllLevels() -> [WorldType: [Int16: OutputLevel]]{
        var fieldMap = [Int16: OutputLevel]()
        (0..<getLevelsCount(world: .field)).forEach(){
            index in
            let level = index + 1
            let outputLevel = select(world: .field, level: level)
            fieldMap[level] = outputLevel
        }
        
        var castleMap = [Int16: OutputLevel]()
        (0..<getLevelsCount(world: .castle)).forEach(){
            index in
            let level = index + 1
            let outputLevel = select(world: .castle, level: level)
            castleMap[level] = outputLevel
        }
        
        var worldMap = [WorldType: [Int16: OutputLevel]]()
        worldMap[.field] = fieldMap
        worldMap[.castle] = castleMap
        return worldMap
    }
    
    //修改关卡完成度 stars:完成等级 0:未完成 1:完成 2:完成 3:完美完成
    func complete(world: WorldType = .field, level lev: Int16, stars: Int16, bestfinishTime: Int16, completed: ((Bool)->())? = nil) {
        
        guard let curWorld: NSMutableDictionary = originData.value(forKey: world.rawValue) as? NSMutableDictionary else {
            return
        }
        
        guard let level: NSMutableDictionary = curWorld.value(forKey: "\(lev)") as? NSMutableDictionary else{
            return
        }
        level.setValue(stars, forKey: "completed")
        level.setValue(bestfinishTime, forKey: "bestfinishTime")
        curWorld.setValue(level, forKey: "\(lev)")
        
        let data = originData
        data.setValue(curWorld, forKey: world.rawValue)
        guard data.write(toFile: documentPath, atomically: true) else{
            completed?(false)
            return
        }
        completed?(true)
    }
    
    //MARK:- 添加与编辑关卡
    func update(world: WorldType = .field, level lev: Int16, inputObject: InputLevel, completed: (Bool)->()){
        
        let level = NSMutableDictionary()
        level.setValue(inputObject.repeatScore, forKey: "repeatScore")
        level.setValue(inputObject.completeScore, forKey: "completeScore")
        level.setValue(inputObject.finishTime, forKey: "finishTime")
        level.setValue(inputObject.touchTimes, forKey: "touchTimes")
        level.setValue(0, forKey: "bestfinishTime")
        level.setValue(inputObject.width, forKey: "width")
        level.setValue(inputObject.height, forKey: "height")
        level.setValue(CompletionStatus.undone.rawValue, forKey: "completed")

        let objects = NSMutableArray()
        inputObject.inputObjectList.forEach(){
            inputObject in
            
            let object = NSMutableDictionary()
            object.setValue(inputObject.destroyable, forKey: "destroyable")
            object.setValue(inputObject.type, forKey: "type")
            object.setValue(inputObject.x, forKey: "x")
            object.setValue(inputObject.y, forKey: "y")
            objects.add(object)
        }
        level.setValue(objects, forKey: "objects")

        let curWorld: NSMutableDictionary = originData.value(forKey: world.rawValue) as? NSMutableDictionary ?? NSMutableDictionary()
        curWorld.setValue(level, forKey: "\(lev)")

        let data = originData
        data.setValue(curWorld, forKey: world.rawValue)
        
        guard data.write(toFile: documentPath, atomically: true) else {
            completed(false)
            return
        }
        completed(true)
    }
    
    //获取原始关卡
    func get(world: WorldType, level lev: Int16) -> InputLevel? {
        guard let curWorld: NSDictionary = originData.value(forKey: world.rawValue) as? NSDictionary else {
            return nil
        }
        
        guard let curLevel = curWorld.value(forKey: "\(lev)") as? NSDictionary else {
            return nil
        }
        
        var inputLevel = InputLevel()
        inputLevel.completeScore = curLevel.value(forKey: "completeScore") as? Int16 ?? 0
        inputLevel.repeatScore = curLevel.value(forKey: "repeatScore") as? Int16 ?? 0
        inputLevel.finishTime = curLevel.value(forKey: "finishTime") as? CGFloat ?? 60
        inputLevel.touchTimes = curLevel.value(forKey: "touchTimes") as? Int16 ?? 0
        inputLevel.width = curLevel.value(forKey: "width") as? CGFloat ?? default_ground_size.width
        inputLevel.height = curLevel.value(forKey: "height") as? CGFloat ?? default_ground_size.height
        
        var objectList = [InputObject]()
        (curLevel.value(forKey: "objects") as! NSArray).forEach(){
            body in
            
            if let object: NSDictionary = body as? NSDictionary{
                
                var inputObject = InputObject()
                inputObject.destroyable = object.value(forKey: "destroyable") as? Bool ?? false
                inputObject.type = object.value(forKey: "type") as? Int16 ?? 0
                inputObject.x = object.value(forKey: "x") as? CGFloat ?? 0
                inputObject.y = object.value(forKey: "y") as? CGFloat ?? 0
                objectList.append(inputObject)
            }
        }
        inputLevel.inputObjectList = objectList
        return inputLevel
    }
    
    //MARK:- 获取所有关卡
    func getAllLevel() -> [WorldType: [Int16: InputLevel]] {
        var fieldMap = [Int16: InputLevel]()
        (0..<getLevelsCount(world: .field)).forEach(){
            index in
            let level = index + 1
            let inputLevel = get(world: .field, level: level)

            fieldMap[level] = inputLevel
        }
        
        var castleMap = [Int16: InputLevel]()
        (0..<getLevelsCount(world: .castle)).forEach(){
            index in
            let level = index + 1
            let inputLevel = get(world: .castle, level: level)
            castleMap[level] = inputLevel
        }
        
        var worldMap = [WorldType: [Int16: InputLevel]]()
        worldMap[.field] = fieldMap
        worldMap[.castle] = castleMap
        return worldMap
    }
    
    private func getLevelsCount(world: WorldType) -> Int16{
        guard let curWorld: NSDictionary = originData.value(forKey: world.rawValue) as? NSDictionary else {
            return 0
        }
        
        return Int16(curWorld.count)
    }
}
