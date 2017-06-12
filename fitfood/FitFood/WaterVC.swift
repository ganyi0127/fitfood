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
        //存储数据
        
        
        super.accept(sender: sender)
    }
}
