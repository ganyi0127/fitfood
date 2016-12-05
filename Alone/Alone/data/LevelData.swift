//
//  Data.swift
//  Alone
//
//  Created by YiGan on 02/12/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import UIKit
//MARK:- 世界类型
enum World: String{
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
    var repeatScore: Int16 = 0
    var completeScore: Int16 = 0
    var finishTime: CGFloat = 0
    var touchTimes: Int16 = 0
    var width: CGFloat = 0
    var height: CGFloat = 0
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
    private var data: NSMutableDictionary{
        let fileManager = FileManager.default
        let fileExist = fileManager.fileExists(atPath: documentPath)
        var result: NSMutableDictionary!
        if fileExist {
            do{
                try fileManager.removeItem(atPath: localPath)
            }catch let error{
                debugPrint("error: ", error)
            }
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
    func select(world: World = .field, level lev: Int, using: (OutputLevel)->()){
        guard let level:NSDictionary = (data.value(forKey: world.rawValue) as? NSDictionary)?.value(forKey: "\(lev)") as? NSDictionary else{
            return
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
        using(outputLevel)
    }
    
    //修改关卡完成度 stars:完成等级 0:未完成 1:完成 2:完成 3:完美完成
    func complete(world: World = .field, level lev: Int16, stars: Int16, bestfinishTime: Int16, completed: ((Bool)->())? = nil) {
        
        guard let curWorld: NSMutableDictionary = data.value(forKey: world.rawValue) as? NSMutableDictionary else {
            return
        }
        
        guard let level: NSMutableDictionary = curWorld.value(forKey: "\(lev)") as? NSMutableDictionary else{
            return
        }
        level.setValue(stars, forKey: "completed")
        level.setValue(bestfinishTime, forKey: "bestfinishTime")
        curWorld.setValue(level, forKey: "\(lev)")
        data.setValue(curWorld, forKey: world.rawValue)
        guard data.write(toFile: documentPath, atomically: true) else{
            completed?(false)
            return
        }
        completed?(true)
    }
    
    //MARK:- 添加与编辑关卡
    func update(world: World = .field, level lev: Int16, inputObject: InputLevel, completed: (Bool)->()){
        
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
        
        let curWorld: NSMutableDictionary = data.value(forKey: world.rawValue) as? NSMutableDictionary ?? NSMutableDictionary()
        curWorld.setValue(level, forKey: "\(lev)")
        data.setValue(curWorld, forKey: world.rawValue)
        guard data.write(toFile: documentPath, atomically: true) else {
            completed(false)
            return
        }
        completed(true)
    }
    
    //获取原始关卡
    func get(world: World, level lev: Int16, using: (InputLevel)->()) {
        guard let curWorld: NSDictionary = data.value(forKey: world.rawValue) as? NSDictionary else {
            return
        }
        
        guard let curLevel = curWorld.value(forKey: "\(lev)") as? NSDictionary else {
            return
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
        using(inputLevel)
    }
}
