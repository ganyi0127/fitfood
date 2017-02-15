//
//  Font.swift
//  FontLib
//
//  Created by YiGan on 23/01/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class Font{
    private let path = Bundle.main.path(forResource: "Font", ofType: "plist")
    
    var red: CGFloat {
        return readDictionary()["red"] as! CGFloat
    }
    var green: CGFloat{
        return readDictionary()["green"] as! CGFloat
    }
    var blue: CGFloat{
        return readDictionary()["blue"] as! CGFloat
    }
    var size: CGFloat{
        return readDictionary()["size"] as! CGFloat
    }
    var text: String{
        return readDictionary()["text"] as! String
    }
    var fontname: String{
        return readDictionary()["fontname"] as! String
    }
    
    //MARK:- init
    static var instance: Font = Font()
    class var share: Font {
        return instance
    }
    
    private func documentPath() -> String{
        let documentpaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentpath:AnyObject = documentpaths[0] as AnyObject
        return documentpath.appendingPathComponent("/Font.plist")
    }
    
    private func readDictionary() -> [String: Any]{
        let dict = readMutableDictionary()
        
        var result = [String: Any]()
        dict.forEach(){
            key, value in
            let keyStr = String(describing: key)

            result[keyStr] = value
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
    
    //MARK:- 存储颜色
    func updateColor(red: CGFloat, green: CGFloat, blue: CGFloat, fontSize size: CGFloat, wordText text: String){
        let dict = readMutableDictionary()
        dict.setValue(red, forKey: "red")
        dict.setValue(green, forKey: "green")
        dict.setValue(blue, forKey: "blue")
        dict.setValue(size, forKey: "size")
        dict.setValue(text, forKey: "text")
        dict.write(toFile: documentPath(), atomically: true)
    }
    
    //MARK:- 更新字体
    func update(fontname name: String){
        let dict = readMutableDictionary()
        dict.setValue(name, forKey: "fontname")
        dict.write(toFile: documentPath(), atomically: true)
    }
}
