//
//  CatInformation.swift
//  Alone
//
//  Created by YiGan on 03/12/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import Foundation
class CatInformation {
    
    struct Range {
        var energy: Int16 = 0
    }
    //MARK:- 文件名
    private let fileName = "CatInformation"
    
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
    private var data: NSDictionary{
        let fileManager = FileManager.default
        let fileExist = fileManager.fileExists(atPath: documentPath)
        var result: NSDictionary!
        if fileExist {
            do{
                try fileManager.removeItem(atPath: localPath)
            }catch let error{
                debugPrint("error: ", error)
            }
            result = NSDictionary(contentsOfFile: documentPath)
        }else{
            result = NSDictionary(contentsOfFile: localPath)
        }
        return result
    }
    
    //MARK:- 获取单例
    private static let __once = CatInformation()
    class func share()->CatInformation{
        return __once
    }
    
    //MARK:- init
    private init(){
        
    }
    
    //获取默认值
    func range(type: Int16) -> Range{
        guard let cat = data.value(forKey: "\(type)") else{
            var range = Range()
            range.energy = 0
            return range
        }
        var range = Range()
        range.energy = (cat as! NSDictionary).value(forKey: "energyRange") as! Int16
        return range
    }
}
