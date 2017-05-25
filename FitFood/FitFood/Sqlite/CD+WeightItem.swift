//
//  CD+Weight.swift
//  FitFood
//
//  Created by YiGan on 25/05/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import Foundation
import CoreData
extension CoredataHandler{
    //获取 user
    func currentWeight() -> Float? {
        return selectUser()
    }
    
    //插入
    private func insertWeight() -> Weight?{
        
        let userId = UserManager.share().userId
        
        //判断user是否存在，否则创建
        let weight = NSEntityDescription.insertNewObject(forEntityName: "Weight", into: context) as? Weight

        
        guard commit() else {
            return nil
        }
        return user
    }
    
    //查找
    private func selectWeight(bylimit: Int) -> User?{
        
        let userId = UserManager.share().userId
        
        let request: NSFetchRequest<User> = User.fetchRequest()
        let predicate = NSPredicate(format: "userId == \(userId)")
        
        request.predicate = predicate
        
        do{
            let resultList = try context.fetch(request)
            if resultList.isEmpty {
                return insertUser()
            }else{
                return resultList.first
            }
        }catch let error{
            fatalError("<Core Data> fetch error: \(error)")
        }
        return nil
    }
}
