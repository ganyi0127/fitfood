//
//  Time.swift
//  Kingdoms
//
//  Created by YiGan on 2017/1/28.
//  Copyright © 2017年 YiGan. All rights reserved.
//

import Foundation
typealias Task = (_ cancel: Bool)->()
func delay(_ time: TimeInterval, task: @escaping ()->()) -> Task?{
    func dispathLater(_ block: @escaping ()->()){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: block)
    }
    
    var closure: (()->())? = task
    var result: Task?
    
    let delayedClosure: Task = {
        cancel in
        if let internalClosure = closure {
            if !cancel {
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
        closure = nil
        result = nil
    }
    
    result = delayedClosure
    
    dispathLater {
        if let delayedClosure = result{
            delayedClosure(false)
        }
    }
    
    return result
}

func cancel(_ task: Task?){
    task?(true)
}
