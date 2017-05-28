//
//  SubVC.swift
//  FitFood
//
//  Created by YiGan on 21/05/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class SubVC: UIViewController {
    override func viewDidLoad() {
        config()
        createContents()
    }
    
    func config(){
        
    }
    
    func createContents(){
        
        //添加返回按钮
        let backButtonFrame = CGRect(x: 8, y: 8, width: 40, height: 40)
        let backButton = UIButton(frame: backButtonFrame)
        backButton.setTitle("<", for: .normal)
        backButton.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        view.addSubview(backButton)
    }
    
    //MARK:- 返回到首页
    @objc private func back(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
}
