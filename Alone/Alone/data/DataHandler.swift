//
//  DataHandler.swift
//  Alone
//
//  Created by YiGan on 03/12/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import Foundation
import CoreData

class DataHandler{
    
    //数据库错误信息
    private enum GodError: Error{
        case fetchNoResult
    }
    
    //coredata-context
    fileprivate lazy var context: NSManagedObjectContext = {
        let ctx = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        ctx.persistentStoreCoordinator = self.persistentStoreCoordinator
        return ctx
    }()
    
    // MARK: - Core Data stack
    private lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    //MARK:- 加载编译后数据模型路径 momd
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "Model", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    //MARK:- 设置数据库写入路径 并范围数据库协调器
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("alone.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            
            debugPrint("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    //MARK:- 获取单例
    private static let __once = DataHandler()
    class func share() -> DataHandler{
        return __once
    }
    
    private init(){
        
    }
    
    // MARK: - Core Data Saving support
    public func commit() -> Bool{
        if context.hasChanges {
            do {
                try context.save()
                return true
            } catch let error {
                debugPrint("commit error: ", error)
            }
            return false
        }
        return false
    }
    
    public func reset() -> Bool{
        if context.hasChanges {
            context.reset()
            return true
        }
        return false
    }
    
    //MARK:- *删* deleteTable by condition
    fileprivate func delete(_ tableClass: NSManagedObject.Type, byConditionFormat conditionFormat: String) throws {
        
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "\(tableClass.self)", in: context)
        request.entity = entityDescription
        
        let predicate = NSPredicate(format: conditionFormat, "")
        request.predicate = predicate
        
        let resultList = try context.fetch(request) as! [NSManagedObject]
        if resultList.isEmpty {
            throw GodError.fetchNoResult
        }else{
            
            context.delete(resultList[0])
            guard commit() else{
                return
            }
        }
    }
}

//MARK:- 用户
extension DataHandler{
    
    private func insertUser(using: (_ success: Bool, User?)->()){
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "User", in: context)
        let user = User(entity: entityDescription!, insertInto: context)
        guard commit() else {
            using(false, nil)
            return
        }
        using(true, user)
    }
    
    //选择用户 为空则自动插入
    func selectUser(using: (User)->(), failure: (String)->()){
        let request: NSFetchRequest<User> = User.fetchRequest()
        let predicate = NSPredicate()
        request.predicate = predicate
        
        do{
            let resultList = try context.fetch(request)
            if resultList.isEmpty {
                insertUser(){
                    success, user in
                    if success{
                        using(user!)
                    }else{
                        failure("commit user failed")
                    }
                }
            }else{
                using(resultList[0])
                return
            }
        }catch let error{
            failure("\(error)")
        }
    }
}

//MARK:- 猫
extension DataHandler{
    private func insertCat(type: Int16, using: (_ success: Bool, Cat?)->()){
        //判断user是否存在
        let entityDescription = NSEntityDescription.entity(forEntityName: "Cat", in: context)
        let cat = Cat(entity: entityDescription!, insertInto: context)
        cat.type = type                    //类型
        cat.level = 1                      //等级
        cat.ranking = 0                    //排名
        cat.birthday = Date() as NSDate?   //生日
        cat.energy = Int16(Float(CatInformation.share().range(type: type).energy) * 0.8)       //初始80%精力
        
        guard commit() else {
            using(false, nil)
            return
        }
        using(true, cat)
    }
    
    //根据type选择cat 为空则自动插入
    func selectCat(type: Int16, using: (Cat)->(), failure: (String)->()) {
        
        let request: NSFetchRequest<Cat> = Cat.fetchRequest()
        let predicate = NSPredicate(format: "type = \(type)", "")
        request.predicate = predicate
        
        do{
            let resultList = try context.fetch(request)
            if resultList.isEmpty {
                insertCat(type: type){
                    success, cat in
                    if success{
                        using(cat!)
                    }else{
                        failure("commit new cat failure")
                    }
                }
            }else{
                using(resultList[0])
            }
        }catch let error{
            failure("\(error)")
        }
    }
    
    //根据type删除cat
    func deleteCat(type: Int16, complete: (Bool)->()){
        do{
            try delete(Cat.self, byConditionFormat: "type = \(type)")
            complete(true)
        }catch _{
            complete(false)
        }
    }
}
