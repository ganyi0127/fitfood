//
//  SubVC.swift
//  FitFood
//
//  Created by YiGan on 21/05/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class SubVC: UIViewController {
    
    var recordTV: RecordTV?
    
    
    override func viewDidLoad() {
        config()
        createContents()
    }
    
    func config(){
        
    }
    
    func createContents(){
        
        //添加返回按钮
        let backButtonFrame = CGRect(x: 8, y: 20, width: 40, height: 40)
        let backButton = UIButton(frame: backButtonFrame)
        backButton.setTitle("<", for: .normal)
        backButton.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        view.addSubview(backButton)
        
        //添加确认按钮
        let acceptButtonFrame = CGRect(x: view_size.width - 64, y: 20, width: 64, height: 44)
        let acceptButton = UIButton(frame: acceptButtonFrame)
        acceptButton.setTitle("v", for: .normal)
        acceptButton.addTarget(self, action: #selector(accept(sender:)), for: .touchUpInside)
        view.addSubview(acceptButton)
        
    }
    
    //MARK:- 提交修改
    @objc func accept(sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- 返回到首页
    @objc private func back(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
}
