//
//  Level.swift
//  Kingdoms
//
//  Created by YiGan on 06/02/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import Foundation
class Level {
    //文件名
    private let plistName = "Level"
    
    //包路径
    private lazy var path: String = {
        guard let pathStr = Bundle.main.path(forResource: self.plistName, ofType: "plist") else{
            return ""
        }
        return pathStr
    }()
    
    //文件路径
    private lazy var documentPath: String = {
        let documentpaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentpath:AnyObject = documentpaths[0] as AnyObject
        return documentpath.appendingPathComponent("/\(self.plistName).plist")
    }()
    
    //获取文件字典
    private lazy var mutableDictionary: NSMutableDictionary = {
        let fileManager = FileManager.default
        let fileExists = fileManager.fileExists(atPath: self.documentPath)
        var dict: NSMutableDictionary
        if fileExists {
            dict = NSMutableDictionary(contentsOfFile: self.documentPath)!
        }else{
            dict = NSMutableDictionary(contentsOfFile: self.path)!
        }
        return dict
    }()
    
    //转换文件字典 final
    lazy var dictionary: [Int: [[Int]]] = {
        
        var result = [Int: [[Int]]]()
        self.mutableDictionary.forEach(){
            level, levelValue in
            let levelIndex = level as! Int
            let levelValues = levelValue as! NSArray
            
            var levelList = [[Int]]()
            levelValues.forEach(){
                element in
                let waves = element as! NSArray
                
                var waveList = [Int]()
                waves.forEach(){
                    enemy in
                    let enemyRaw = enemy as! Int
                    waveList.append(enemyRaw)
                }
                levelList.append(waveList)
            }
            result[levelIndex] = levelList
        }
        return result
    }()
    
    
    //MARK:- init
    static var instance: Level = Level()
    class var share: Level {
        return instance
    }
    
    //MARK:- 根据关卡获取内容
    func getData(fromLevel level: Int) -> [[Int]]{
        guard let data = dictionary[level] else{
            return [[Int]]()
        }
        return data
    }
}
