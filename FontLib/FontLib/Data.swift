//
//  Data.swift
//  FontLib
//
//  Created by YiGan on 22/01/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import Foundation
class Data {
    
    private let path = Bundle.main.path(forResource: "Data", ofType: "plist")
    private let favoriteKey = "favoritelist"
    
    var favoriteList: [String] {
        guard let list = readDictionary()[favoriteKey] else{
            return []
        }
        return list
    }
    
    //MARK:- init
    static var instance: Data = Data()
    class var share: Data {
        return instance
    }
    
    private func documentPath() -> String{
        let documentpaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentpath:AnyObject = documentpaths[0] as AnyObject
        return documentpath.appendingPathComponent("/Data.plist")
    }
    
    private func readDictionary() -> [String: [String]]{
        let dict = readMutableDictionary()
        
        var result = [String: [String]]()
        dict.forEach(){
            key, value in
            let keyStr = String(describing: key)
            let valueList = value as! NSArray
            var array = [String]()
            for name in valueList{
                array.append(name as! String)
            }
            result[keyStr] = array
        }
        return result
    }
    
    private func readMutableDictionary() -> NSMutableDictionary{
        let fileManager = FileManager.default
        let fileExists = fileManager.fileExists(atPath: documentPath())
        var dict: NSMutableDictionary?
        if fileExists {
            dict = NSMutableDictionary(contentsOfFile: documentPath())
        }else{
            dict = NSMutableDictionary(contentsOfFile: path!)
        }
        return dict!
    }
    
    //MARK:- 添加喜欢的字体
    func add(newFont fontName: String){
        guard !favoriteList.contains(fontName) else {
            return
        }
        
        let list = NSMutableArray(array: favoriteList)
        list.add(fontName)
        
        write(favoriteArray: list)
    }
    
    //MARK:- 移除喜欢的字体
    func delete(font fontName: String){
        guard favoriteList.contains(fontName) else {
            return
        }
        
        let list = NSMutableArray(array: favoriteList)
        list.remove(fontName)
        
        write(favoriteArray: list)
    }
    
    //MARK:- 写入数据
    private func write(favoriteArray array: NSMutableArray){
        let dict = readMutableDictionary()
        dict.setValue(array, forKey: favoriteKey)
        
        dict.write(toFile: documentPath(), atomically: true)
    }
}
