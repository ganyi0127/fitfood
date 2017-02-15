//
//  Background.swift
//  Kingdoms
//
//  Created by YiGan on 2017/2/3.
//  Copyright © 2017年 YiGan. All rights reserved.
//

import SpriteKit
class Background: SKNode {
    
    //天空
    private lazy var sky: SKSpriteNode = {
        let tex = SKTexture(imageNamed: "resource/background/background")
        return SKSpriteNode(texture: tex)
    }()
    
    //场景
    private lazy var ground: Ground = {
        return Ground()
    }()
    
    //波次
    private var wave = 0
    
    //MARK:- init
    override init(){
        super.init()
        
        config()
        createContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config(){
        
        position = .zero
        
        notify_manager.addObserver(self, selector: #selector(message(notify:)), name: notify_cubes, object: nil)
    }
    
    private func createContents(){
        
        //添加背景
        addChild(sky)
        
        //添加场景
        addChild(ground)
    }
    
    //MARK:- 接收操作消息
    @objc private func message(notify: Notification){
        let userInfo = notify.userInfo
        debugPrint("userInfo:", userInfo!)
    }
    
    //MARK:- 下一波
    func nextWave(){
        wave += 1
        ground.next(wave: wave){
            complete in
            if complete{
                //后面已无波数
            }
        }
    }
    
    //MARK:- update
    func update(_ currentTime: TimeInterval) {
        
        ground.update(currentTime)
    }
}
