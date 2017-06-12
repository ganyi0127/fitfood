//
//  AppDelegate.swift
//  FitFood
//
//  Created by YiGan on 12/05/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //崩溃处理
        NSSetUncaughtExceptionHandler(customUncaughtExceptionHandler())
        
        return true
    }
    
    //MARK:- 崩溃回调
    func customUncaughtExceptionHandler() -> @convention(c) (NSException) -> Void{
        return {
            (exception) -> Void in
            
            let stack = exception.callStackSymbols    //栈信息
            let reason = exception.reason
            let name = exception.name
            
            _ = "<exception> type: \(name), reason: \(String(describing: reason)), stackInfo:  \(stack))"
            
            //存储或反馈错误信息
        }
    }

    //MARK:- 状态切换
    func applicationWillResignActive(_ application: UIApplication) {
        debugPrint("__will resign active")
    }

    //MARK:- 进入后台
    func applicationDidEnterBackground(_ application: UIApplication) {
        debugPrint("__did enter background")
    }

    //MARK:- 进入前台
    func applicationWillEnterForeground(_ application: UIApplication) {
        debugPrint("__will enter foreground")
    }

    //MARK:-
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    //MARK:- 程序终止
    func applicationWillTerminate(_ application: UIApplication) {
        _ = CoredataHandler.share().commit()
    }
}

