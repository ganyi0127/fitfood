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
        //存储数据
        guard let foodType = RecordTV.foodType, let foodSubType = RecordTV.foodSubType, let foodAmountG = RecordTV.foodAmountG, let foodDate = RecordTV.foodDate else {
            showNotif(withTitle: "需补全内容", duration: 2, closure: nil)
            return
        }                
        
        _ = coredataHandler.addFoodItem(withType: foodType, subType: foodSubType, amountG: foodAmountG, date: foodDate)
        
        super.accept(sender: sender)
    }
}
