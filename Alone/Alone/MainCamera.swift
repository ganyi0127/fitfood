//
//  MainCamera.swift
//  Alone
//
//  Created by YiGan on 05/12/2016.
//  Copyright © 2016 YiGan. All rights reserved.
//

import SpriteKit
class MainCamera: SKCameraNode {
    
//    var pauseLayer:PauseLayer?
    
    override init() {
        super.init()
        
        config()
        createContents()
    }
    
    private func config(){
        name = "camera"
    }
    
    private func createContents(){
        
    }
    
    func setPosition(sceneSize: CGSize, deltaPosition: CGSize = .zero){
        
        position = CGPoint(x: position.x + deltaPosition.width, y: position.y + deltaPosition.height)
        
        if position.x + win_size.width / 2 * 0 > sceneSize.width {
            position.x = sceneSize.width - win_size.width / 2 * 0
        }else if position.x - win_size.width / 2 < 0{
            position.x = win_size.width / 2
        }
        
        if position.y + win_size.height / 2 > sceneSize.height {
            position.y = sceneSize.height - win_size.height / 2
        }else if position.y - win_size.height / 2 < 0{
            position.y = win_size.height / 2
        }
    }
    
//    func setPauseLayerAppear(displayPauseLayer isDisplay:Bool, transitionScene transition:Bool = false){
//        if isDisplay{
//            pauseLayer = PauseLayer()
//            addChild(pauseLayer!)
//        }else{
//            pauseLayer?.removeFromParent()
//            pauseLayer = nil
//            if transition{
//                (scene as! GameScene).endGame()
//            }
//        }
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
