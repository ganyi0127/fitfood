//
//  FoodVC.swift
//  FitFood
//
//  Created by YiGan on 21/05/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class FoodVC: SubVC {
    override func viewDidLoad() {
        config()
        createContents()
    }
    
    override func config(){
        super.config()
        
    }
    
    override func createContents(){
        super.createContents()
        
        recordTV = RecordTV(withRecordType: .food)
        view.addSubview(recordTV!)
    }
    
    override func accept(sender: UIButton) {
        //判断空值
        guard let foodCategory = RecordTV.foodCategory, let foodSubType = RecordTV.food, let foodAmountG = RecordTV.foodAmountG, let foodDate = RecordTV.foodDate else {
            showNotif(withTitle: "需补全内容", duration: 2, closure: nil)
            return
        }
        
        //判断数值是否合法
        guard foodCategory == foodSubType.category else {
            showNotif(withTitle: "需根据食物类型重新选择食物", duration: 2, closure: nil)
            return
        }
        
        //存储数据
        if coredataHandler.executable() {
            _ = coredataHandler.addFoodItem(withFood: foodSubType, amountG: foodAmountG, date: foodDate)
        }else {
            showNotif(withTitle: "需添加初始体重", duration: 2, closure: nil)
        }
        super.accept(sender: sender)
    }
}
