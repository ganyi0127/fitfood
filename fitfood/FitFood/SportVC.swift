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
        guard let sport = RecordTV.sport, let sportDuration = RecordTV.sportDuration, let sportDate = RecordTV.sportDate else {
            showNotif(withTitle: "需补全内容", duration: 2, closure: nil)
            return
        }
        
        //存储数据
        if coredataHandler.executable() {
            _ = coredataHandler.addSportItem(withSport: sport, durationSec: sportDuration, date: sportDate)
        }else {
            showNotif(withTitle: "需添加初始体重", duration: 2, closure: nil)
        }
        
        super.accept(sender: sender)
    }
}
