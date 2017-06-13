//
//  SportVC.swift
//  FitFood
//
//  Created by YiGan on 21/05/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class SportVC: SubVC {
    override func viewDidLoad() {
        config()
        createContents()
    }
    
    override func config(){
        super.config()
        
    }
    
    override func createContents(){
        super.createContents()
        
        recordTV = RecordTV(withRecordType: .sport)
        view.addSubview(recordTV!)
    }
    
    override func accept(sender: UIButton) {
        //存储数据
        guard let sportType = RecordTV.sportType, let sportDuration = RecordTV.sportDuration, let sportDate = RecordTV.sportDate else {
            showNotif(withTitle: "需补全内容", duration: 2, closure: nil)
            return
        }
        
        _ = coredataHandler.addSportItem(withType: sportType.rawValue, durationSec: sportDuration, date: sportDate)
        
        super.accept(sender: sender)
    }
}
