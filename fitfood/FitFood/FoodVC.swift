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
        guard let foodType = RecordTV.foodType, let foodSubType = RecordTV.foodSubType, let foodAmountG = RecordTV.foodAmountG, let foodDate = RecordTV.foodDate else {
            showNotif(withTitle: "需补全内容", duration: 2, closure: nil)
            return
        }
        
        //判断数值是否合法
        guard foodType == foodSubType.category else {
            showNotif(withTitle: "需根据食物类型重新选择食物", duration: 2, closure: nil)
            return
        }
        
        //存储数据
        _ = coredataHandler.addFoodItem(withType: foodType.rawValue, subType: foodSubType.serial!, amountG: foodAmountG, date: foodDate)
        
        super.accept(sender: sender)
    }
}
