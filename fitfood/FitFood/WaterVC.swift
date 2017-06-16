//
//  WaterVC.swift
//  FitFood
//
//  Created by YiGan on 21/05/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class WaterVC: SubVC {
    override func viewDidLoad() {
        config()
        createContents()
    }
    
    override func config(){
        super.config()
        
    }
    
    override func createContents(){
        super.createContents()
        
        recordTV = RecordTV(withRecordType: .water)
        view.addSubview(recordTV!)
    }
    
    override func accept(sender: UIButton) {
        guard let waterAmountG = RecordTV.waterAmountG, let waterDate = RecordTV.waterDate else {
            showNotif(withTitle: "需补全内容", duration: 2, closure: nil)
            return
        }
        
        //存储数据
        if coredataHandler.executable() {
            _ = coredataHandler.addWaterItem(withAmountML: waterAmountG, date: waterDate)
        }else {
            showNotif(withTitle: "需添加初始体重", duration: 2, closure: nil)
        }
        
        super.accept(sender: sender)
    }
}
