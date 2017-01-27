//
//  WorldScene.swift
//  Alone
//
//  Created by YiGan on 07/12/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit
class WorldScene: SKScene {
    
    fileprivate let worlds = Worlds()           //沙盘
    
    //手势
    private var leftSwipe: UISwipeGestureRecognizer?
    private var rightSwipe: UISwipeGestureRecognizer?
    
    //MARK:- init
    override func didMove(to view: SKView) {
        
        config()
        createContents()
    }
    
    deinit {
        if let lSwipe = leftSwipe, let rSwipe = rightSwipe{
            view?.removeGestureRecognizer(lSwipe)
            view?.removeGestureRecognizer(rSwipe)
        }
    }
    
    private func config(){
        
        leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipt(gesture:)))
        leftSwipe?.direction = .left
        view?.addGestureRecognizer(leftSwipe!)
        
        rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipt(gesture:)))
        rightSwipe?.direction = .right
        view?.addGestureRecognizer(rightSwipe!)
    }
    
    private func createContents(){
        
        //创建家园按钮
        let homeButton = Button(type: .home){
            _ in
            if let homeScene = SKScene(fileNamed: "HomeScene"){
                homeScene.scaleMode = .aspectFill
                self.view?.presentScene(homeScene)
            }
        }
        homeButton.position = CGPoint(x: win_size.width - homeButton.size.width, y: win_size.height - homeButton.size.height)
        addChild(homeButton)
        
        //创建沙盘
        worlds.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(worlds)
    }
    
    //MARK:- 滑动worlds
    @objc private func swipt(gesture: UISwipeGestureRecognizer){
        var worldX = worlds.position.x
        if gesture.direction == .left {
            worldX -= worlds.interval
        }else if gesture.direction == .right{
            worldX += worlds.interval
        }
        if worldX > size.width / 2{
            worldX = size.width / 2
        }else if worldX < size.width / 2 - CGFloat(worlds.worldMap.count - 1) * worlds.interval{
            worldX = size.width / 2 - CGFloat(worlds.worldMap.count - 1) * worlds.interval
        }
        let movAct = SKAction.moveTo(x: worldX, duration: 0.2)
        movAct.timingMode = .easeInEaseOut
        worlds.run(movAct)
    }
}

//MARK:- 触摸事件
extension WorldScene{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
